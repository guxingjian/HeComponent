//
//  Heqz_Chart.m
//  SinaFinance
//
//  Created by qingzhao on 2018/4/28.
//  Copyright © 2018年 qingzhao. All rights reserved.
//

#import "Heqz_ChartChart.h"

@interface Heqz_ChartChart()

@property(nonatomic, strong)NSMutableArray<id<Heqz_ChartElementProtocol>> * chartElements;

@end

@implementation Heqz_ChartChart

+ (instancetype)chartWithRangeH:(Heqz_ChartRange)rangeH rangeV:(Heqz_ChartRange)rangeV
{
    Heqz_ChartChart* chart = [[self alloc] init];
    chart.rangeH = rangeH;
    chart.rangeV = rangeV;
    return chart;
}

- (NSMutableArray<id<Heqz_ChartElementProtocol>> *)chartElements
{
    if(!_chartElements)
    {
        _chartElements = [NSMutableArray array];
    }
    return _chartElements;
}

- (void)addElement:(id<Heqz_ChartElementProtocol>)element
{
    if(!element)
        return ;
    if([element respondsToSelector:@selector(setCanvasLayer:)])
    {
        element.canvasLayer = self.canvasLayer;
    }
    if(CGRectEqualToRect(CGRectZero, element.boundingRect))
    {
        element.boundingRect = self.boundingRect;
    }
    [self updateElementData:element];
    [self.chartElements addObject:element];
}

- (void)setCanvasLayer:(CALayer *)canvasLayer
{
    [super setCanvasLayer:canvasLayer];
    
    for(id<Heqz_ChartElementProtocol> element in self.chartElements)
    {
        if(!element.canvasLayer)
        {
            element.canvasLayer = canvasLayer;
        }
    }
}

- (void)setBoundingRect:(CGRect)boundingRect
{
    [super setBoundingRect:boundingRect];
    for(id<Heqz_ChartElementProtocol> element in self.chartElements)
    {
        element.boundingRect = boundingRect;
    }
}

- (void)addElements:(NSArray<id<Heqz_ChartElementProtocol>> *)arrayElements
{
    for(id<Heqz_ChartElementProtocol> element in arrayElements)
    {
        [self addElement:element];
    }
}

- (void)updateElementData:(id<Heqz_ChartElementProtocol>)element
{
    if(self.rangeH.startValue == 0 && self.rangeH.endValue == 0)
        return ;
    
    if(self.rangeV.startValue == 0 && self.rangeV.endValue == 0)
        return ;
    
    if([element respondsToSelector:@selector(preProcessWithRangeH:rangeV:)])
    {
        [element preProcessWithRangeH:self.rangeH rangeV:self.rangeV];
    }
}

- (void)updateElements
{
    for(id<Heqz_ChartElementProtocol> element in self.chartElements)
    {
        [self updateElementData:element];
    }
}

- (void)removeElement:(id<Heqz_ChartElementProtocol>)element
{
    [self.chartElements removeObject:element];
}

- (void)clearElements
{
    [self.chartElements removeAllObjects];
}

- (BOOL)drawWithContextIfNeed:(CGContextRef)context
{
    if(![super drawWithContextIfNeed:context])
        return NO;
    
    for(Heqz_ChartElement* ele in self.chartElements)
    {
        if([ele respondsToSelector:@selector(drawWithContextIfNeed:)])
        {
            [ele drawWithContextIfNeed:context];
        }
    }
    
    return YES;
}

- (void)setNeedShowChart
{
    for(Heqz_ChartElement* ele in self.chartElements)
    {
        if([ele respondsToSelector:@selector(setNeedShowChart)])
        {
            [ele clearCanvas];
            [ele setNeedShowChart];
            if(!ele.bDisableAnimation){
                [ele displayShowAnimation];
            }
        }
    }
}

- (void)touchesBeganWithPoint:(CGPoint)point
{
    for(Heqz_ChartElement* ele in self.chartElements)
    {
        if([ele respondsToSelector:@selector(touchesBeganWithPoint:)])
        {
            [ele touchesBeganWithPoint:point];
        }
    }
    
    self.userFocusCoordinate = CGPointMake([self pointValue:point.x withHorizontalRange:self.rangeH], [self pointValue:point.y withVerticalRange:self.rangeV]);
}

- (void)touchesMovedWithPoint:(CGPoint)point
{
    for(Heqz_ChartElement* ele in self.chartElements)
    {
        if([ele respondsToSelector:@selector(touchesMovedWithPoint:)])
        {
            [ele touchesMovedWithPoint:point];
        }
    }
    
    self.userFocusCoordinate = CGPointMake([self pointValue:point.x withHorizontalRange:self.rangeH], [self pointValue:point.y withVerticalRange:self.rangeV]);
}

- (void)touchesEndedWithPoint:(CGPoint)point
{
    for(Heqz_ChartElement* ele in self.chartElements)
    {
        if([ele respondsToSelector:@selector(touchesEndedWithPoint:)])
        {
            [ele touchesEndedWithPoint:point];
        }
    }
    self.userFocusCoordinate = CGPointZero;
}

- (void)touchesCancelledWithPoint:(CGPoint)point
{
    for(Heqz_ChartElement* ele in self.chartElements)
    {
        if([ele respondsToSelector:@selector(touchesCancelledWithPoint:)])
        {
            [ele touchesCancelledWithPoint:point];
        }
    }
    self.userFocusCoordinate = CGPointZero;
}

- (CGPoint)convertRealPointToPixcel:(CGPoint)pt
{
    pt.x = [self locationValue:pt.x withHorizontalRange:self.rangeH];
    pt.y = [self locationValue:pt.y withVerticalRange:self.rangeV];
    return pt;
}

- (void)setNeedShowElement:(id<Heqz_ChartElementProtocol>)element{
    [element setNeedShowChart];
}

- (void)setRangeHWithString:(NSString*)strRange{
    CGPoint pt = CGPointFromString(strRange);
    self.rangeH = Heqz_ChartRangeMake(pt.x, pt.y);
}

- (void)setRangeVWithString:(NSString*)strRange{
    CGPoint pt = CGPointFromString(strRange);
    self.rangeV = Heqz_ChartRangeMake(pt.x, pt.y);
}

@end
