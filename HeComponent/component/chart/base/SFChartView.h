//
//  SFChartBaseView.h
//  layoutTest
//
//  Created by qingzhao on 2018/5/3.
//  Copyright © 2018年 qingzhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFChartElement.h"

@class SFChartView;

// SFChartView 事件处理回调

@protocol SFChartViewTouchDelegate <NSObject>

- (void)touchesBeginChartView:(SFChartView*)chartView chart:(id<SFChartElementProtocol>)chart point:(CGPoint)pt context:(id)userData;
- (void)touchesMovedChartView:(SFChartView*)chartView chart:(id<SFChartElementProtocol>)chart point:(CGPoint)pt context:(id)userData;
- (void)touchesEndedChartView:(SFChartView*)chartView chart:(id<SFChartElementProtocol>)chart point:(CGPoint)pt context:(id)userData;
- (void)touchesCancelledChartView:(SFChartView*)chartView chart:(id<SFChartElementProtocol>)chart point:(CGPoint)pt context:(id)userData;

@end

@interface SFChartView : UIView

// 事件回调代理
@property(nonatomic, weak)id<SFChartViewTouchDelegate> touchDelegate;
// 事件回调时传的参数
@property(nonatomic, strong)id userData;

// mode YES 使用cgcontext绘制 NO 使用cashapelayer绘制
- (instancetype)initWithFrame:(CGRect)frame disableEffcient:(BOOL)mode;

// 需要绘制的图表对象
- (void)addChart:(id<SFChartElementProtocol>)drawable;

// 对图表设置完数据后调用，用于触发刷新
- (void)showChartData;

- (CGPoint)convertPoint:(CGPoint)pt fromChart:(id<SFChartElementProtocol>)drawable;
- (BOOL)containChart:(id<SFChartElementProtocol>)drawable;

@end
