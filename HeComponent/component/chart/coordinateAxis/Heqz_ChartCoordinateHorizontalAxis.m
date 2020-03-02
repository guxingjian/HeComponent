//
//  Heqz_ChartCoordinateHorizontalAxis.m
//  SinaFinance
//
//  Created by qingzhao on 2018/5/1.
//  Copyright © 2018年 qingzhao. All rights reserved.
//

#import "Heqz_ChartCoordinateHorizontalAxis.h"
#import "Heqz_ChartCommonFunc.h"

@implementation Heqz_ChartCoordinateHorizontalAxis

- (void)drawAxisTextWithContext:(CGContextRef)context
{
    if(self.arrayMarkLabel.count == 0)
        return ;
    
    NSInteger fPosY = self.boundingRect.origin.y + self.baseLineOffset;
    for(Heqz_ChartAxisMarkLabel* label in self.arrayMarkLabel)
    {
        CGRect rtStr = [label textRect];
        if(CGRectEqualToRect(rtStr, CGRectZero))
            continue ;
        
        CGFloat fPosX = [self locationForAxisValue:label.axisLocation];
        if(Heqz_ChartAlignmentCenter == label.alignment)
        {
            rtStr.origin.x = fPosX - rtStr.size.width/2;
        }
        else if(Heqz_ChartAlignmentLeft == label.alignment)
        {
            rtStr.origin.x = fPosX;
        }
        else if(Heqz_ChartAlignmentRight == label.alignment)
        {
            rtStr.origin.x = fPosX - rtStr.size.width;
        }
        
        if(self.axisTextAboveAxisLine)
        {
            rtStr.origin.y = fPosY - label.spacing - rtStr.size.height;
        }
        else
        {
            rtStr.origin.y = fPosY + label.spacing;
        }
        [label.text drawInRect:rtStr];
    }
}

- (void)drawAxisMarkWithConfig:(Heqz_ChartAxisMarkConfig*)config context:(CGContextRef)context
{
    if(!config)
        return ;
    
    Heqz_ChartRange rangeMark = [self interSectionWithRange:self.dataAxisRange otherRange:config.markRange];
    if(0 == rangeMark.endValue)
        return ;
    
    if(config.lineWidth > 0)
    {
        CGContextSetLineWidth(context, config.lineWidth);
    }
    else
    {
        CGContextSetLineWidth(context, self.lineWidth);
    }
    
    if(config.markColor)
    {
        CGContextSetStrokeColorWithColor(context, config.markColor.CGColor);
    }
    else
    {
        CGContextSetStrokeColorWithColor(context, self.axisColor.CGColor);
    }
    
    CGFloat fValue = rangeMark.startValue;
    CGRect rt = self.boundingRect;
    NSInteger fPosY = rt.origin.y + self.baseLineOffset;

    if(rangeMark.endValue >= fValue)
    {
        if(config.markDistance <= 0)
            return ;
    }
    else
    {
        if(config.markDistance >= 0)
            return ;
    }
    
    while([Heqz_ChartCommonFunc sf_chartAbs:fValue - rangeMark.startValue] <= [Heqz_ChartCommonFunc sf_chartAbs:rangeMark.endValue - rangeMark.startValue])
    {
        CGFloat fPosX = [self locationForAxisValue:fValue];
        CGContextMoveToPoint(context, fPosX, fPosY);
        
        if(self.axisMarkBelowAxisLine)
        {
            CGContextAddLineToPoint(context, fPosX, fPosY + config.markLength);
        }
        else
        {
            CGContextAddLineToPoint(context, fPosX, fPosY - config.markLength);
        }
        
        fValue += config.markDistance;
    }
    CGContextStrokePath(context);
}

- (void)drawAxisLineWithContext:(CGContextRef)context
{
    CGContextSetLineWidth(context, self.lineWidth);
    CGContextSetStrokeColorWithColor(context, self.axisColor.CGColor);
    CGContextMoveToPoint(context, self.boundingRect.origin.x, self.boundingRect.origin.y + self.baseLineOffset);
    CGContextAddLineToPoint(context, self.boundingRect.origin.x + self.boundingRect.size.width, self.boundingRect.origin.y + self.baseLineOffset);
    CGContextStrokePath(context);
}

- (CGFloat)locationForAxisValue:(CGFloat)value
{
    return [self locationValue:value withHorizontalRange:self.dataAxisRange];
}

- (CGPoint)convertRealPointToPixcel:(CGPoint)pt
{
    pt.x = [self locationForAxisValue:pt.x];
    return pt;
}

@end
