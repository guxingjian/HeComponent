//
//  Heqz_ChartBaseView.h
//  layoutTest
//
//  Created by qingzhao on 2018/5/3.
//  Copyright © 2018年 qingzhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Heqz_ChartElement.h"

@class Heqz_ChartView;

// Heqz_ChartView 事件处理回调

@protocol Heqz_ChartViewTouchDelegate <NSObject>

- (void)touchesBeginChartView:(Heqz_ChartView*)chartView chart:(id<Heqz_ChartElementProtocol>)chart point:(CGPoint)pt context:(id)userData;
- (void)touchesMovedChartView:(Heqz_ChartView*)chartView chart:(id<Heqz_ChartElementProtocol>)chart point:(CGPoint)pt context:(id)userData;
- (void)touchesEndedChartView:(Heqz_ChartView*)chartView chart:(id<Heqz_ChartElementProtocol>)chart point:(CGPoint)pt context:(id)userData;
- (void)touchesCancelledChartView:(Heqz_ChartView*)chartView chart:(id<Heqz_ChartElementProtocol>)chart point:(CGPoint)pt context:(id)userData;

@end

@interface Heqz_ChartView : UIView

// 事件回调代理
@property(nonatomic, weak)id<Heqz_ChartViewTouchDelegate> touchDelegate;
// 事件回调时传的参数
@property(nonatomic, strong)id userData;

// mode YES 使用cgcontext绘制 NO 使用cashapelayer绘制
- (instancetype)initWithFrame:(CGRect)frame disableEffcient:(BOOL)mode;

// 需要绘制的图表对象
- (void)addChart:(id<Heqz_ChartElementProtocol>)drawable;

// 对图表设置完数据后调用，用于触发刷新
- (void)showChartData;

- (CGPoint)convertPoint:(CGPoint)pt fromChart:(id<Heqz_ChartElementProtocol>)drawable;
- (BOOL)containChart:(id<Heqz_ChartElementProtocol>)drawable;

@end
