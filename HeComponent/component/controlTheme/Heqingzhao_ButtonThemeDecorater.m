//
//  Heqingzhao_ButtonSkinDecorater.m
//  HeComponent
//
//  Created by qingzhao on 2019/7/4.
//  Copyright © 2019年 qingzhao. All rights reserved.
//

#import "Heqingzhao_ButtonThemeDecorater.h"
#import "UIColor+extension_qingzhao.h"

@implementation Heqingzhao_ButtonThemeDecorater

- (void)decorateView:(UIView*)view withConfig:(NSDictionary*)config{
    [super decorateView:view withConfig:config];
    
    UIButton* button = (UIButton*)view;
    if(![button isKindOfClass:[UIButton class]])
        return ;
    
    for(NSString* key in config.allKeys){
        id value = [config objectForKey:key];
        if([key isEqualToString:@"textColor"]){
            [button setTitleColor:[UIColor colorWithHexString:value] forState:UIControlStateNormal];
        }else if([key isEqualToString:@"font"]){
            NSDictionary* dicFont = (NSDictionary*)value;
            NSNumber* fontSize = [dicFont objectForKey:@"fontSize"];
            if(dicFont.allKeys.count == 1){
                [button.titleLabel setFont:[UIFont systemFontOfSize:fontSize.floatValue]];
                continue ;
            }
            NSString* fontName = [dicFont objectForKey:@"fontName"];
            if(fontName.length > 0){
                [button.titleLabel  setFont:[UIFont fontWithName:fontName size:fontSize.floatValue]];
                continue ;
            }
            NSNumber* isBold = [dicFont objectForKey:@"isBold"];
            if([isBold boolValue]){
                [button.titleLabel setFont:[UIFont boldSystemFontOfSize:fontSize.floatValue]];
            }else{
                [button.titleLabel setFont:[UIFont systemFontOfSize:fontSize.floatValue]];
            }
        }
    }
}

@end
