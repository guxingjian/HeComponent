//
//  Heqz_ChartCommonFunc.m
//  layoutTest
//
//  Created by qingzhao on 2018/5/4.
//  Copyright © 2018年 qingzhao. All rights reserved.
//

#import "Heqz_ChartCommonFunc.h"
#import <CoreText/CoreText.h>

NSString* const TextLayerMaxWidthKey = @"TextLayerMaxWidthKey";

@implementation Heqz_ChartCommonFunc

+ (UIBezierPath *)bezierPathWithText:(NSString *)text attributes:(NSDictionary *)textAttr
{
    return [self bezierPathWithText:text attributes:textAttr contraintWidth:-1];
}

+ (UIBezierPath *)bezierPathWithText:(NSString *)text attributes:(NSDictionary *)textAttr contraintWidth:(CGFloat)maxWidth
{
    if(text.length == 0 || !textAttr)
        return [UIBezierPath bezierPath];
    
    NSAttributedString* attrStr = [[NSAttributedString alloc] initWithString:text attributes:textAttr];
    
    CGMutablePathRef letters = CGPathCreateMutable();
    
    //原文地址 https://www.jianshu.com/p/1c26e4f9d21f
    
    if(maxWidth > 0.8)
    {
        CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attrStr);
        
        CGPathRef framePath = CGPathCreateWithRect(CGRectMake(0, 0, maxWidth, 2000), nil);
        CTFrameRef frameRef = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, attrStr.length), framePath, nil);
        CFArrayRef lines = CTFrameGetLines(frameRef);
        NSInteger lineCount = CFArrayGetCount(lines);
        
        CGPoint* originsBuffer = malloc(sizeof(CGPoint)*lineCount);
        CTFrameGetLineOrigins(frameRef, CFRangeMake(0, lineCount), originsBuffer);
        
        for(NSInteger i = 0; i < lineCount; ++ i)
        {
            CTLineRef line = CFArrayGetValueAtIndex(lines, i);
            if(!line)
                break ;
            
            [self addLetterToLetters:letters withLine:line linesOrigin:originsBuffer[i]];
        }
        CFRelease(framePath);
        CFRelease(frameRef);
        CFRelease(framesetter);
        free(originsBuffer);
    }
    else
    {
        CTLineRef line = CTLineCreateWithAttributedString((CFAttributedStringRef)attrStr);
        [self addLetterToLetters:letters withLine:line linesOrigin:CGPointZero];
        CFRelease(line);
    }
    
    UIBezierPath* bezierPath = [UIBezierPath bezierPathWithCGPath:letters];
    CGPathRelease(letters);
    
    
    return bezierPath;
}

+ (void)addLetterToLetters:(CGMutablePathRef)letters withLine:(CTLineRef)line linesOrigin:(CGPoint)origin
{
    CFArrayRef runArray = CTLineGetGlyphRuns(line);
    for (CFIndex runIndex = 0; runIndex < CFArrayGetCount(runArray); runIndex++) {
        CTRunRef run = (CTRunRef)CFArrayGetValueAtIndex(runArray, runIndex);
        CTFontRef runFont = CFDictionaryGetValue(CTRunGetAttributes(run), kCTFontAttributeName);
        
        for (CFIndex glyphIndex = 0; glyphIndex < CTRunGetGlyphCount(run); glyphIndex++) {
            
            CGGlyph glyph;
            CGPoint position;
            CFRange currentRange = CFRangeMake(glyphIndex, 1);
            CTRunGetGlyphs(run, currentRange, &glyph);
            CTRunGetPositions(run, currentRange, &position);
            
            CGPathRef letter = CTFontCreatePathForGlyph(runFont, glyph, NULL);
            CGAffineTransform t = CGAffineTransformMakeTranslation(position.x, origin.y);
            CGPathAddPath(letters, &t, letter);
            CGPathRelease(letter);
        }
    }
}

+ (CAShapeLayer *)boundingLayerWithText:(NSString *)text attributes:(NSDictionary *)textAttr
{
    return [self boundingLayerWithText:text attributes:textAttr contraintWidth:-1];
}

+ (CAShapeLayer *)boundingLayerWithText:(NSAttributedString *)text{
    NSDictionary* dicAttr = [text attributesAtIndex:0 effectiveRange:nil];
    if(!dicAttr)
        return nil;
    
    return [self boundingLayerWithText:text.string attributes:dicAttr];
}

+ (CAShapeLayer *)boundingLayerWithText:(NSString *)text attributes:(NSDictionary *)textAttr contraintWidth:(CGFloat)maxWidth
{
    UIBezierPath* bezierPath = [self bezierPathWithText:text attributes:textAttr contraintWidth:maxWidth];
    if(!bezierPath)
        return nil;
    
    if(text.length == 0)
        return nil;
    
    return [self textShapeLayerWithBezierPath:bezierPath attributes:textAttr];
}

+ (CAShapeLayer*)textShapeLayerWithBezierPath:(UIBezierPath*)bezierPath attributes:(NSDictionary *)textAttr
{
    CGRect rtPath = bezierPath.bounds;
    [bezierPath applyTransform:CGAffineTransformMakeTranslation(-rtPath.origin.x, -rtPath.origin.y)];
    
    CAShapeLayer* shapeLayer = [CAShapeLayer layer];
    shapeLayer.backgroundColor = [UIColor clearColor].CGColor;
    shapeLayer.path = bezierPath.CGPath;
    shapeLayer.bounds = CGRectMake(0, 0, rtPath.size.width, rtPath.size.height);
    UIColor* colorText = [textAttr objectForKey:NSForegroundColorAttributeName];
    if(![colorText isKindOfClass:[UIColor class]])
    {
        colorText = [UIColor blackColor];
    }
    shapeLayer.fillColor = colorText.CGColor;
    
    CGFloat fScale = 1;
    id maxW = [textAttr objectForKey:TextLayerMaxWidthKey];
    if(maxW)
    {
        CGFloat fMaxW = [maxW floatValue];
        CGFloat fCurrentW = shapeLayer.bounds.size.width*fScale;
        if((fCurrentW > fMaxW) && (fCurrentW != 0))
        {
            fScale = fScale*(fMaxW/fCurrentW);
        }
    }
    
    shapeLayer.transform = CATransform3DMakeScale(fScale, -fScale, 1);
    return shapeLayer;
}

+ (CAShapeLayer *)boundingLayerWithText:(NSString *)text attributes:(NSDictionary *)textAttr maxWidth:(CGFloat)maxWidth scaled:(CGFloat)fScaled
{
    if(text.length == 0 || !textAttr)
        return nil;
    
    CAShapeLayer* textLayer = [self boundingLayerWithText:text attributes:textAttr];
    if(textLayer.bounds.size.width > maxWidth)
    {
        textLayer.bounds = CGRectMake(0, 0, maxWidth, textLayer.bounds.size.height);
    }
    return textLayer;
}

+ (CGFloat)sf_chartAbs:(CGFloat)fv
{
    return fv > 0 ? fv : -fv;
}

+ (Heqz_ChartRange)dataRangeWithData:(NSArray *)arrayData
{
    if(arrayData.count == 0)
        return Heqz_ChartRangeMake(0, 0);
    
    Heqz_ChartRange range = Heqz_ChartRangeMake(MAXFLOAT, -MAXFLOAT);
    for(NSInteger i = 0; i < arrayData.count; ++ i)
    {
        id data = [arrayData objectAtIndex:i];
        if(![data respondsToSelector:@selector(floatValue)])
            continue ;
        CGFloat fV = [data floatValue];
        if(fV < range.startValue)
        {
            range.startValue = fV;
        }
        if(fV > range.endValue)
        {
            range.endValue = fV;
        }
    }
    return range;
}

+ (Heqz_ChartRange)dataRangeWithData:(NSArray*)arrayData dataKey:(NSString*)dataKey
{
    CGFloat fMin = MAXFLOAT;
    CGFloat fMax = -MAXFLOAT;
    for(id data in arrayData)
    {
        if(![data isKindOfClass:[NSDictionary class]])
            continue;
        CGFloat fTemp = [[data objectForKey:dataKey] floatValue];
        if(fTemp < fMin)
        {
            fMin = fTemp;
        }
        if(fTemp > fMax)
        {
            fMax = fTemp;
        }
    }
    
    return Heqz_ChartRangeMake(fMin, fMax);
}

@end
