//
//  Heqz_ChartTextAnimatable.m
//  SinaFinance
//
//  Created by qingzhao on 2018/5/8.
//  Copyright © 2018年 qingzhao. All rights reserved.
//

#import "Heqz_ChartTextAnimatable.h"
#import "Heqz_ChartCommonFunc.h"

@implementation Heqz_ChartTextModel

+ (instancetype)model
{
    Heqz_ChartTextModel* model = [[self alloc] init];
    model.anchorPoint = CGPointMake(0.5, 0.5);
    return model;
}

@end

@interface Heqz_ChartTextAnimatable()

@end

@implementation Heqz_ChartTextAnimatable

- (void)setNeedShowChart{
    for(NSInteger i = 0; i < self.arrayText.count; ++ i)
    {
        Heqz_ChartTextModel* model = [self.arrayText objectAtIndex:i];
        CAShapeLayer* layer = nil;
        if(i < self.arrayTextLayer.count)
        {
            layer = [self.arrayTextLayer objectAtIndex:i];
        }
        else
        {
            layer = [Heqz_ChartCommonFunc boundingLayerWithText:model.text attributes:model.dicAttr contraintWidth:model.constraintWidth];
        }
        if(layer){
            layer.anchorPoint = model.anchorPoint;
            layer.position = CGPointMake(model.posiInValue.x + model.offsetInPoint.x,model.posiInValue.y + model.offsetInPoint.y);
            [self.canvasLayer addSublayer:layer];
            [self.arrayCacheLayers addObject:layer];
        }
    }
}

- (void)preProcessWithRangeH:(Heqz_ChartRange)rangeH rangeV:(Heqz_ChartRange)rangeV
{
    if(self.bHadProcessData)
        return ;
    
    CGRect relativeRect = self.relativeRect;
    for(Heqz_ChartTextModel* model in self.arrayText)
    {
        CGPoint pt = model.posiInValue;
        pt.x = [self locationValue:(relativeRect.origin.x + pt.x) withHorizontalRange:rangeH];
        pt.y = [self locationValue:(relativeRect.origin.y + pt.y) withVerticalRange:rangeV];
        
        CGFloat fZero = [self locationValue:(relativeRect.origin.y + 0) withVerticalRange:rangeV];
        if(rangeV.endValue > rangeV.startValue)
        {
            if(model.posiInValue.y > 0 && (fZero - pt.y < model.fMinHeight))
            {
                pt.y = fZero - model.fMinHeight;
            }
            else if(model.posiInValue.y < 0 && (pt.y - fZero < model.fMinHeight))
            {
                pt.y = fZero + model.fMinHeight;
            }
        }
        else
        {
            if(model.posiInValue.y > 0 && (pt.y - fZero < model.fMinHeight))
            {
                pt.y = fZero + model.fMinHeight;
            }
            else if(model.posiInValue.y < 0 && (fZero - pt.y < model.fMinHeight))
            {
                pt.y = fZero - model.fMinHeight;
            }
        }
        
        model.posiInValue = pt;
    }
}

@end
