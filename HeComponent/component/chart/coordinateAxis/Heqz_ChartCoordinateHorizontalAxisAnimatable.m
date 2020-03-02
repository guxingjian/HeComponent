//
//  Heqz_ChartCoordinateHorizontalAxisAnimatable.m
//  SinaFinance
//
//  Created by qingzhao on 2019/3/18.
//  Copyright © 2019年 qingzhao. All rights reserved.
//

#import "Heqz_ChartCoordinateHorizontalAxisAnimatable.h"
#import "Heqz_ChartCommonFunc.h"

@implementation Heqz_ChartCoordinateHorizontalAxisAnimatable

- (void)drawAxisText{
    if(self.arrayMarkLabel.count == 0)
        return ;
    
    NSInteger fPosY = self.boundingRect.origin.y + self.baseLineOffset;
    for(Heqz_ChartAxisMarkLabel* label in self.arrayMarkLabel){
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
        CAShapeLayer* textLayer = [Heqz_ChartCommonFunc boundingLayerWithText:label.text];
//        textLayer.anchorPoint = CGPointMake(0, 1);
        textLayer.frame = rtStr;
        [self.canvasLayer addSublayer:textLayer];
    }
}

- (void)drawAxisMarkWithConfig:(Heqz_ChartAxisMarkConfig*)config
{
    if(!config)
        return ;
    
    Heqz_ChartRange rangeMark = [self interSectionWithRange:self.dataAxisRange otherRange:config.markRange];
    if(0 == rangeMark.endValue)
        return ;
    
    CAShapeLayer* markLayer = [[CAShapeLayer alloc] init];
    markLayer.frame = self.canvasLayer.bounds;
    [self.canvasLayer addSublayer:markLayer];
    
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    
    if(config.lineWidth > 0){
        markLayer.lineWidth = config.lineWidth;
    }else{
        markLayer.lineWidth = self.lineWidth;
    }
    
    if(config.markColor){
        markLayer.strokeColor = config.markColor.CGColor;
    }else{
        markLayer.strokeColor = self.axisColor.CGColor;
    }
    
    CGFloat fValue = rangeMark.startValue;
    CGRect rt = self.boundingRect;
    NSInteger fPosY = rt.origin.y + self.baseLineOffset;
    
    if(rangeMark.endValue >= fValue){
        if(config.markDistance <= 0)
            return ;
    }else{
        if(config.markDistance >= 0)
            return ;
    }
    
    while([Heqz_ChartCommonFunc sf_chartAbs:fValue - rangeMark.startValue] <= [Heqz_ChartCommonFunc sf_chartAbs:rangeMark.endValue - rangeMark.startValue]){
        CGFloat fPosX = [self locationForAxisValue:fValue];
        
        [bezierPath moveToPoint:CGPointMake(fPosX, fPosY)];
        if(self.axisMarkBelowAxisLine){
            [bezierPath addLineToPoint:CGPointMake(fPosX, fPosY + config.markLength)];
        }else{
            [bezierPath addLineToPoint:CGPointMake(fPosX, fPosY - config.markLength)];
        }
        fValue += config.markDistance;
    }
    markLayer.path = bezierPath.CGPath;
    markLayer.strokeStart = 0.0;
    markLayer.strokeEnd = 1.0;
}

- (void)drawAxisLine{
    CAShapeLayer* lineLayer = [[CAShapeLayer alloc] init];
    lineLayer.frame = self.canvasLayer.bounds;
    [self.canvasLayer addSublayer:lineLayer];
    
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    
    lineLayer.lineWidth = self.lineWidth;
    lineLayer.strokeColor = self.axisColor.CGColor;
    
    [bezierPath moveToPoint:CGPointMake(self.boundingRect.origin.x, self.boundingRect.origin.y + self.baseLineOffset)];
    [bezierPath addLineToPoint:CGPointMake(self.boundingRect.origin.x + self.boundingRect.size.width, self.boundingRect.origin.y + self.baseLineOffset)];
    lineLayer.path = bezierPath.CGPath;
    lineLayer.strokeStart = 0.0;
    lineLayer.strokeEnd = 1.0;
}

@end
