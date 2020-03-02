//
//  Heqz_ChartBaseLayer.m
//  layoutTest
//
//  Created by qingzhao on 2018/5/3.
//  Copyright © 2018年 qingzhao. All rights reserved.
//

#import "Heqz_ChartLayer.h"
#import <UIKit/UIKit.h>

@implementation Heqz_ChartLayer

- (instancetype)init
{
    if(self = [super init])
    {
        self.contentsScale = [UIScreen mainScreen].scale;
        self.opaque = NO;
        self.backgroundColor = [UIColor clearColor].CGColor;
    }
    return self;
}

- (void)drawInContext:(CGContextRef)ctx
{
    CGContextSaveGState(ctx);
    UIGraphicsPushContext(ctx);

    for(id<Heqz_ChartElementProtocol> chart in self.arrayChart)
    {
        if([chart respondsToSelector:@selector(drawWithContextIfNeed:)])
        {
            [chart drawWithContextIfNeed:ctx];
        }
    }

    UIGraphicsPopContext();
    CGContextRestoreGState(ctx);
}

- (void)setBackgroundColor:(CGColorRef)backgroundColor
{
    backgroundColor = [UIColor clearColor].CGColor;
    [super setBackgroundColor:backgroundColor];
}

- (void)setContentsScale:(CGFloat)contentsScale
{
    contentsScale = [UIScreen mainScreen].scale;
    [super setContentsScale:contentsScale];
}

@end
