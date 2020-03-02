//
//  SFChartPillarAnimatable.m
//  layoutTest
//
//  Created by qingzhao on 2018/5/4.
//  Copyright © 2018年 qingzhao. All rights reserved.
//

#import "SFChartPillarAnimatable.h"
#import "SFChartCommonFunc.h"

@interface SFChartPillarAnimatable()

@end

@implementation SFChartPillarAnimatable

- (void)setNeedShowChart{
    if(self.arrayPillar.count == 0)
        return ;
    
    CGFloat fTotalW = [self getPillarWidth];
    CGFloat fPosX = self.pillarValueH - fTotalW/2;
    
    if(self.pillarWidth > 0)
    {
        for(SFChartPillarModel* model in self.arrayPillar)
        {
            [self addPillarModel:model pillarWidth:self.pillarWidth posX:fPosX];
            fPosX += (self.pillarWidth + self.pillarSpace);
        }
    }
    else
    {
        for(SFChartPillarModel* model in self.arrayPillar)
        {
            [self addPillarModel:model pillarWidth:model.width posX:fPosX];
            fPosX += (model.width + self.pillarSpace);
        }
    }
}

- (void)addPillarModel:(SFChartPillarModel*)model pillarWidth:(CGFloat)pillarW posX:(CGFloat)posX
{
    CAShapeLayer* pillarLayer = [CAShapeLayer layer];
    pillarLayer.masksToBounds = YES;
    
    CGFloat fAdjustLen = 0;
    CGFloat fW = pillarW;
    CGRect rtText = model.rtText;
    
    if(model.tipText.length > 0)
    {
        fAdjustLen += rtText.size.height + model.textSpace;
        if(rtText.size.width > fW)
        {
            fW = rtText.size.width;
        }
    }
    
    CGMutablePathRef pathRef = CGPathCreateMutable();
    
    SFChartRange range = model.range;
    if(range.startValue > range.endValue)
    {
        CGFloat fH = range.startValue - range.endValue;
        if(fH != 0 && fH < model.fMinHeight)
        {
            fH = model.fMinHeight;
        }
        pillarLayer.anchorPoint = CGPointMake(0, 1);
        pillarLayer.bounds = CGRectMake(0, 0, fW, fH + fAdjustLen);
        
        CGPathAddRect(pathRef, nil, CGRectMake(fW/2 - pillarW/2, fAdjustLen, pillarW, fH));
        rtText = CGRectMake(fW/2 - rtText.size.width/2, 0, rtText.size.width, rtText.size.height);
    }
    else
    {
        CGFloat fH = range.endValue - range.startValue;
        if(fH != 0 && fH < model.fMinHeight)
        {
            fH = model.fMinHeight;
        }
        pillarLayer.anchorPoint = CGPointMake(0, 0);
        pillarLayer.bounds = CGRectMake(0, 0, fW, fH + fAdjustLen);
        CGPathAddRect(pathRef, nil, CGRectMake(fW/2 - pillarW/2, 0, pillarW, fH));
        rtText = CGRectMake(fW/2 - rtText.size.width/2, pillarLayer.bounds.size.height - rtText.size.height, rtText.size.width, rtText.size.height);
    }
    pillarLayer.position = CGPointMake(posX + pillarW/2 - fW/2, range.startValue);
    pillarLayer.path = pathRef;
    pillarLayer.fillColor = model.fillColor.CGColor;
    
    if(model.tipText.length > 0)
    {
        CAShapeLayer* textShape = [SFChartCommonFunc boundingLayerWithText:model.tipText attributes:model.textAttri];
        if(textShape)
        {
            textShape.position = CGPointMake(rtText.origin.x + rtText.size.width/2, rtText.origin.y + rtText.size.height/2);
            [pillarLayer addSublayer:textShape];
        }
    }
    
    [self.canvasLayer addSublayer:pillarLayer];
    [self.arrayCacheLayers addObject:pillarLayer];
    
    CGPathRelease(pathRef);
}

- (void)displayShowAnimation
{
    if(self.arrayCacheLayers.count == 0)
        return ;
    
    for(CAShapeLayer* layer in self.arrayCacheLayers)
    {
        CAAnimation* animation = nil;
        if(self.animationDelegate && [self.animationDelegate respondsToSelector:@selector(customAnimationForShapeLayer:)])
        {
            animation = [self.animationDelegate customAnimationForShapeLayer:layer];
        }
        else
        {
            CABasicAnimation* boundsAnimation = [CABasicAnimation animationWithKeyPath:@"bounds"];
            boundsAnimation.fromValue = [NSValue valueWithCGRect:CGRectMake(0, 0, layer.bounds.size.width, 0)];
            boundsAnimation.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, layer.bounds.size.width, layer.bounds.size.height)];
            boundsAnimation.duration = 1;
            animation = boundsAnimation;
        }
        [layer addAnimation:animation forKey:@"animation"];
    }
}

@end
