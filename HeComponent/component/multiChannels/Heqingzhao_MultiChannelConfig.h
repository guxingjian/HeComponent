//
//  Heqingzhao_MultiChannelTopBarTabItem.h
//  HeComponent
//
//  Created by qingzhao on 2019/2/14.
//  Copyright © 2019年 qingzhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Heqingzhao_MultiChannelTopBarConfig : NSObject

@property(nonatomic, strong)NSString* normalTitle;
@property(nonatomic, strong)UIFont* normalFont;
@property(nonatomic, strong)UIColor* normalTextColor;

@property(nonatomic, strong)NSString* selectedTitle;
@property(nonatomic, strong)UIFont* selectedFont;
@property(nonatomic, strong)UIColor* selectedTextColor;

@property(nonatomic, assign)CGFloat maxWidth;
@property(nonatomic, assign)CGFloat maxHeight;

@property(nonatomic, assign)CGFloat selectedScale; // 选中后，title的缩放倍数

@end

@protocol Heqingzhao_MultiChannelConfigProtocol <NSObject>
@required
- (UIView*)contentView;

@end

@interface Heqingzhao_MultiChannelConfig : NSObject

@property(nonatomic, strong)NSString* itemIdentifier; // 默认为normalTitle

@property(nonatomic, assign)BOOL status; // 0 未选中，1 选中
@property(nonatomic, strong)Heqingzhao_MultiChannelTopBarConfig* topBarConfig;
@property(nonatomic, weak)id<Heqingzhao_MultiChannelConfigProtocol> contentProvider;


@end
