//
//  Heqz_ChartFillElement.h
//  layoutTest
//
//  Created by qingzhao on 2018/5/3.
//  Copyright © 2018年 qingzhao. All rights reserved.
//

#import "Heqz_ChartElement.h"
#import "Heqz_ChartPointCollection.h"

@interface Heqz_ChartFillDrawable : Heqz_ChartElement

@property(nonatomic, weak)Heqz_ChartPointCollection* ptCollection;

// 填充底部的值，单位为原始数据
@property(nonatomic, assign)CGFloat baseValue;
@property(nonatomic, strong)UIColor* fromColor;
@property(nonatomic, strong)UIColor* toColor;

@end
