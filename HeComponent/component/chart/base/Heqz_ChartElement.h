//
//  Heqz_ChartDrawable.h
//  layoutTest
//
//  Created by qingzhao on 2018/5/3.
//  Copyright © 2018年 qingzhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import "Heqz_ChartRange.h"

// 使用CAShapeLayer绘制的元素可以显示动画效果
@protocol Heqz_ChartAnimatableDelegate <NSObject>

// 返回对应元素的动画
- (CAAnimation*)customAnimationForShapeLayer:(CALayer*)layer;

// 元素动画结束回调
- (void)customShowAnimationStop:(CAAnimation*)animation;

@end

@protocol Heqz_ChartElementProtocol <NSObject>

@optional
// 绘制相关
@property(nonatomic, assign)BOOL hidden;
@property(nonatomic, assign)CGRect boundingRect;
@property(nonatomic, strong)UIColor* backColor;

- (BOOL)drawWithContextIfNeed:(CGContextRef)context;

// shapelayer相关
@property(nonatomic, weak)CALayer* canvasLayer;
@property(nonatomic, readonly)CAShapeLayer* commonShapeLayer;
@property(nonatomic, assign)BOOL bDisableAnimation;
@property(nonatomic, assign)NSTimeInterval animationDuration;
@property(nonatomic, weak)id<Heqz_ChartAnimatableDelegate> animationDelegate;

- (void)setNeedShowChart;
- (void)clearCanvas;

// 事件处理
@property(nonatomic, assign)CGPoint userFocusCoordinate;

- (void)touchesBeganWithPoint:(CGPoint)point;
- (void)touchesMovedWithPoint:(CGPoint)point;
- (void)touchesEndedWithPoint:(CGPoint)point;
- (void)touchesCancelledWithPoint:(CGPoint)point;

// 数据处理
- (void)preProcessWithRangeH:(Heqz_ChartRange)rangeH rangeV:(Heqz_ChartRange)rangeV;

// 坐标转化
- (CGPoint)convertRealPointToPixcel:(CGPoint)pt;

@end

@interface Heqz_ChartElement : NSObject <Heqz_ChartElementProtocol, CAAnimationDelegate>

@property(nonatomic, assign)BOOL bHadProcessData;
@property(nonatomic, strong)NSMutableArray* arrayCacheLayers;

// 专用于表格中的元素 其他情况下使用可能会出问题 左上角为坐标原点
// element的所有位置数据默认都是相对于chart的坐标， 一旦设置relativeRect后，
// element的数据都会变成在relativeRect中的位置值，绘制时，会使用relativeRect，将位置数据
// 转化为在chart中的坐标后在绘制
@property(nonatomic, assign)CGRect relativeRect;

+ (instancetype)chartElement;

// 将原始数据转换为屏幕上的位置，具体实现由各个元素自身决定
- (void)preProcessWithRangeH:(Heqz_ChartRange)rangeH rangeV:(Heqz_ChartRange)rangeV;

// 每个元素都有自身的boundingRect，这个boundingRect为元素在屏幕上的rect
// @param value 原始数据值
// @param range 元素横向数值范围
// @return  返回value range 和 boundingRect计算后的在屏幕中的位置
- (CGFloat)locationValue:(CGFloat)value withHorizontalRange:(Heqz_ChartRange)range;

// - (CGFloat)locationValue:(CGFloat)value withHorizontalRange:(Heqz_ChartRange)range 的逆操作
- (CGFloat)pointValue:(CGFloat)value withHorizontalRange:(Heqz_ChartRange)range;

// 同上
- (CGFloat)locationValue:(CGFloat)value withVerticalRange:(Heqz_ChartRange)range;
- (CGFloat)pointValue:(CGFloat)value withVerticalRange:(Heqz_ChartRange)range;

// 当Heqz_ChartView创建时指定使用CAShapeLayer绘制元素，刷新时会调用这个方法
// 子元素重写这个方法，进行自身绘制
- (void)setNeedShowChart;

// 返回默认显示动画
- (CAAnimation*)defaultShowAnimation;
// 调用该方法进行动画显示
- (void)displayShowAnimation;

@end
