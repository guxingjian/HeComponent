//
//  SFChartFillAnimatable.m
//  SinaFinance
//
//  Created by qingzhao on 2018/5/9.
//  Copyright © 2018年 qingzhao. All rights reserved.
//

#import "SFChartFillAnimatable.h"

@interface SFChartFillAnimatable()

@property(nonatomic, strong)CAShapeLayer* maskLayer;

@end

@implementation SFChartFillAnimatable

- (CAShapeLayer *)maskLayer{
    if(!_maskLayer){
        CAShapeLayer* maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.canvasLayer.bounds;
        maskLayer.lineWidth = 0;
        _maskLayer = maskLayer;
    }
    return _maskLayer;
}

- (void)setNeedShowChart
{
    SFChartPointCollection* ptCollection = self.ptCollection;
    if(ptCollection.length <= 1)
        return ;
    
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    CGPoint ptFirst = ptCollection.firstPoint;
    [bezierPath moveToPoint:ptFirst];
    CGFloat fMinY = ptFirst.y;
    for(NSInteger i = 1; i < ptCollection.length; ++ i)
    {
        CGPoint ptTemp = [ptCollection pointAtIndex:i];
        [bezierPath addLineToPoint:ptTemp];
        if(ptTemp.y < fMinY)
            fMinY = ptTemp.y;
    }
    
    CGPoint ptEnd = ptCollection.lastPoint;
    [bezierPath addLineToPoint:CGPointMake(ptEnd.x, self.baseValue)];
    [bezierPath addLineToPoint:CGPointMake(ptFirst.x, self.baseValue)];
    [bezierPath addLineToPoint:ptFirst];
    
    self.maskLayer.fillColor = self.fromColor.CGColor;
    self.maskLayer.path = bezierPath.CGPath;
    
    if(self.boundingRect.size.height > 0 && fMinY < self.boundingRect.size.height)
    {
        CAGradientLayer* gradientLayer = [CAGradientLayer layer];
        gradientLayer.backgroundColor = [UIColor clearColor].CGColor;
        gradientLayer.frame = self.canvasLayer.bounds;
        gradientLayer.startPoint = CGPointMake(0.5, fMinY/self.canvasLayer.bounds.size.height);
        gradientLayer.endPoint = CGPointMake(0.5, self.baseValue/self.canvasLayer.bounds.size.height);
        gradientLayer.colors = @[(id)self.fromColor.CGColor, (id)self.toColor.CGColor];
        [self.canvasLayer addSublayer:gradientLayer];
        gradientLayer.mask = self.maskLayer;
        [self.arrayCacheLayers addObject:gradientLayer];
    }
}

@end
