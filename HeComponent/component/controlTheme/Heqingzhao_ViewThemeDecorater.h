//
//  Heqingzhao_ViewDecorater.h
//  HeComponent
//
//  Created by qingzhao on 2019/7/4.
//  Copyright © 2019年 qingzhao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/*
 
 config
 {
 backgroundColor:#333333,
 borderColor:#333333,
 borderWidth:1,
 cornerRadius:2
 }
 
 */

@interface Heqingzhao_ViewThemeDecorater : NSObject

- (void)decorateView:(UIView*)view withConfig:(NSDictionary*)config;

@end

NS_ASSUME_NONNULL_END
