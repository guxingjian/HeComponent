//
//  Heqz_ChartPillarElement.h
//  SinaFinance
//
//  Created by qingzhao on 2018/5/2.
//  Copyright © 2018年 qingzhao. All rights reserved.
//

#import "Heqz_ChartElement.h"

// 柱的配置model，一个柱元素可能会包含多个柱
@interface Heqz_ChartPillarModel : NSObject

+ (instancetype)model;

// 柱的数值范围, 单位为原始数据
@property(nonatomic, assign)Heqz_ChartRange range;

// 柱的宽度，如果没有设置，会使用柱元素的pillarWidth
@property(nonatomic, assign)CGFloat width;

// 柱的填充颜色
@property(nonatomic, strong)UIColor* fillColor;

// 柱的最小高度，单位为点
@property(nonatomic, assign)CGFloat fMinHeight;

// 柱的顶部文字属性
@property(nonatomic, strong)NSDictionary* textAttri;
// 顶部文字
@property(nonatomic, strong)NSString* tipText;

// 文字距离柱子顶部的间距
@property(nonatomic, assign)CGFloat textSpace;

// 自动计算 不需要设置
@property(nonatomic, assign)CGRect rtText;

// to do ...
@property(nonatomic, assign)CGFloat borderWidth;
@property(nonatomic, strong)UIColor* borderColor;

@end

@interface Heqz_ChartPillarDrawable : Heqz_ChartElement

// 柱的统一宽度，如果设置这个值，会忽略pillarModel中的宽度
@property(nonatomic, assign)CGFloat pillarWidth;

// 柱的中心在横轴的location
@property(nonatomic, assign)CGFloat pillarValueH;

// 是否需要重新计算pillar在横轴的位置，默认为YES，计算完后自动设置为NO
// 如果需要更新，请在更新的时候设置为YES
@property(nonatomic, assign)BOOL updatePillarValueH;

// 一组柱中 柱的间距
@property(nonatomic, assign)CGFloat pillarSpace;
@property(nonatomic, strong)NSArray<Heqz_ChartPillarModel*> * arrayPillar;

// 返回多个柱的整体宽度，单位为点
- (CGFloat)getPillarWidth;

@end
