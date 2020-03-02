//
//  Heqz_ChartPtCollectionAnimatable.m
//  SinaFinance
//
//  Created by qingzhao on 2018/5/8.
//  Copyright © 2018年 qingzhao. All rights reserved.
//

#import "Heqz_ChartPtCollectionAnimatable.h"

@implementation Heqz_ChartPtCollectionAnimatable

- (void)setNeedShowChart
{
    if(self.length == 0)
        return ;
    
    CGMutablePathRef pathRef = CGPathCreateMutable();
    for(NSInteger i = 0; i < self.length; ++ i)
    {
        CGPoint pt = [self pointAtIndex:i];
        CGPathAddEllipseInRect(pathRef, nil, CGRectMake(pt.x - self.ptRadius, pt.y - self.ptRadius, self.ptRadius*2, self.ptRadius*2));
    }
    
    CAShapeLayer* layer = self.commonShapeLayer;
    layer.path = pathRef;
    layer.fillColor = self.ptFillColor.CGColor;
    CGPathRelease(pathRef);
}

@end
