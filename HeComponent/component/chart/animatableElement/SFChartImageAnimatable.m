//
//  SFChartImageAnimatable.m
//  SinaFinance
//
//  Created by qingzhao on 2018/5/25.
//  Copyright © 2018年 qingzhao. All rights reserved.
//

#import "SFChartImageAnimatable.h"

@interface SFChartImageAnimatable()

@end

@implementation SFChartImageAnimatable

+ (instancetype)chartImageWithImage:(UIImage *)image
{
    SFChartImageAnimatable* chartImage = [[self alloc] init];
    chartImage.image = image;
    
    return chartImage;
}

- (instancetype)init
{
    if(self = [super init])
    {
        self.anchorPoint = CGPointMake(0.5, 0.5);
    }
    return self;
}

- (void)setNeedShowChart{
    CALayer* imageLayer = [CALayer layer];
    imageLayer.contentsScale = [UIScreen mainScreen].scale;
    imageLayer.contents = (id)self.image.CGImage;
    imageLayer.anchorPoint = self.anchorPoint;
    imageLayer.bounds = CGRectMake(0, 0, self.image.size.width, self.image.size.height);
    if(CGPointEqualToPoint(CGPointZero, self.posiInValue))
    {
        imageLayer.position = CGPointMake(self.boundingRect.origin.x + self.boundingRect.size.width/2, self.boundingRect.origin.y + self.boundingRect.size.height/2);
    }
    else
    {
        imageLayer.position = CGPointMake(self.posiInValue.x + self.offsetInPoint.x, self.posiInValue.y + self.offsetInPoint.y);
    }
    
    [self.canvasLayer addSublayer:imageLayer];
    [self.arrayCacheLayers addObject:imageLayer];
}

- (void)preProcessWithRangeH:(SFChartRange)rangeH rangeV:(SFChartRange)rangeV
{
    CGPoint pt = self.posiInValue;
    pt.x = [self locationValue:(self.relativeRect.origin.x + pt.x) withHorizontalRange:rangeH];
    pt.y = [self locationValue:(self.relativeRect.origin.y + pt.y) withVerticalRange:rangeV];
    
    self.posiInValue = pt;
}

@end
