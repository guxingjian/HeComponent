//
//  Heqingzhao_MultiChannelTopBarTabItem.m
//  HeComponent
//
//  Created by qingzhao on 2019/2/14.
//  Copyright © 2019年 qingzhao. All rights reserved.
//

#import "Heqingzhao_MultiChannelConfig.h"

@interface Heqingzhao_MultiChannelTopBarConfig()<NSCoding>

@property(nonatomic, assign)CGSize normalSize;
@property(nonatomic, assign)CGSize selectedSize;

@end

@implementation Heqingzhao_MultiChannelTopBarConfig

- (NSString *)selectedTitle{
    if(!_selectedTitle)
        return _normalTitle;
    return _selectedTitle;
}

- (UIFont *)selectedFont{
    if(!_selectedFont)
        return _normalFont;
    return _selectedFont;
}

- (UIColor *)selectedTextColor{
    if(!_selectedTextColor)
        return _normalTextColor;
    return _selectedTextColor;
}

- (CGSize)normalSize{
    if(CGSizeEqualToSize(CGSizeZero, _normalSize)){
        if(!self.normalFont)
            return CGSizeZero;
        
        CGSize sizeNormal = [self.normalTitle boundingRectWithSize:CGSizeMake(1000, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.normalFont} context:nil].size;
        _normalSize = sizeNormal;
    }
    return _normalSize;
}

- (CGSize)selectedSize{
    if(CGSizeEqualToSize(CGSizeZero, _selectedSize)){
        if(!self.selectedFont)
            return CGSizeZero;
        
        CGSize sizeSelected = [self.selectedTitle boundingRectWithSize:CGSizeMake(1000, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.selectedFont} context:nil].size;
        _selectedSize = sizeSelected;
    }
    return _selectedSize;
}

- (CGFloat)maxWidth{
    if(self.normalSize.width > self.selectedSize.width)
        return self.normalSize.width;
    return self.selectedSize.width;
}

- (CGFloat)maxHeight{
    if(self.normalSize.height > self.selectedSize.height)
        return self.normalSize.height;
    return self.selectedSize.height;
}

- (CGFloat)selectedScale{
    if(0 == _selectedScale){
        return 1;
    }
    return _selectedScale;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder setValue:self.normalTitle forKey:@"normalTitle"];
    
//    [aCoder setValue:self.normalFont.fontName forKey:@"normalFont_fontName"];
//    [aCoder setValue:[NSNumber numberWithFloat:self.normalFont.pointSize] forKey:@"normalFont_pointSize"];
    
    CGFloat colorBuffer[4] = {};
    [self.normalTextColor getRed:(CGFloat*)colorBuffer green:((CGFloat*)colorBuffer + 1) blue:((CGFloat*)colorBuffer + 2) alpha:((CGFloat*)colorBuffer + 3)];
    [aCoder setValue:[NSNumber numberWithFloat:colorBuffer[0]] forKey:@"normalTextColor_r"];
    [aCoder setValue:[NSNumber numberWithFloat:colorBuffer[1]] forKey:@"normalTextColor_g"];
    [aCoder setValue:[NSNumber numberWithFloat:colorBuffer[2]] forKey:@"normalTextColor_b"];
    [aCoder setValue:[NSNumber numberWithFloat:colorBuffer[3]] forKey:@"normalTextColor_a"];
    
    [aCoder setValue:self.selectedTitle forKey:@"selectedTitle"];
//    [aCoder setValue:self.selectedFont.fontName forKey:@"selectedFont_fontName"];
//    [aCoder setValue:[NSNumber numberWithFloat:self.selectedFont.pointSize] forKey:@"selectedFont_pointSize"];
    
    [self.selectedTextColor getRed:(CGFloat*)colorBuffer green:((CGFloat*)colorBuffer + 1) blue:((CGFloat*)colorBuffer + 2) alpha:((CGFloat*)colorBuffer + 3)];
    [aCoder setValue:[NSNumber numberWithFloat:colorBuffer[0]] forKey:@"selectedTextColor_r"];
    [aCoder setValue:[NSNumber numberWithFloat:colorBuffer[1]] forKey:@"selectedTextColor_g"];
    [aCoder setValue:[NSNumber numberWithFloat:colorBuffer[2]] forKey:@"selectedTextColor_b"];
    [aCoder setValue:[NSNumber numberWithFloat:colorBuffer[3]] forKey:@"selectedTextColor_a"];
    
    [aCoder setValue:[NSNumber numberWithFloat:self.selectedScale] forKey:@"selectedScale"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super init]){
        self.normalTitle = [aDecoder valueForKey:@"normalTitle"];
        NSNumber* num = [aDecoder valueForKey:@"normalFont_pointSize"];
//        self.normalFont = [UIFont fontWithName:[aDecoder valueForKey:@"normalFont_fontName"] size:num.floatValue];
        NSNumber* num_r = [aDecoder valueForKey:@"normalTextColor_r"];
        NSNumber* num_g = [aDecoder valueForKey:@"normalTextColor_g"];
        NSNumber* num_b = [aDecoder valueForKey:@"normalTextColor_b"];
        NSNumber* num_a = [aDecoder valueForKey:@"normalTextColor_a"];
        self.normalTextColor = [UIColor colorWithRed:num_r.floatValue green:num_g.floatValue blue:num_b.floatValue alpha:num_a.floatValue];
        
        self.selectedTitle = [aDecoder valueForKey:@"selectedTitle"];
        num = [aDecoder valueForKey:@"selectedFont_pointSize"];
//        self.selectedFont = [UIFont fontWithName:[aDecoder valueForKey:@"selectedFont_fontName"] size:num.floatValue];
        num_r = [aDecoder valueForKey:@"selectedTextColor_r"];
        num_g = [aDecoder valueForKey:@"selectedTextColor_g"];
        num_b = [aDecoder valueForKey:@"selectedTextColor_b"];
        num_a = [aDecoder valueForKey:@"selectedTextColor_a"];
        self.selectedTextColor = [UIColor colorWithRed:num_r.floatValue green:num_g.floatValue blue:num_b.floatValue alpha:num_a.floatValue];
        
        num = [aDecoder valueForKey:@"selectedScale"];
        self.selectedScale = num.floatValue;
    }
    return self;
}

@end

@implementation Heqingzhao_MultiChannelConfig

- (Heqingzhao_MultiChannelTopBarConfig *)topBarConfig{
    if(!_topBarConfig){
        _topBarConfig = [[Heqingzhao_MultiChannelTopBarConfig alloc] init];
    }
    return _topBarConfig;
}

- (BOOL)isEqual:(id)object
{
    if(![object isKindOfClass:[self class]])
        return [super isEqual:object];
    
    Heqingzhao_MultiChannelConfig* item = (Heqingzhao_MultiChannelConfig*)object;
    return [self.itemIdentifier isEqual:item.itemIdentifier];
}

- (NSString *)itemIdentifier{
    if(!_itemIdentifier){
        _itemIdentifier = self.topBarConfig.normalTitle;
    }
    return _itemIdentifier;
}

- (NSString *)description{
    return [NSString stringWithFormat:@"%@_%@", [super description], self.itemIdentifier];
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder setValue:self.itemIdentifier forKey:@"itemIdentifier"];
    [aCoder setValue:[NSNumber numberWithBool:self.status] forKey:@"status"];
    [self.topBarConfig encodeWithCoder:aCoder];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super init]){
        self.itemIdentifier = [aDecoder valueForKey:@"itemIdentifier"];
        NSNumber* num = [aDecoder valueForKey:@"status"];
        self.status = [num boolValue];
        self.topBarConfig = [[Heqingzhao_MultiChannelTopBarConfig alloc] initWithCoder:aDecoder];
    }
    return self;
}

@end

