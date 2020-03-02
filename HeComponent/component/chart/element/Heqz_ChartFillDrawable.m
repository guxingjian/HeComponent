//
//  Heqz_ChartFillElement.m
//  layoutTest
//
//  Created by qingzhao on 2018/5/3.
//  Copyright © 2018年 qingzhao. All rights reserved.
//

#import "Heqz_ChartFillDrawable.h"

@implementation Heqz_ChartFillDrawable

- (BOOL)drawWithContextIfNeed:(CGContextRef)context
{
    if(![super drawWithContextIfNeed:context])
        return NO;
    
    Heqz_ChartPointCollection* collection = self.ptCollection;
    if(collection.length == 0)
        return NO;
    
    CGContextSaveGState(context);
    CGPoint ptTemp = [collection pointAtIndex:0];
    CGMutablePathRef pathRef = CGPathCreateMutable();
    CGPathMoveToPoint(pathRef, 0, ptTemp.x, ptTemp.y);
    
    for(NSInteger i = 1; i < collection.length; ++ i)
    {
        ptTemp = [collection pointAtIndex:i];
        CGPathAddLineToPoint(pathRef, 0, ptTemp.x, ptTemp.y);
    }
    [self drawFillWithLinePath:pathRef context:context];
    
    CGPathRelease(pathRef);
    CGContextRestoreGState(context);
    return YES;
}

- (void)drawFillWithLinePath:(CGPathRef)linePath context:(CGContextRef)context
{
    CGMutablePathRef fillPathRef = CGPathCreateMutableCopy(linePath);

    Heqz_ChartPointCollection* collection = self.ptCollection;
    CGPoint ptEnd = CGPointMake(collection.lastPoint.x, self.baseValue);
    CGPoint ptStart = CGPointMake(collection.firstPoint.x, self.baseValue);
    CGPathAddLineToPoint(fillPathRef, 0, ptEnd.x, ptEnd.y);
    CGPathAddLineToPoint(fillPathRef, 0, ptStart.x, ptStart.y);
    CGPathAddLineToPoint(fillPathRef, 0, collection.firstPoint.x, collection.firstPoint.y);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 1.0 };
    NSArray *colors = @[(__bridge id) self.fromColor.CGColor, (__bridge id) self.toColor.CGColor];
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
    
    CGRect pathRect = CGPathGetBoundingBox(fillPathRef);
    
    CGPoint startPoint = CGPointMake(CGRectGetMidX(pathRect), CGRectGetMinY(pathRect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(pathRect), CGRectGetMaxY(pathRect));
    
    CGContextSaveGState(context);
    CGContextAddPath(context, fillPathRef);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
    CGPathRelease(fillPathRef);
}

- (void)preProcessWithRangeH:(Heqz_ChartRange)rangeH rangeV:(Heqz_ChartRange)rangeV
{
    if(!CGRectEqualToRect(self.relativeRect, CGRectZero))
    {
        self.ptCollection.relativeRect = self.relativeRect;
    }
    CGRect rt = self.ptCollection.boundingRect;
    self.ptCollection.boundingRect = self.boundingRect;
    [self.ptCollection preProcessWithRangeH:rangeH rangeV:rangeV];
    self.ptCollection.boundingRect = rt;
    self.baseValue = [self locationValue:(self.relativeRect.origin.y + self.baseValue) withVerticalRange:rangeV];
}

@end
