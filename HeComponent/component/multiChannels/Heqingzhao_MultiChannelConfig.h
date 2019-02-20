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

@class Heqingzhao_MultiChannelConfig;

@protocol Heqingzhao_MultiChannelConfigProtocol <NSObject>
@required

// 当contentView移动到选定的view之前，会调用对应的config的contentProvider的这个方法
// 可以在这个方法中提供自定义view，以及做一些网络请求之类的操作
// 在移动到指定index后，会自动预加载index-1和index+1(如果和之前的index不同)的view
- (UIView*)contentViewWithIndex:(NSInteger)nIndex config:(Heqingzhao_MultiChannelConfig*)config;

@end

@interface Heqingzhao_MultiChannelConfig : NSObject<NSCoding>

@property(nonatomic, strong)NSString* itemIdentifier; // 默认为normalTitle

@property(nonatomic, assign)BOOL status; // 0 未选中，1 选中
@property(nonatomic, strong)Heqingzhao_MultiChannelTopBarConfig* topBarConfig;
@property(nonatomic, weak)id<Heqingzhao_MultiChannelConfigProtocol> contentProvider;


@end
