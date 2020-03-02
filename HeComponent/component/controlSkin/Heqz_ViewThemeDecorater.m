//
//  Heqz_ViewDecorater.m
//  HeComponent
//
//  Created by qingzhao on 2019/7/4.
//  Copyright © 2019年 qingzhao. All rights reserved.
//

#import "Heqz_ViewThemeDecorater.h"
#import "UIColor+extension_qingzhao.h"

@implementation Heqz_ViewThemeDecorater

- (void)decorateView:(UIView *)view withConfig:(NSDictionary *)config{
    for(NSString* key in config.allKeys){
        id value = [config objectForKey:key];
        if([key isEqualToString:@"backgroundColor"]){
            [view setBackgroundColor:[UIColor colorWithHexString:value]];
        }else if([key isEqualToString:@"borderColor"]){
            view.layer.borderColor = [UIColor colorWithHexString:value].CGColor;
        }else if([key isEqualToString:@"borderWidth"]){
            view.layer.borderWidth = [value floatValue];
        }else if([key isEqualToString:@"cornerRadius"]){
            view.layer.cornerRadius = [value floatValue];
            view.layer.masksToBounds = YES;
        }
    }
}

@end
