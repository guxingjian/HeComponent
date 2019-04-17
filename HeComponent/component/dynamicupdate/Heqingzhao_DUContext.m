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

static CGSize CGSizeFromDictionary(NSDictionary* dictonary){
    return CGSizeMake([[dictonary objectForKey:@"width"] floatValue], [[dictonary objectForKey:@"height"] floatValue]);
}

static CGPoint CGPointFromDictionary(NSDictionary* dictonary){
    return CGPointMake([[dictonary objectForKey:@"x"] floatValue], [[dictonary objectForKey:@"y"] floatValue]);
}

static NSRange NSRangeFromDictionary(NSDictionary* dictonary){
    return NSMakeRange([[dictonary objectForKey:@"location"] floatValue], [[dictonary objectForKey:@"length"] floatValue]);
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

- (void)exchangeOriginalClass:(NSString*)oriClass originalSel:(NSString*)strOriSel targetSel:(NSString*)strTarSel{
    Class cls = NSClassFromString(oriClass);
    Class targetCls = NSClassFromString(@"Heqingzhao_MethodCollection");
    if(!cls || !targetCls)
        return ;
    
    SEL oriSel = NSSelectorFromString(strOriSel);
    SEL tarSel = NSSelectorFromString(strTarSel);
    
    if(!oriSel || !tarSel)
        return ;
    
    // 保证同一个方法只被swizzle一次
    NSString* cacheKey = [NSString stringWithFormat:@"%@_%@", oriClass, strOriSel];
    if([self.dicClassSel objectForKey:cacheKey])
        return ;
    
    Method originalMethod = class_getInstanceMethod(cls, oriSel);
    Method targetMethod = class_getInstanceMethod(targetCls, tarSel);
    if(class_addMethod(cls, tarSel, method_getImplementation(targetMethod), method_getTypeEncoding(targetMethod))){
        targetMethod = class_getInstanceMethod(cls, tarSel);
        method_exchangeImplementations(originalMethod, targetMethod);
        [self.dicClassSel setObject:@YES forKey:cacheKey];
    }
}

- (void)setupJSContext{
    self.jsContext[@"JS_NSLog"] = ^(NSString* str){
        NSLog(@"%@", str);
    };
    __weak typeof(self) weakSelf = self;
    self.jsContext[@"exchangeImplementation"] = ^(NSString* originalClass, NSString* originalSel, NSString* targetSel){
        [weakSelf exchangeOriginalClass:originalClass originalSel:originalSel targetSel:targetSel];
    };
    self.jsContext[@"msg_send"] = ^(id obj, NSString* sel, NSArray* args){
        return [weakSelf dynamicMsgSend:obj sel:sel args:args];
    };
    self.jsContext[@"msg_send_super"] = ^(id obj, NSString* sel, NSArray* args){
        return [weakSelf dynamicMsgSendSuper:obj sel:sel args:args];
    };
    self.jsContext[@"class_msg_send"] = ^(NSString* clsName, NSString* sel, NSArray* args){
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
        }
    }

    [self hookMethods];
}

- (void)hookMethods{
    NSString* strMainJS = [self.dicJSCacheData objectForKey:@"du_main"];
    if(strMainJS.length == 0)
        return ;
    
    [self.jsContext evaluateScript:strMainJS];
}

- (JSValue*)callJSFuncWithObj:(id)obj currentsel:(SEL)sel originalSel:(SEL)oriSel args:(NSArray *)args shouldReturn:(BOOL)bReturn{
    NSString* strSel = NSStringFromSelector(sel);
    strSel = [strSel stringByReplacingOccurrencesOfString:@":" withString:@"_"];
    NSString* strKey = NSStringFromClass([obj class]);
    NSString* strJs = [self.dicJSCacheData objectForKey:strKey];
    if(strJs.length == 0)
        return nil;
    [self.jsContext evaluateScript:strJs];
    if(!args){
        args = @[];
    }
    
    if(!bReturn){
        [self.jsContext[strSel] callWithArguments:@[obj, NSStringFromSelector(oriSel), args]];
        return nil;
    }
    
    return [self.jsContext[strSel] callWithArguments:@[obj, NSStringFromSelector(oriSel), args]];;
}

- (void)excuteJSStringWithObj:(id)obj currentsel:(SEL)sel originalSel:(SEL)oriSel args:(NSArray *)args{
    [self callJSFuncWithObj:obj currentsel:sel originalSel:oriSel args:args shouldReturn:NO];
}

- (id)id_excuteJSStringWithObj:(id)obj currentsel:(SEL)sel originalSel:(SEL)oriSel args:(NSArray *)args{
    return [self callJSFuncWithObj:obj currentsel:sel originalSel:oriSel args:args shouldReturn:YES];;
}

- (NSInteger)i_excuteJSStringWithObj:(id)obj currentsel:(SEL)sel originalSel:(SEL)oriSel args:(NSArray *)args{
    JSValue* iVal = [self callJSFuncWithObj:obj currentsel:sel originalSel:oriSel args:args shouldReturn:YES];
    return [iVal toInt32];
}

- (CGFloat)f_excuteJSStringWithObj:(id)obj currentsel:(SEL)sel originalSel:(SEL)oriSel args:(NSArray *)args{
    JSValue* fVal = [self callJSFuncWithObj:obj currentsel:sel originalSel:oriSel args:args shouldReturn:YES];
    return [fVal toDouble];
}

- (BOOL)b_excuteJSStringWithObj:(id)obj currentsel:(SEL)sel originalSel:(SEL)oriSel args:(NSArray *)args{
    JSValue* bVal = [self callJSFuncWithObj:obj currentsel:sel originalSel:oriSel args:args shouldReturn:YES];
    return [bVal toBool];
}

- (CGRect)rect_excuteJSStringWithObj:(id)obj currentsel:(SEL)sel originalSel:(SEL)oriSel args:(NSArray *)args{
    JSValue* rectVal = [self callJSFuncWithObj:obj currentsel:sel originalSel:oriSel args:args shouldReturn:YES];
    return CGRectFromDictionary([rectVal toDictionary]);
}

- (CGSize)size_excuteJSStringWithObj:(id)obj currentsel:(SEL)sel originalSel:(SEL)oriSel args:(NSArray *)args{
    JSValue* sizeVal = [self callJSFuncWithObj:obj currentsel:sel originalSel:oriSel args:args shouldReturn:YES];
    return CGSizeFromDictionary([sizeVal toDictionary]);
}

- (CGPoint)point_excuteJSStringWithObj:(id)obj currentsel:(SEL)sel originalSel:(SEL)oriSel args:(NSArray *)args{
    JSValue* pointVal = [self callJSFuncWithObj:obj currentsel:sel originalSel:oriSel args:args shouldReturn:YES];
    return CGPointFromDictionary([pointVal toDictionary]);
}

@end
