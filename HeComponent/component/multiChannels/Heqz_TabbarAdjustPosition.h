//
//  SFTabbarAdjustPosition.h
//  SinaFinance
//
//  Created by 何庆钊 on 2018/1/9.
//  Copyright © 2018年 sina.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Heqz_TabbarAdjustPosition : NSObject

// 当横向有多个tab按钮，按钮布局超出屏幕宽度时，点击屏幕边
// 缘tab，要自动滑出隐藏的下一个tab按钮
// param selectTab当前选择的tab按钮
// param tab按钮之间的距离
// param scroll 包含tab按钮的scrollview
+ (void)showHiddenTabWith:(id)selectTab splitDis:(CGFloat)tabDis containerScrollView:(UIView*)scroll;

+ (void)showHiddenTabWith:(id)selectTab splitDis:(CGFloat)tabDis containerScrollView:(UIView*)scroll animation:(BOOL)animation;

@end
