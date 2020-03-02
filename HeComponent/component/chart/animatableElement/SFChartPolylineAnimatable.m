//
//  SFChartPolylineAnimatable.m
//  layoutTest
//
//  Created by qingzhao on 2018/5/4.
//  Copyright © 2018年 qingzhao. All rights reserved.
//

#import "SFChartPolylineAnimatable.h"

@interface SFChartPolylineAnimatable()

@end

@implementation SFChartPolylineAnimatable

- (instancetype)init
{
    if(self = [super init])
    {
        self.animationDuration = 1;
    }
    return self;
}

- (void)setNeedShowChart
{
    SFChartPointCollection* ptCollection = self.ptCollection;

    UIBezierPath* bezierPaht = [UIBezierPath bezierPath];
    
    if(ptCollection.length >= 2){
        if(SFChartPolylineType_segment == self.lineType){
            NSInteger nIndex = 0;
            while (ptCollection.length - nIndex >= 2) {
                CGPoint ptTemp = [ptCollection pointAtIndex:nIndex];
                [bezierPaht moveToPoint:ptTemp];
                
                ptTemp = [ptCollection pointAtIndex:nIndex + 1];
                [bezierPaht addLineToPoint:ptTemp];
                nIndex = nIndex + 2;
            }
        }else{
            [bezierPaht moveToPoint:[ptCollection pointAtIndex:0]];
            for(NSInteger i = 1; i < ptCollection.length; ++ i){
                [bezierPaht addLineToPoint:[ptCollection pointAtIndex:i]];
            }
        }
    }
    
    CAShapeLayer* animateLayer = self.commonShapeLayer;
    animateLayer.path = bezierPaht.CGPath;
    animateLayer.lineWidth = self.lineWidth;
    if(SFChartPolylineType_dot == self.lineType)
    {
        animateLayer.lineDashPattern = @[@5, @5];
    }
    animateLayer.strokeColor = self.lineColor.CGColor;
    
    if(self.bDisableAnimation)
    {
        animateLayer.strokeEnd = 1.0;
    }
    else
    {
        animateLayer.strokeEnd = 0;
        [super setNeedShowChart];
    }
}

@end
