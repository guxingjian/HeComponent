//
//  Heqz_ChartCoordinateVerticalAxis.m
//  SinaFinance
//
//  Created by qingzhao on 2018/5/1.
//  Copyright © 2018年 qingzhao. All rights reserved.
//

#import "Heqz_ChartCoordinateVerticalAxis.h"
#import "Heqz_ChartCommonFunc.h"

@implementation Heqz_ChartCoordinateVerticalAxis

- (void)drawAxisTextWithContext:(CGContextRef)context
{
    if(self.arrayMarkLabel.count == 0)
        return ;
    
    NSInteger fPosX = self.boundingRect.origin.x + self.baseLineOffset;
    for(Heqz_ChartAxisMarkLabel* label in self.arrayMarkLabel)
    {
        CGRect rtStr = [label textRect];
        if(CGRectEqualToRect(rtStr, CGRectZero))
            continue ;
        CGFloat fPosY = [self locationForAxisValue:label.axisLocation];
        if(Heqz_ChartAlignmentCenter == label.alignment)
        {
            rtStr.origin.y = fPosY - rtStr.size.height/2;
        }
        else if(Heqz_ChartAlignmentTop == label.alignment)
        {
            rtStr.origin.y = fPosY;
        }
        else if(Heqz_ChartAlignmentBottom == label.alignment)
        {
            rtStr.origin.y = fPosY - rtStr.size.height;
        }
        
        if(self.axisTextOnAxisLineRight)
        {
            rtStr.origin.x = fPosX + label.spacing;
        }
        else
        {
            rtStr.origin.x = fPosX - label.spacing - rtStr.size.width;
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
    NSInteger fPosX = self.boundingRect.origin.x + self.baseLineOffset;
    
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
        CGFloat fPosY = [self locationForAxisValue:fValue];
        CGContextMoveToPoint(context, fPosX, fPosY);
        
        if(self.axisMarkOnAxisLineLeft)
        {
            CGContextAddLineToPoint(context, fPosX - config.markLength, fPosY);
        }
        else
        {
            CGContextAddLineToPoint(context, fPosX + config.markLength, fPosY);
        }
        
        fValue += config.markDistance;
    }
    CGContextStrokePath(context);
}

- (void)drawAxisLineWithContext:(CGContextRef)context
{
    CGContextSetLineWidth(context, self.lineWidth);
    CGContextSetStrokeColorWithColor(context, self.axisColor.CGColor);
    CGContextMoveToPoint(context, self.boundingRect.origin.x + self.baseLineOffset, self.boundingRect.origin.y);
    CGContextAddLineToPoint(context, self.boundingRect.origin.x + self.baseLineOffset, self.boundingRect.origin.y + self.boundingRect.size.height);
    CGContextStrokePath(context);
}

- (CGFloat)locationForAxisValue:(CGFloat)value
{
    return [self locationValue:value withVerticalRange:self.dataAxisRange];
}

- (CGPoint)convertRealPointToPixcel:(CGPoint)pt
{
    pt.y = [self locationForAxisValue:pt.y];
    return pt;
}

@end
