//
//  Heqingzhao_MultiChannelTopBarTabItem.m
//  HeComponent
//
//  Created by qingzhao on 2019/2/14.
//  Copyright © 2019年 qingzhao. All rights reserved.
//

#import "Heqingzhao_MultiChannelConfig.h"

@interface Heqingzhao_MultiChannelTopBarConfig()

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

@end

