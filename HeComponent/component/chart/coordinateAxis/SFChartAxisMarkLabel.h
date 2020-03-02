//
//  SFChartAxisMarkLabel.h
//  SinaFinance
//
//  Created by qingzhao on 2018/5/1.
//  Copyright © 2018年 qingzhao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSInteger, SFChartAlignment){
    SFChartAlignmentCenter,
    SFChartAlignmentLeft,
    SFChartAlignmentRight,
    SFChartAlignmentTop,
    SFChartAlignmentBottom
};

@interface SFChartAxisMarkLabel : NSObject

// 显示的文本
@property(nonatomic, strong)NSAttributedString* text;

// 文字的位置，单位为原始数据，参照点取决于alignment
// 横轴的文字，axisLocation为横向位置，alignment取值为center，left，right
// 纵轴的文字，axisLocation为纵向位置，alignment取值为center，top，bottom
@property(nonatomic, assign)CGFloat axisLocation;

// 设置文字相对于轴线的偏移，单位为点
@property(nonatomic, assign)CGFloat spacing;
@property(nonatomic, assign)SFChartAlignment alignment;

// 文字的最大宽度 单位为点
@property(nonatomic, assign)CGFloat maxWidth;

+ (instancetype)markLabelWithText:(NSAttributedString*)text;

// 使用maxWidth计算的文字rect
- (CGRect)textRect;

@end
