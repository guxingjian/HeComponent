//
//  SFChartPolylineElement.h
//  SinaFinance
//
//  Created by qingzhao on 2018/5/2.
//  Copyright © 2018年 qingzhao. All rights reserved.
//

#import "SFChartElement.h"
#import "SFChartPointCollection.h"

typedef NS_OPTIONS(NSInteger, SFChartPolylineType){
    SFChartPolylineType_solide,
    SFChartPolylineType_dot,
    SFChartPolylineType_segment
};

@interface SFChartPolylineDrawable : SFChartElement

@property(nonatomic, assign)SFChartPolylineType lineType;

// 折线的线宽 单位为点
@property(nonatomic, assign)CGFloat lineWidth;
@property(nonatomic, strong)UIColor* lineColor;

@property(nonatomic, strong)SFChartPointCollection* ptCollection;



@end
