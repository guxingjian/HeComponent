//
//  Heqingzhao_DUContext.m
//  HeComponent
//
//  Created by qingzhao on 2019/3/4.
//  Copyright © 2019年 qingzhao. All rights reserved.
//

#import "Heqingzhao_DUContext.h"
#import <objc/runtime.h>

static CGRect CGRectFromDictionary(NSDictionary* dictonary){
    return CGRectMake([[dictonary objectForKey:@"x"] floatValue], [[dictonary objectForKey:@"y"] floatValue], [[dictonary objectForKey:@"width"] floatValue], [[dictonary objectForKey:@"height"] floatValue]);
}

static NSDictionary* CGRectToDictionary(CGRect rect){
    NSMutableDictionary* dicRect = [NSMutableDictionary dictionary];
    [dicRect setObject:[NSNumber numberWithFloat:rect.origin.x] forKey:@"x"];
    [dicRect setObject:[NSNumber numberWithFloat:rect.origin.y] forKey:@"y"];
    [dicRect setObject:[NSNumber numberWithFloat:rect.size.width] forKey:@"width"];
    [dicRect setObject:[NSNumber numberWithFloat:rect.size.height] forKey:@"height"];
    
    return dicRect;
}

static CGSize CGSizeFromDictionary(NSDictionary* dictonary){
    return CGSizeMake([[dictonary objectForKey:@"width"] floatValue], [[dictonary objectForKey:@"height"] floatValue]);
}

static NSDictionary* CGSizeToDictionary(CGSize size){
    NSMutableDictionary* dicSize = [NSMutableDictionary dictionary];
    [dicSize setObject:[NSNumber numberWithFloat:size.width] forKey:@"width"];
    [dicSize setObject:[NSNumber numberWithFloat:size.height] forKey:@"height"];
    
    return dicSize;
}

static CGPoint CGPointFromDictionary(NSDictionary* dictonary){
    return CGPointMake([[dictonary objectForKey:@"x"] floatValue], [[dictonary objectForKey:@"y"] floatValue]);
}

static NSDictionary* CGPointToDictionary(CGPoint point){
    NSMutableDictionary* dicPoint = [NSMutableDictionary dictionary];
    [dicPoint setObject:[NSNumber numberWithFloat:point.x] forKey:@"x"];
    [dicPoint setObject:[NSNumber numberWithFloat:point.y] forKey:@"y"];
    
    return dicPoint;
}

static NSRange NSRangeFromDictionary(NSDictionary* dictonary){
    return NSMakeRange([[dictonary objectForKey:@"location"] floatValue], [[dictonary objectForKey:@"length"] floatValue]);
}

static NSDictionary* NSRangeToDictionary(NSRange range){
    NSMutableDictionary* dicRange = [NSMutableDictionary dictionary];
    [dicRange setObject:[NSNumber numberWithFloat:range.location] forKey:@"location"];
    [dicRange setObject:[NSNumber numberWithFloat:range.length] forKey:@"length"];
    
    return dicRange;
}

@interface Heqingzhao_DUContext()

@property(nonatomic, strong)NSMutableDictionary* dicClassSel;
@property(nonatomic, strong)NSMutableDictionary* dicJSCacheData;

@end

@implementation Heqingzhao_DUContext

+ (instancetype)sharedDUContext{
    static dispatch_once_t onceToken;
    static Heqingzhao_DUContext* duContext = nil;
    dispatch_once(&onceToken, ^{
        duContext = [[self alloc] init];
    });
    return duContext;
}

- (instancetype)init{
    if(self = [super init]){
        [self setupJSContext];
    }
    return self;
}

- (JSContext *)jsContext{
    if(!_jsContext){
        _jsContext = [[JSContext alloc] init];
    }
    return _jsContext;
}

- (NSMutableDictionary *)dicClassSel{
    if(!_dicClassSel){
        _dicClassSel = [NSMutableDictionary dictionary];
    }
    return _dicClassSel;
}

- (NSMutableDictionary *)dicJSCacheData{
    if(!_dicJSCacheData){
        _dicJSCacheData = [NSMutableDictionary dictionary];
    }
    return _dicJSCacheData;
}

- (void)exchangeOriginalClass:(NSString*)strClass instanceSelector:(NSString*)strSel {
    // 保证同一个方法只被swizzle一次
    NSString* cacheKey = [self cacheKeyWithCalss:strClass selector:strSel];
    if([self.dicClassSel objectForKey:cacheKey])
        return ;
    
    Class cls = NSClassFromString(strClass);
    
    NSString* strDuSel = [NSString stringWithFormat:@"du_%@", strSel];
    IMP duImp = class_getMethodImplementation(cls, NSSelectorFromString(strDuSel));
    
    Method originalMethod = class_getInstanceMethod(cls, NSSelectorFromString(strSel));
    IMP originImp = method_getImplementation(originalMethod);
    
    class_addMethod(cls, NSSelectorFromString(strDuSel), originImp, method_getTypeEncoding(originalMethod));
    method_setImplementation(originalMethod, duImp);
    
    [self.dicClassSel setObject:@"1" forKey:cacheKey];
}

- (void)setupJSContext{
    self.jsContext[@"js_NSLog"] = ^(NSString* str){
        NSLog(@"%@", str);
    };
    __weak typeof(self) weakSelf = self;
    self.jsContext[@"js_exchangeImplementation"] = ^(NSString* originalClass, NSString* originalSel){
        [weakSelf exchangeOriginalClass:originalClass instanceSelector:originalSel];
    };
    self.jsContext[@"js_msgSend"] = ^(id obj, NSString* sel, NSArray* args){
        return [weakSelf dynamicMsgSend:obj sel:sel args:args];
    };
    self.jsContext[@"js_msgSendSuper"] = ^(id obj, NSString* sel, NSArray* args){
        return [weakSelf dynamicMsgSendSuper:obj sel:sel args:args];
    };
    self.jsContext[@"js_classMsgSend"] = ^(NSString* clsName, NSString* sel, NSArray* args){
        return [weakSelf duClassMsgSend:clsName sel:sel args:args];
    };
}

- (id)duClassMsgSend:(NSString*)strCls sel:(NSString*)sel args:(NSArray*)args{
    Class cls = NSClassFromString(strCls);
    if(![cls isKindOfClass:[NSObject class]])
        return nil;
    
    Method method = class_getClassMethod(cls, NSSelectorFromString(sel));
    NSMethodSignature* signature = [NSMethodSignature signatureWithObjCTypes:method_getTypeEncoding(method)];
    NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setArgument:&cls atIndex:0];
    SEL originalSel = NSSelectorFromString(sel);
    [invocation setArgument:&originalSel atIndex:1];

    [self setMethodArgumentsWithInvocation:invocation args:args];
    [invocation invokeWithTarget:cls];
    return [self callMethodWithInvocation:invocation];
}

- (void)setMethodArgumentsWithInvocation:(NSInvocation*)invocation args:(NSArray*)args{
    for(NSInteger i = 2; i < invocation.methodSignature.numberOfArguments; ++ i){
        const char* argTypeBuf = [invocation.methodSignature getArgumentTypeAtIndex:i];
        char argType;
        if(argTypeBuf[0] == 'r'){
            argType = argTypeBuf[1];
        }else{
            argType = argTypeBuf[0];
        }
        if('c' == argType){
            char arg = [[args objectAtIndex:i-2] charValue];
            [invocation setArgument:&arg atIndex:i];
        }else if('i' == argType){
            int arg = [[args objectAtIndex:i-2] intValue];
            [invocation setArgument:&arg atIndex:i];
        }else if('s' == argType){
            short arg = [[args objectAtIndex:i-2] shortValue];
            [invocation setArgument:&arg atIndex:i];
        }else if('l' == argType){
            long arg = [[args objectAtIndex:i-2] longValue];
            [invocation setArgument:&arg atIndex:i];
        }else if('q' == argType){
            long long arg = [[args objectAtIndex:i-2] longLongValue];
            [invocation setArgument:&arg atIndex:i];
        }else if('C' == argType){
            unsigned char arg = [[args objectAtIndex:i-2] unsignedCharValue];
            [invocation setArgument:&arg atIndex:i];
        }else if('I' == argType){
            unsigned int arg = [[args objectAtIndex:i-2] unsignedIntValue];
            [invocation setArgument:&arg atIndex:i];
        }else if('S' == argType){
            unsigned short arg = [[args objectAtIndex:i-2] unsignedShortValue];
            [invocation setArgument:&arg atIndex:i];
        }else if('L' == argType){
            unsigned long arg = [[args objectAtIndex:i-2] unsignedLongValue];
            [invocation setArgument:&arg atIndex:i];
        }else if('Q' == argType){
            unsigned long long arg = [[args objectAtIndex:i-2] unsignedLongLongValue];
            [invocation setArgument:&arg atIndex:i];
        }else if('f' == argType){
            float arg = [[args objectAtIndex:i-2] floatValue];
            [invocation setArgument:&arg atIndex:i];
        }else if('d' == argType){
            double arg = [[args objectAtIndex:i-2] doubleValue];
            [invocation setArgument:&arg atIndex:i];
        }else if('B' == argType){
            BOOL arg = [[args objectAtIndex:i-2] boolValue];
            [invocation setArgument:&arg atIndex:i];
        }else if('@' == argType){
            id arg = [args objectAtIndex:i-2];
            [invocation setArgument:&arg atIndex:i];
        }else if(':' == argType){
            SEL arg = NSSelectorFromString([args objectAtIndex:i-2]);
            [invocation setArgument:&arg atIndex:i];
        }else if('#' == argType){
            Class arg = NSClassFromString([args objectAtIndex:i-2]);
            [invocation setArgument:&arg atIndex:i];
        }else if('*' == argType || '^' == argType){
            // to do ...
        }else if('{' == argType){
            NSString* strStructType = [NSString stringWithUTF8String:argTypeBuf];
            NSDictionary* dicStruct = [args objectAtIndex:i-2];
            if([strStructType hasPrefix:@"{CGRect"]){
                CGRect rt = CGRectFromDictionary(dicStruct);
                [invocation setArgument:&rt atIndex:i];
            }else if([strStructType hasPrefix:@"{CGSize"]){
                CGSize size = CGSizeFromDictionary(dicStruct);
                [invocation setArgument:&size atIndex:i];
            }else if([strStructType hasPrefix:@"{CGPoint"]){
                CGPoint pt = CGPointFromDictionary(dicStruct);
                [invocation setArgument:&pt atIndex:i];
            }else if([strStructType hasPrefix:@"{_NSRange"]){
                NSRange range = NSRangeFromDictionary(dicStruct);
                [invocation setArgument:&range atIndex:i];
            }
        }
    }
}

- (id)callMethodWithInvocation:(NSInvocation*)invocation{
    const char* retTypeBuf = invocation.methodSignature.methodReturnType;
    char retType;
    if(retTypeBuf[0] == 'r'){
        retType = retTypeBuf[1];
    }else{
        retType = retTypeBuf[0];
    }
    if(retType != 'v'){
        id retValue;
        if('c' == retType){
            char arg;
            [invocation getReturnValue:&arg];
            retValue = [NSNumber numberWithChar:arg];
        }else if('i' == retType){
            int arg;
            [invocation getReturnValue:&arg];
            retValue = [NSNumber numberWithInt:arg];
        }else if('s' == retType){
            short arg;
            [invocation getReturnValue:&arg];
            retValue = [NSNumber numberWithShort:arg];
        }else if('l' == retType){
            long arg;
            [invocation getReturnValue:&arg];
            retValue = [NSNumber numberWithLong:arg];
        }else if('q' == retType){
            long long arg;
            [invocation getReturnValue:&arg];
            retValue = [NSNumber numberWithLongLong:arg];
        }else if('C' == retType){
            unsigned char arg;
            [invocation getReturnValue:&arg];
            retValue = [NSNumber numberWithUnsignedChar:arg];
        }else if('I' == retType){
            unsigned int arg;
            [invocation getReturnValue:&arg];
            retValue = [NSNumber numberWithUnsignedInt:arg];
        }else if('S' == retType){
            unsigned short arg;
            [invocation getReturnValue:&arg];
            retValue = [NSNumber numberWithUnsignedShort:arg];
        }else if('L' == retType){
            unsigned long arg;
            [invocation getReturnValue:&arg];
            retValue = [NSNumber numberWithUnsignedLong:arg];
        }else if('Q' == retType){
            unsigned long long arg;;
            [invocation getReturnValue:&arg];
            retValue = [NSNumber numberWithUnsignedLongLong:arg];
        }else if('f' == retType){
            float arg;
            [invocation getReturnValue:&arg];
            retValue = [NSNumber numberWithFloat:arg];
        }else if('d' == retType){
            double arg;
            [invocation getReturnValue:&arg];
            retValue = [NSNumber numberWithDouble:arg];
        }else if('B' == retType){
            BOOL arg;;
            [invocation getReturnValue:&arg];
            retValue = [NSNumber numberWithBool:arg];
        }else if('@' == retType){
            id arg;
            [invocation getReturnValue:&arg];
            retValue = arg;
        }else if(':' == retType){
            SEL arg;
            [invocation getReturnValue:&arg];
            retValue = NSStringFromSelector(arg);
        }else if('#' == retType){
            Class arg;
            [invocation getReturnValue:&arg];
            retValue = NSStringFromClass(arg);
        }else if('*' == retType || '^' == retType){
            // to do ...
        }else if(retType == '{'){
            NSString* strStructType = [NSString stringWithUTF8String:retTypeBuf];
            if([strStructType hasPrefix:@"{CGRect"]){
                CGRect rt;
                [invocation getReturnValue:&rt];
                retValue = [JSValue valueWithRect:rt inContext:self.jsContext];
            }else if([strStructType hasPrefix:@"{CGSize"]){
                CGSize size;
                [invocation getReturnValue:&size];
                retValue = [JSValue valueWithSize:size inContext:self.jsContext];
            }else if([strStructType hasPrefix:@"{CGPoint"]){
                CGPoint pt;
                [invocation getReturnValue:&pt];
                retValue = [JSValue valueWithPoint:pt inContext:self.jsContext];
            }else if([strStructType hasPrefix:@"{_NSRange"]){
                NSRange range;
                [invocation getReturnValue:&range];
                retValue = [JSValue valueWithRange:range inContext:self.jsContext];
            }
        }
        return retValue;
    }
    return nil;
}

- (id)dynamicMsgSendSuper:(id)obj sel:(NSString*)sel args:(NSArray*)args{
    Method method = class_getInstanceMethod([obj superclass], NSSelectorFromString(sel));
    IMP imp = method_getImplementation(method);
    NSString* strSuperSel = [NSString stringWithFormat:@"duSuper_%@", sel];
    SEL duSuperSel = NSSelectorFromString(strSuperSel);
    
    if(class_addMethod([obj class], duSuperSel, imp, method_getTypeEncoding(method))){
        NSMethodSignature* signature = [NSMethodSignature signatureWithObjCTypes:method_getTypeEncoding(method)];
        NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:signature];
        [invocation setArgument:&obj atIndex:0];
        [invocation setArgument:&duSuperSel atIndex:1];
        [self setMethodArgumentsWithInvocation:invocation args:args];
        [invocation invokeWithTarget:obj];
        return [self callMethodWithInvocation:invocation];
    }
    return nil;
}

- (id)dynamicMsgSend:(id)obj sel:(NSString*)sel args:(NSArray*)args{
    Method method = class_getInstanceMethod([obj class], NSSelectorFromString(sel));
    NSMethodSignature* signature = [NSMethodSignature signatureWithObjCTypes:method_getTypeEncoding(method)];
    NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setArgument:&obj atIndex:0];
    SEL originalSel = NSSelectorFromString(sel);
    [invocation setArgument:&originalSel atIndex:1];
    
    [self setMethodArgumentsWithInvocation:invocation args:args];
    [invocation invokeWithTarget:obj];
    return [self callMethodWithInvocation:invocation];
}

- (void)resetJSDataWithDirectory:(NSString *)jsDir{
    NSFileManager* fileMgr = [NSFileManager defaultManager];
    if(![fileMgr fileExistsAtPath:jsDir])
        return;
    
    NSArray* arrayPath = [fileMgr subpathsAtPath:jsDir];
    for(NSString* jsFile in arrayPath){
        if(![jsFile hasSuffix:@".js"])
            continue ;
        NSData* jsData = [NSData dataWithContentsOfFile:[jsDir stringByAppendingPathComponent:jsFile]];
        if(!jsData)
            continue;
        
        NSString* strJs = [[NSString alloc] initWithData:jsData encoding:NSUTF8StringEncoding];
        if(strJs.length > 0){
            [self.dicJSCacheData setObject:strJs forKey:[jsFile substringToIndex:jsFile.length - 3]];
            [self.jsContext evaluateScript:strJs];
        }
    }
}

- (NSString*)cacheKeyWithCalss:(NSString*)strClass selector:(NSString*)strSel{
    return [NSString stringWithFormat:@"%@_%@", strClass, strSel];
}

- (BOOL)isClass:(NSString *)strClass registeredSector:(NSString *)strSel{
    NSString* cacheKey = [self cacheKeyWithCalss:strClass selector:strSel];
    if([self.dicClassSel objectForKey:cacheKey]){
        return YES;
    }
    return NO;
}

- (void)addArgsWithArray:(NSMutableArray*)arrayArgs invocation:(NSInvocation *)invocation{
    for(NSInteger i = 2; i < invocation.methodSignature.numberOfArguments; ++ i){
        const char* argTypeBuf = [invocation.methodSignature getArgumentTypeAtIndex:i];
        char argType;
        if(argTypeBuf[0] == 'r'){
            argType = argTypeBuf[1];
        }else{
            argType = argTypeBuf[0];
        }
        if('c' == argType){
            char arg;
            [invocation getArgument:&arg atIndex:i];
            [arrayArgs addObject:[NSNumber numberWithChar:arg]];
        }else if('C' == argType){
            unsigned char arg;
            [invocation getArgument:&arg atIndex:i];
            [arrayArgs addObject:[NSNumber numberWithUnsignedChar:arg]];
        }else if('i' == argType){
            int arg = 0;
            [invocation getArgument:&arg atIndex:i];
            [arrayArgs addObject:[NSNumber numberWithInt:arg]];
        }else if('s' == argType){
            short arg = 0;
            [invocation getArgument:&arg atIndex:i];
            [arrayArgs addObject:[NSNumber numberWithShort:arg]];
        }else if('l' == argType){
            long arg = 0;
            [invocation getArgument:&arg atIndex:i];
            [arrayArgs addObject:[NSNumber numberWithLong:arg]];
        }else if('q' == argType){
            long long arg = 0;
            [invocation getArgument:&arg atIndex:i];
            [arrayArgs addObject:[NSNumber numberWithLongLong:arg]];
        }else if('I' == argType){
            unsigned int arg = 0;
            [invocation getArgument:&arg atIndex:i];
            [arrayArgs addObject:[NSNumber numberWithUnsignedInt:arg]];
        }else if('S' == argType){
            unsigned short arg = 0;
            [invocation getArgument:&arg atIndex:i];
            [arrayArgs addObject:[NSNumber numberWithUnsignedShort:arg]];
        }else if('L' == argType){
            unsigned long arg = 0;
            [invocation getArgument:&arg atIndex:i];
            [arrayArgs addObject:[NSNumber numberWithUnsignedLong:arg]];
        }else if('Q' == argType){
            unsigned long long arg = 0;
            [invocation getArgument:&arg atIndex:i];
            [arrayArgs addObject:[NSNumber numberWithUnsignedLongLong:arg]];
        }else if('f' == argType){
            float arg = 0;
            [invocation getArgument:&arg atIndex:i];
            [arrayArgs addObject:[NSNumber numberWithFloat:arg]];
        }else if('d' == argType){
            double arg = 0;
            [invocation getArgument:&arg atIndex:i];
            [arrayArgs addObject:[NSNumber numberWithDouble:arg]];
        }else if('B' == argType){
            BOOL arg = 0;
            [invocation getArgument:&arg atIndex:i];
            [arrayArgs addObject:[NSNumber numberWithBool:arg]];
        }else if('@' == argType){
            id arg = 0;
            [invocation getArgument:&arg atIndex:i];
            [arrayArgs addObject:arg];
        }else if(':' == argType){
            SEL arg = 0;
            [invocation getArgument:&arg atIndex:i];
            [arrayArgs addObject:NSStringFromSelector(arg)];
        }else if('#' == argType){
            Class arg = 0;
            [invocation getArgument:&arg atIndex:i];
            [arrayArgs addObject:NSStringFromClass(arg)];
        }else if('*' == argType || '^' == argType){
            // to do ...
        }else if('{' == argType){
            NSString* strStructType = [NSString stringWithUTF8String:argTypeBuf];
            if([strStructType hasPrefix:@"{CGRect"]){
                CGRect rt = CGRectZero;
                [invocation getArgument:&rt atIndex:i];
                [arrayArgs addObject:CGRectToDictionary(rt)];
            }else if([strStructType hasPrefix:@"{CGSize"]){
                CGSize size = CGSizeZero;
                [invocation getArgument:&size atIndex:i];
                [arrayArgs addObject:CGSizeToDictionary(size)];
            }else if([strStructType hasPrefix:@"{CGPoint"]){
                CGPoint pt = CGPointZero;
                [invocation getArgument:&pt atIndex:i];
                [arrayArgs addObject:CGPointToDictionary(pt)];
            }else if([strStructType hasPrefix:@"{_NSRange"]){
                NSRange range = NSMakeRange(0, 0);
                [invocation getArgument:&range atIndex:i];
                [arrayArgs addObject:NSRangeToDictionary(range)];
            }
        }
    }
}

- (void)setupReturnValue:(JSValue*)value invocation:(NSInvocation*)invocation{
    const char* retTypeBuf = invocation.methodSignature.methodReturnType;
    char retType;
    if(retTypeBuf[0] == 'r'){
        retType = retTypeBuf[1];
    }else{
        retType = retTypeBuf[0];
    }
    if(retType != 'v'){
        if('c' == retType){
            char arg = [[value toNumber] charValue];
            [invocation setReturnValue:&arg];
        }else if('i' == retType){
            int arg = [[value toNumber] intValue];;
            [invocation setReturnValue:&arg];
        }else if('s' == retType){
            short arg = [[value toNumber] shortValue];;
            [invocation setReturnValue:&arg];
        }else if('l' == retType){
            long arg = [[value toNumber] longValue];;
            [invocation setReturnValue:&arg];
        }else if('q' == retType){
            long long arg = [[value toNumber] longLongValue];;
            [invocation setReturnValue:&arg];
        }else if('C' == retType){
            unsigned char arg = [[value toNumber] unsignedCharValue];
            [invocation setReturnValue:&arg];
        }else if('I' == retType){
            unsigned int arg = [[value toNumber] unsignedIntValue];
            [invocation setReturnValue:&arg];
        }else if('S' == retType){
            unsigned short arg = [[value toNumber] unsignedShortValue];
            [invocation setReturnValue:&arg];
        }else if('L' == retType){
            unsigned long arg = [[value toNumber] unsignedLongValue];
            [invocation setReturnValue:&arg];
        }else if('Q' == retType){
            unsigned long long arg = [[value toNumber] unsignedLongLongValue];
            [invocation setReturnValue:&arg];
        }else if('f' == retType){
            float arg = [[value toNumber] floatValue];
            [invocation setReturnValue:&arg];
        }else if('d' == retType){
            double arg = [[value toNumber] doubleValue];
            [invocation setReturnValue:&arg];
        }else if('B' == retType){
            BOOL arg = [[value toNumber] boolValue];
            [invocation setReturnValue:&arg];
        }else if('@' == retType){
            id arg = [value toObject];
            [invocation setReturnValue:&arg];
        }else if(':' == retType){
            SEL arg = NSSelectorFromString([value toString]);
            [invocation setReturnValue:&arg];
        }else if('#' == retType){
            Class arg = NSClassFromString([value toString]);
            [invocation setReturnValue:&arg];
        }else if('*' == retType || '^' == retType){
            // to do ...
        }else if(retType == '{'){
            NSString* strStructType = [NSString stringWithUTF8String:retTypeBuf];
            if([strStructType hasPrefix:@"{CGRect"]){
                CGRect rt = CGRectFromDictionary([value toDictionary]);
                [invocation setReturnValue:&rt];
            }else if([strStructType hasPrefix:@"{CGSize"]){
                CGSize size = CGSizeFromDictionary([value toDictionary]);
                [invocation setReturnValue:&size];
            }else if([strStructType hasPrefix:@"{CGPoint"]){
                CGPoint pt = CGPointFromDictionary([value toDictionary]);
                [invocation setReturnValue:&pt];
            }else if([strStructType hasPrefix:@"{_NSRange"]){
                NSRange range = NSRangeFromDictionary([value toDictionary]);
                [invocation setReturnValue:&range];
            }
        }
    }
}

- (void)callJsFunctionWithObj:(id)obj invocation:(NSInvocation *)invocation{
    NSMutableArray* arrayArgs = [NSMutableArray array];
    [self addArgsWithArray:arrayArgs invocation:invocation];
    
    NSString* strSel = NSStringFromSelector(invocation.selector);
    NSString* jsFunc = [strSel stringByReplacingOccurrencesOfString:@":" withString:@"_"];
    jsFunc = [NSString stringWithFormat:@"%@_%@", NSStringFromClass([obj class]), jsFunc];
    
    JSValue* jsRet = [self.jsContext[jsFunc] callWithArguments:@[obj, strSel, arrayArgs]];
    if(jsRet){
        [self setupReturnValue:jsRet invocation:invocation];
    }
}

@end
