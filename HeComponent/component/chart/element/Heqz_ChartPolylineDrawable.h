//
//  Heqz_ChartPolylineElement.h
//  SinaFinance
//
//  Created by qingzhao on 2018/5/2.
//  Copyright © 2018年 qingzhao. All rights reserved.
//

#import "Heqz_ChartElement.h"
#import "Heqz_ChartPointCollection.h"

typedef NS_OPTIONS(NSInteger, Heqz_ChartPolylineType){
    Heqz_ChartPolylineType_solide,
    Heqz_ChartPolylineType_dot,
    Heqz_ChartPolylineType_segment
};

@interface Heqz_ChartPolylineDrawable : Heqz_ChartElement

@property(nonatomic, assign)Heqz_ChartPolylineType lineType;

// 折线的线宽 单位为点
@property(nonatomic, assign)CGFloat lineWidth;
@property(nonatomic, strong)UIColor* lineColor;

@property(nonatomic, strong)Heqz_ChartPointCollection* ptCollection;



@end
