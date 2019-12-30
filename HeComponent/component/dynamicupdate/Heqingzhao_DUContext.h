//
//  Heqingzhao_DUContext.h
//  HeComponent
//
//  Created by qingzhao on 2019/3/4.
//  Copyright © 2019年 qingzhao. All rights reserved.
//

#import <JavaScriptCore/JavaScriptCore.h>

@interface Heqingzhao_DUContext : NSObject

@property(nonatomic,strong)JSContext* jsContext;

+ (instancetype)sharedDUContext;

// 设置后，会读取目录中的js文件，执行main.js
- (void)resetJSDataWithDirectory:(NSString*)jsDir;
- (BOOL)isClass:(NSString*)strClass registeredSector:(NSString*)strSel;
- (void)callJsFunctionWithObj:(id)obj invocation:(NSInvocation*)invocation;

@end
