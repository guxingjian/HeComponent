//
//  UIView+SkinConfig.h
//  HeComponent
//
//  Created by qingzhao on 2019/7/4.
//  Copyright © 2019年 qingzhao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^ThemeDecorateHandller)(void);

@interface UIView(ThemeConfig)

@property(nonatomic, strong)NSString* themeSkin;
@property(nonatomic, strong)ThemeDecorateHandller decorateHandller;
@property(nonatomic, strong)NSString* currentConfigFile;
@property(nonatomic, readonly)NSString* controlCategory;

@end

NS_ASSUME_NONNULL_END
