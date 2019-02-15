//
//  Heqingzhao_MultiChannelTopBarTabItem.h
//  HeComponent
//
//  Created by qingzhao on 2019/2/14.
//  Copyright © 2019年 qingzhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Heqingzhao_MultiChannelTopBarTabItem : NSObject

@property(nonatomic, strong)NSString* itemIdentifier; // 默认为normalTitle

@property(nonatomic, strong)NSString* normalTitle;
@property(nonatomic, strong)UIFont* normalFont;
@property(nonatomic, strong)UIColor* normalTextColor;

@property(nonatomic, strong)NSString* selectedTitle;
@property(nonatomic, strong)UIFont* selectedFont;
@property(nonatomic, strong)UIColor* selectedTextColor;

@property(nonatomic, assign)BOOL status; // 0 未选中，1 选中
@property(nonatomic, assign)CGFloat fCurrentWidth;
@property(nonatomic, assign)CGFloat fCurrentHeight;

@end
