//
//  SFChartImageAnimatable.h
//  SinaFinance
//
//  Created by qingzhao on 2018/5/25.
//  Copyright © 2018年 qingzhao. All rights reserved.
//

#import "SFChartElement.h"

@interface SFChartImageAnimatable : SFChartElement

// 单位为原始数据
@property(nonatomic, assign)CGPoint posiInValue;

// 单位为点
@property(nonatomic, assign)CGPoint offsetInPoint;
@property(nonatomic, assign)CGPoint anchorPoint;

@property(nonatomic, strong)UIImage* image;

+ (instancetype)chartImageWithImage:(UIImage*)image;

@end
