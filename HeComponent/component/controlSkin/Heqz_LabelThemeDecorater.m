//
//  Heqz_LabelSkinDecorater.m
//  HeComponent
//
//  Created by qingzhao on 2019/7/4.
//  Copyright © 2019年 qingzhao. All rights reserved.
//

#import "Heqz_LabelThemeDecorater.h"
#import "UIColor+extension_qingzhao.h"

@implementation Heqz_LabelThemeDecorater

- (void)decorateView:(UIView *)view withConfig:(NSDictionary *)config{
    [super decorateView:view withConfig:config];
    UILabel* label = (UILabel*)view;
    if(![label isKindOfClass:[UILabel class]])
        return ;
    
    for(NSString* key in config.allKeys){
        id value = [config objectForKey:key];
        if([key isEqualToString:@"textColor"]){
            [label setTextColor:[UIColor colorWithHexString:value]];
        }else if([key isEqualToString:@"font"]){
            NSDictionary* dicFont = (NSDictionary*)value;
            NSNumber* fontSize = [dicFont objectForKey:@"fontSize"];
            if(dicFont.allKeys.count == 1){
                [label setFont:[UIFont systemFontOfSize:fontSize.floatValue]];
                continue ;
            }
            NSString* fontName = [dicFont objectForKey:@"fontName"];
            if(fontName.length > 0){
                [label  setFont:[UIFont fontWithName:fontName size:fontSize.floatValue]];
                continue ;
            }
            NSNumber* isBold = [dicFont objectForKey:@"isBold"];
            if([isBold boolValue]){
                [label setFont:[UIFont boldSystemFontOfSize:fontSize.floatValue]];
            }else{
                [label setFont:[UIFont systemFontOfSize:fontSize.floatValue]];
            }
        }
    }
}

@end
