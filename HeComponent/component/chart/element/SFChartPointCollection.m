//
//  SFChartPointCollection.m
//  SinaFinance
//
//  Created by qingzhao on 2018/5/2.
//  Copyright © 2018年 qingzhao. All rights reserved.
//

#import "SFChartPointCollection.h"

@implementation SFChartPointCollection
{
    CGPoint* _pointBuffer;
    NSUInteger _nCapacity;
}

- (void)dealloc
{
    if(_pointBuffer)
    {
        free(_pointBuffer);
        _pointBuffer = 0;
    }
}

- (instancetype)init
{
    return [self initWithCapacity:0];
}

- (instancetype)initWithCapacity:(NSInteger)nCap{
    if(self = [super init]){
        if(nCap <= 0){
            nCap = 10;
        }
        _nCapacity = nCap;
        self.bDisableAnimation = YES;
        [self adjustCapacity];
    }
    return self;
}

- (void)adjustCapacity
{
    if(self.length > 0)
    {
        _pointBuffer = (CGPoint*)realloc(_pointBuffer, _nCapacity*sizeof(CGPoint));
    }
    else
    {
        _pointBuffer = malloc(_nCapacity*sizeof(CGPoint));
    }
}

- (void)addPoint:(CGPoint)pt
{
    if(self.length > 0)
    {
        CGPoint prePt = *(_pointBuffer + self.length - 1);
        if(CGPointEqualToPoint(pt, prePt))
            return ;
    }
    
    *(_pointBuffer + self.length) = pt;
    self.length ++;
    if(_nCapacity - self.length <= 0)
    {
        _nCapacity += 10;
        [self adjustCapacity];
    }
}

- (CGPoint)pointAtIndex:(NSUInteger)nIndex
{
    if(nIndex < self.length)
    {
        return _pointBuffer[nIndex];
    }
    return CGPointZero;
}

- (void)clear
{
    self.length = 0;
    self.bHadProcessData = NO;
}

- (CGPoint)firstPoint
{
    if(self.length > 0)
        return _pointBuffer[0];
    return CGPointZero;
}

- (CGPoint)lastPoint
{
    if(self.length > 0)
        return _pointBuffer[self.length - 1];
    return CGPointZero;
}

- (BOOL)drawWithContextIfNeed:(CGContextRef)context
{
    if(![super drawWithContextIfNeed:context])
        return NO;
    
    CGContextSaveGState(context);
    
    CGContextSetFillColorWithColor(context, self.ptFillColor.CGColor);
    
    for(NSInteger i = 0; i < self.length; ++ i)
    {
        CGPoint pt = [self pointAtIndex:i];
        CGContextFillRect(context, CGRectMake(pt.x - self.ptRadius, pt.y - self.ptRadius, self.ptRadius*2, self.ptRadius*2));
    }
    CGContextRestoreGState(context);
    
    return YES;
}

- (void)preProcessWithRangeH:(SFChartRange)rangeH rangeV:(SFChartRange)rangeV
{
    if(self.bHadProcessData)
        return ;
    
    self.bHadProcessData = YES;
    CGRect relativeRect = self.relativeRect;
    for(NSInteger i = 0; i < self.length; ++ i)
    {
        CGPoint pt = _pointBuffer[i];
        pt.x = [self locationValue:(relativeRect.origin.x + pt.x) withHorizontalRange:rangeH];
        pt.y = [self locationValue:(relativeRect.origin.y + pt.y) withVerticalRange:rangeV];
        _pointBuffer[i] = pt;
    }
}

@end
