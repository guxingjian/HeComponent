//
//  SFChartDrawable.m
//  layoutTest
//
//  Created by qingzhao on 2018/5/3.
//  Copyright © 2018年 qingzhao. All rights reserved.
//

#import "SFChartElement.h"

@interface SFChartElement()

@end

@implementation SFChartElement

@synthesize hidden = _hidden;
@synthesize boundingRect = _boundingRect;
@synthesize backColor = _backColor;

@synthesize canvasLayer = _canvasLayer;
@synthesize commonShapeLayer = _commonShapeLayer;
@synthesize animationDuration = _animationDuration;
@synthesize bDisableAnimation = _bDisableAnimation;
@synthesize animationDelegate = _animationDelegate;
@synthesize userFocusCoordinate = _userFocusCoordinate;


+ (instancetype)chartElement
{
    SFChartElement* ele = [[self alloc] init];
    ele.bDisableAnimation = YES;
    return ele;
}

- (CAShapeLayer *)commonShapeLayer
{
    if(!_commonShapeLayer)
    {
        _commonShapeLayer = [CAShapeLayer layer];
        _commonShapeLayer.frame = self.canvasLayer.bounds;
        _commonShapeLayer.backgroundColor = [UIColor clearColor].CGColor;
        _commonShapeLayer.fillColor = nil;
        [self.canvasLayer addSublayer:_commonShapeLayer];
    }
    return _commonShapeLayer;
}

- (BOOL)drawWithContextIfNeed:(CGContextRef)context
{
    if(self.hidden)
        return NO;
    
    if(self.backColor)
    {
        CGContextSaveGState(context);
        CGContextSetFillColorWithColor(context, self.backColor.CGColor);
        CGContextFillRect(context, self.boundingRect);
        CGContextRestoreGState(context);
    }
    
    return YES;
}

- (void)preProcessWithRangeH:(SFChartRange)rangeH rangeV:(SFChartRange)rangeV
{
    if(self.bHadProcessData)
        return ;
}

- (CGFloat)locationValue:(CGFloat)value withHorizontalRange:(SFChartRange)range
{
//    if(range.endValue > range.startValue)
//    {
//        if(value < range.startValue || value > range.endValue)
//            return 0;
//    }
//    else if(range.endValue < range.startValue)
//    {
//        if(value > range.startValue || value < range.endValue)
//            return 0;
//    }
    
    if(range.endValue == range.startValue)
        return 0;
    
    if(range.endValue - range.startValue == self.boundingRect.size.width)
        return (value + self.boundingRect.origin.x);
    
    CGFloat fRet = 0;
    if(range.startValue != range.endValue)
    {
        if(241.0 == value){
            int a = 10;
        }
        fRet = (value - range.startValue)/(range.endValue - range.startValue)*self.boundingRect.size.width;
        fRet = self.boundingRect.origin.x + fRet;
    }
    return fRet;
}

- (CGFloat)pointValue:(CGFloat)value withHorizontalRange:(SFChartRange)range
{
//    if(value < self.boundingRect.origin.x || value > self.boundingRect.origin.x + self.boundingRect.size.width)
//        return 0;
    
    if(self.boundingRect.size.width == 0)
        return 0;
    
    CGFloat fRet = 0;
    if(range.startValue != range.endValue)
    {
        fRet = (value - self.boundingRect.origin.x)/self.boundingRect.size.width*(range.endValue - range.startValue);
        fRet = range.startValue + fRet;
    }
    return fRet;
}

- (CGFloat)locationValue:(CGFloat)value withVerticalRange:(SFChartRange)range
{
//    if(range.endValue > range.startValue)
//    {
//        if(value < range.startValue || value > range.endValue)
//            return 0;
//    }
//    else if(range.endValue < range.startValue)
//    {
//        if(value > range.startValue || value < range.endValue)
//            return 0;
//    }
    
    if(range.endValue == range.startValue)
        return 0;
    
    if(range.endValue - range.startValue == self.boundingRect.size.height)
        return (self.boundingRect.origin.y + self.boundingRect.size.height - (value - range.startValue));
    
    CGFloat fRet = 0;
    if(range.startValue != range.endValue)
    {
        fRet = (value - range.startValue)/(range.endValue - range.startValue)*self.boundingRect.size.height;
        fRet = self.boundingRect.origin.y + self.boundingRect.size.height - fRet;
    }
    return fRet;
}

- (CGFloat)pointValue:(CGFloat)value withVerticalRange:(SFChartRange)range
{
//    if(value < self.boundingRect.origin.y || value > self.boundingRect.origin.y + self.boundingRect.size.height)
//        return 0;
    
    if(self.boundingRect.size.height == 0)
        return 0;
    
    CGFloat fRet = 0;
    if(range.startValue != range.endValue)
    {
        fRet = (value - self.boundingRect.origin.y)/self.boundingRect.size.height*(range.endValue - range.startValue);
        fRet = range.startValue + fRet;
    }
    return fRet;
}

- (void)setNeedShowChart{
    
}

- (CAAnimation *)defaultShowAnimation
{
    CABasicAnimation* basicAni = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    basicAni.fromValue = @0;
    basicAni.toValue = @1;
    basicAni.duration = self.animationDuration;
    basicAni.delegate = self;
    basicAni.removedOnCompletion = NO;
    basicAni.fillMode = kCAFillModeForwards;
    return basicAni;
}

- (void)displayShowAnimation
{
    CAAnimation* animation;
    if(self.animationDelegate && [self.animationDelegate respondsToSelector:@selector(customAnimationForShapeLayer:)])
    {
        animation = [self.animationDelegate customAnimationForShapeLayer:self.commonShapeLayer];
    }
    else
    {
        animation = [self defaultShowAnimation];
    }
    [self.commonShapeLayer addAnimation:animation forKey:@"animation"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if(self.animationDelegate && [self.animationDelegate respondsToSelector:@selector(customShowAnimationStop:)])
    {
        [self.animationDelegate customShowAnimationStop:anim];
    }
    else
    {
        self.commonShapeLayer.strokeEnd = 1.0;
    }
}

- (void)clearCanvas{
    for(CALayer* layer in _arrayCacheLayers){
        [layer removeFromSuperlayer];
    }
    [_arrayCacheLayers removeAllObjects];
}

- (void)dealloc
{
    [_commonShapeLayer removeFromSuperlayer];
    [self clearCanvas];
}

- (NSMutableArray *)arrayCacheLayers{
    if(!_arrayCacheLayers){
        _arrayCacheLayers = [NSMutableArray array];
    }
    return _arrayCacheLayers;
}

@end
