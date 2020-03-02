//
//  SFChartPolylineElement.m
//  SinaFinance
//
//  Created by qingzhao on 2018/5/2.
//  Copyright © 2018年 qingzhao. All rights reserved.
//

#import "SFChartPolylineDrawable.h"

@implementation SFChartPolylineDrawable

- (BOOL)drawWithContextIfNeed:(CGContextRef)context
{
    if(![super drawWithContextIfNeed:context])
        return NO;
    
    SFChartPointCollection* collection = self.ptCollection;
    if(collection.length == 0)
        return NO;
    
    CGContextSaveGState(context);
    
    CGMutablePathRef pathRef = CGPathCreateMutable();
    if(SFChartPolylineType_segment == self.lineType){
        NSInteger nIndex = 0;
        while (collection.length - nIndex >= 2) {
            CGPoint ptTemp = [collection pointAtIndex:nIndex];
            CGPathMoveToPoint(pathRef, 0, ptTemp.x, ptTemp.y);
            
            ptTemp = [collection pointAtIndex:nIndex + 1];
            CGPathAddLineToPoint(pathRef, 0, ptTemp.x, ptTemp.y);
            
            nIndex = nIndex + 2;
        }
    }else{
        CGPoint ptTemp = [collection pointAtIndex:0];
        CGMutablePathRef pathRef = CGPathCreateMutable();
        CGPathMoveToPoint(pathRef, 0, ptTemp.x, ptTemp.y);
        for(NSInteger i = 1; i < collection.length; ++ i)
        {
            ptTemp = [collection pointAtIndex:i];
            CGPathAddLineToPoint(pathRef, 0, ptTemp.x, ptTemp.y);
        }
    }
    
    [self drawPolyLineWithLinePath:pathRef context:context];
    CGPathRelease(pathRef);
    
    CGContextRestoreGState(context);
    return YES;
}

- (void)drawPolyLineWithLinePath:(CGPathRef)linePath context:(CGContextRef)context
{
    CGContextSetLineWidth(context, self.lineWidth);
    CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
    
    if(SFChartPolylineType_dot == self.lineType)
    {
        CGFloat dash[2] = {5,5};
        CGContextSetLineDash(context, 0, dash, 2);
    }
    
    CGContextAddPath(context, linePath);
    CGContextStrokePath(context);
}

- (void)preProcessWithRangeH:(SFChartRange)rangeH rangeV:(SFChartRange)rangeV
{
    if(!CGRectEqualToRect(self.relativeRect, CGRectZero))
    {
        self.ptCollection.relativeRect = self.relativeRect;
    }
    CGRect rt = self.ptCollection.boundingRect;
    self.ptCollection.boundingRect = self.boundingRect;
    [self.ptCollection preProcessWithRangeH:rangeH rangeV:rangeV];
    self.ptCollection.boundingRect = rt;
}

@end
