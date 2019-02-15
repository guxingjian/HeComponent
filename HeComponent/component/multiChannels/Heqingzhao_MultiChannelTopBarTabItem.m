//
//  Heqingzhao_MultiChannelTopBarTabItem.m
//  HeComponent
//
//  Created by qingzhao on 2019/2/14.
//  Copyright © 2019年 qingzhao. All rights reserved.
//

#import "Heqingzhao_MultiChannelTopBarTabItem.h"

@interface Heqingzhao_MultiChannelTopBarTabItem()

@property(nonatomic, assign)CGSize normalSize;
@property(nonatomic, assign)CGSize selectedSize;

@end

@implementation Heqingzhao_MultiChannelTopBarTabItem

- (void)setNormalTitle:(NSString *)normalTitle{
    if(!self.itemIdentifier)
        self.itemIdentifier = normalTitle;
    _normalTitle = normalTitle;
}

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

- (BOOL)isEqual:(id)object
{
    if(![object isKindOfClass:[self class]])
        return [super isEqual:object];
    
    Heqingzhao_MultiChannelTopBarTabItem* item = (Heqingzhao_MultiChannelTopBarTabItem*)object;
    return [self.itemIdentifier isEqual:item.itemIdentifier];
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

- (CGFloat)fCurrentWidth{
    if(0 == self.status){
        return self.normalSize.width;
    }
    return self.selectedSize.width;
}

- (CGFloat)fCurrentHeight{
    if(0 == self.status){
        return self.normalSize.height;
    }
    return self.selectedSize.height;
}

@end
