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
- (void)excuteJSStringWithObj:(id)obj currentsel:(SEL)sel originalSel:(SEL)oriSel args:(NSArray*)args;
- (id)id_excuteJSStringWithObj:(id)obj currentsel:(SEL)sel originalSel:(SEL)oriSel args:(NSArray*)args;
- (NSInteger)i_excuteJSStringWithObj:(id)obj currentsel:(SEL)sel originalSel:(SEL)oriSel args:(NSArray*)args;
- (CGFloat)f_excuteJSStringWithObj:(id)obj currentsel:(SEL)sel originalSel:(SEL)oriSel args:(NSArray*)args;
- (BOOL)b_excuteJSStringWithObj:(id)obj currentsel:(SEL)sel originalSel:(SEL)oriSel args:(NSArray*)args;
- (CGRect)rect_excuteJSStringWithObj:(id)obj currentsel:(SEL)sel originalSel:(SEL)oriSel args:(NSArray*)args;
- (CGSize)size_excuteJSStringWithObj:(id)obj currentsel:(SEL)sel originalSel:(SEL)oriSel args:(NSArray*)args;
- (CGPoint)point_excuteJSStringWithObj:(id)obj currentsel:(SEL)sel originalSel:(SEL)oriSel args:(NSArray*)args;
@end
