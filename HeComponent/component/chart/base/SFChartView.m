//
//  SFChartBaseView.m
//  layoutTest
//
//  Created by qingzhao on 2018/5/3.
//  Copyright © 2018年 qingzhao. All rights reserved.
//

#import "SFChartView.h"
#import "SFChartChart.h"
#import "SFChartLayer.h"

@interface SFChartView()

@property(nonatomic, strong)NSMutableArray* arrayChart;
@property(nonatomic, assign)BOOL disableEffcient;
@property(nonatomic, strong)CALayer* canvasLayer;

@end

@implementation SFChartView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (NSMutableArray *)arrayChart
{
    if(!_arrayChart)
    {
        _arrayChart = [NSMutableArray array];
    }
    return _arrayChart;
}

- (instancetype)initWithFrame:(CGRect)frame disableEffcient:(BOOL)mode
{
    if(self = [super initWithFrame:frame])
    {
        self.disableEffcient = mode;
        [self buildInterface];
    }
    return self;
}

- (void)buildInterface
{
    self.backgroundColor = [UIColor clearColor];
    self.opaque = NO;
    self.layer.masksToBounds = YES;
    _canvasLayer = nil;
    self.canvasLayer.masksToBounds = YES;
}

- (CALayer *)canvasLayer
{
    if(!_canvasLayer)
    {
        if(!self.disableEffcient)
        {
            _canvasLayer = self.layer;
        }
        else
        {
            SFChartLayer* chartLayer = [[SFChartLayer alloc] init];
            chartLayer.frame = self.bounds;
            [self.layer addSublayer:chartLayer];
            _canvasLayer = chartLayer;
            chartLayer.arrayChart = self.arrayChart;
        }
    }
    return _canvasLayer;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    for(id<SFChartElementProtocol> chart in self.arrayChart)
    {
        chart.boundingRect = self.bounds;
    }
    if(self.canvasLayer != self.layer)
    {
        self.canvasLayer.frame = self.bounds;
    }
}

- (void)addChart:(id<SFChartElementProtocol>)drawable
{
    if(!drawable)
        return ;
    
    if(CGRectEqualToRect(drawable.boundingRect, CGRectZero)){
        drawable.boundingRect = self.bounds;
    }
    drawable.canvasLayer = self.canvasLayer;
    [self.arrayChart addObject:drawable];
}

- (void)showChartData
{
    if([self.canvasLayer isKindOfClass:[SFChartLayer class]])
    {
        [self.canvasLayer setNeedsDisplay];
    }
    else
    {
        for(id<SFChartElementProtocol> chart in self.arrayChart)
        {
            if([chart respondsToSelector:@selector(setNeedShowChart)])
            {
                [chart setNeedShowChart];
            }
        }
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event
{
    UITouch* touche = [touches anyObject];
    CGPoint pt = [touche locationInView:self];
    for(id<SFChartElementProtocol> chart in self.arrayChart)
    {
        if([chart respondsToSelector:@selector(touchesBeganWithPoint:)])
        {
            [chart touchesBeganWithPoint:pt];
        }
        
        if([self.touchDelegate respondsToSelector:@selector(touchesBeginChartView:chart:point:context:)])
        {
            [self.touchDelegate touchesBeginChartView:self chart:chart point:pt context:self.userData];
        }
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event
{
    UITouch* touche = [touches anyObject];
    CGPoint pt = [touche locationInView:self];
    for(id<SFChartElementProtocol> chart in self.arrayChart)
    {
        if([chart respondsToSelector:@selector(touchesMovedWithPoint:)])
        {
            [chart touchesMovedWithPoint:pt];
        }
        if([self.touchDelegate respondsToSelector:@selector(touchesMovedChartView:chart:point:context:)])
        {
            [self.touchDelegate touchesMovedChartView:self chart:chart point:pt context:self.userData];
        }
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event
{
    UITouch* touche = [touches anyObject];
    CGPoint pt = [touche locationInView:self];
    for(id<SFChartElementProtocol> chart in self.arrayChart)
    {
        if([chart respondsToSelector:@selector(touchesEndedWithPoint:)])
        {
            [chart touchesEndedWithPoint:pt];
        }
        
        if([self.touchDelegate respondsToSelector:@selector(touchesEndedChartView:chart:point:context:)])
        {
            [self.touchDelegate touchesEndedChartView:self chart:chart point:pt context:self.userData];
        }
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event
{
    UITouch* touche = [touches anyObject];
    CGPoint pt = [touche locationInView:self];
    for(id<SFChartElementProtocol> chart in self.arrayChart)
    {
        if([chart respondsToSelector:@selector(touchesCancelledWithPoint:)])
        {
            [chart touchesCancelledWithPoint:pt];
        }
        if([self.touchDelegate respondsToSelector:@selector(touchesCancelledChartView:chart:point:context:)])
        {
            [self.touchDelegate touchesCancelledChartView:self chart:chart point:pt context:self.userData];
        }
    }
}

- (BOOL)containChart:(id<SFChartElementProtocol>)drawable
{
    for(id chart in self.arrayChart)
    {
        if(chart == drawable)
            return YES;
    }
    return NO;
}

- (CGPoint)convertPoint:(CGPoint)pt fromChart:(id<SFChartElementProtocol>)drawable
{
    if(![self containChart:drawable])
        return CGPointZero;
    
    if([drawable respondsToSelector:@selector(convertRealPointToPixcel:)])
    {
        return [drawable convertRealPointToPixcel:pt];
    }
    return CGPointZero;
}

@end
