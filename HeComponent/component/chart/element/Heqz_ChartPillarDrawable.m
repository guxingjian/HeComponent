//
//  Heqz_ChartPillarElement.m
//  SinaFinance
//
//  Created by qingzhao on 2018/5/2.
//  Copyright © 2018年 qingzhao. All rights reserved.
//

#import "Heqz_ChartPillarDrawable.h"

@implementation Heqz_ChartPillarModel

+ (instancetype)model
{
    return [[self alloc] init];
}

- (void)setTextAttri:(NSDictionary *)textAttri
{
    _textAttri = textAttri;
    if(self.tipText)
    {
        self.rtText = [self.tipText boundingRectWithSize:CGSizeMake(MAXFLOAT, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:textAttri context:nil];
    }
}

- (void)setTipText:(NSString *)tipText
{
    _tipText = tipText;
    if(self.textAttri)
    {
        self.rtText = [tipText boundingRectWithSize:CGSizeMake(MAXFLOAT, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:self.textAttri context:nil];
    }
}

@end

@interface Heqz_ChartPillarDrawable()

@end

@implementation Heqz_ChartPillarDrawable

- (instancetype)init{
    if(self = [super init]){
        self.updatePillarValueH = YES;
    }
    return self;
}

- (void)preProcessWithRangeH:(Heqz_ChartRange)rangeH rangeV:(Heqz_ChartRange)rangeV
{
    CGRect relativeRect = self.relativeRect;
    
    if(self.updatePillarValueH){
        self.pillarValueH = [self locationValue:(relativeRect.origin.x + self.pillarValueH) withHorizontalRange:rangeH];
        self.updatePillarValueH = NO;
    }
    
    for(Heqz_ChartPillarModel* model in _arrayPillar)
    {
        Heqz_ChartRange range = model.range;
        range.startValue = [self locationValue:(relativeRect.origin.y + range.startValue) withVerticalRange:rangeV];
        range.endValue = [self locationValue:(relativeRect.origin.y + range.endValue) withVerticalRange:rangeV];
        model.range = range;
    }
}

- (BOOL)drawWithContextIfNeed:(CGContextRef)context
{
    if(![super drawWithContextIfNeed:context])
        return NO;
    
    if(self.arrayPillar.count == 0)
        return NO;
    
    CGContextSaveGState(context);
    
    CGFloat fTotalW = [self getPillarWidth];
    CGFloat fPosX = self.pillarValueH - fTotalW/2;
    
    if(self.pillarWidth > 0)
    {
        for(Heqz_ChartPillarModel* model in self.arrayPillar)
        {
            [self drawPillarModel:model pillarWith:self.pillarWidth posX:fPosX context:context];
            fPosX += (self.pillarWidth + self.pillarSpace);
        }
    }
    else
    {
        for(Heqz_ChartPillarModel* model in self.arrayPillar)
        {
            [self drawPillarModel:model pillarWith:model.width posX:fPosX context:context];
            fPosX += (model.width + self.pillarSpace);
        }
    }
    
    CGContextSaveGState(context);
    return YES;
}

- (void)drawPillarModel:(Heqz_ChartPillarModel*)model pillarWith:(CGFloat)pillarW posX:(CGFloat)posX context:(CGContextRef)context
{
    CGRect fillRect = CGRectZero;
    CGFloat fTextPosY = 0;
    
    Heqz_ChartRange range = model.range;
    if(range.startValue > range.endValue)
    {
        CGFloat fH = range.startValue - range.endValue;
        if(fH < model.fMinHeight)
        {
            fH = model.fMinHeight;
        }
        fillRect = CGRectMake(posX, range.startValue - fH, pillarW, fH);
        fTextPosY = fillRect.origin.y - model.textSpace - model.rtText.size.height;
    }
    else
    {
        CGFloat fH = range.endValue - range.startValue;
        if(fH < model.fMinHeight)
        {
            fH = model.fMinHeight;
        }
        fillRect = CGRectMake(posX, range.startValue, pillarW, fH);
        fTextPosY = fillRect.origin.y + fillRect.size.height + model.textSpace;
    }
    
    CGContextSetFillColorWithColor(context, model.fillColor.CGColor);
    CGContextFillRect(context, fillRect);
    
    [model.tipText drawInRect:CGRectMake(self.pillarValueH - model.rtText.size.width/2, fTextPosY, model.rtText.size.width, model.rtText.size.height) withAttributes:model.textAttri];
}

- (CGFloat)getPillarWidth
{
    if(self.pillarWidth > 0)
    {
        return (self.pillarWidth*self.arrayPillar.count + self.pillarSpace*(self.arrayPillar.count - 1));
    }
    
    CGFloat fTotalW = 0;
    for(Heqz_ChartPillarModel* model in self.arrayPillar)
    {
        fTotalW += model.width;
        fTotalW += self.pillarSpace;
    }
    fTotalW -= self.pillarSpace;
    return fTotalW;
}

@end
