//
//  NSObject+DU.m
//  HeComponent
//
//  Created by qingzhao on 2019/12/27.
//  Copyright © 2019 qingzhao. All rights reserved.
//

#import "NSObject+DU.h"
#import <objc/runtime.h>
#import "Heqz_DUContext.h"

@implementation NSObject(DU)

+ (void)load{
    Method m1 = class_getInstanceMethod(self, @selector(forwardInvocation:));
    Method m2 = class_getInstanceMethod(self, @selector(du_forwardInvocation:));
    method_exchangeImplementations(m1, m2);
}

- (void)du_forwardInvocation:(NSInvocation *)anInvocation{
    NSString* strClass = NSStringFromClass([self class]);
    NSString* strSel = NSStringFromSelector(anInvocation.selector);
    
    Heqz_DUContext* duContext = [Heqz_DUContext sharedDUContext];
    if(![duContext isClass:strClass registeredSector:strSel]){
        [self du_forwardInvocation:anInvocation];
        return ;
    }
    
    [duContext callJsFunctionWithObj:self invocation:anInvocation];
}

@end
