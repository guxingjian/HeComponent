//
//  Heqingzhao_ImageLoader.m
//  HeComponent
//
//  Created by qingzhao on 2019/2/21.
//  Copyright © 2019年 qingzhao. All rights reserved.
//

#import "Heqingzhao_ImageLoader.h"

@implementation Heqingzhao_ImageLoader

+ (UIImage *)loadImage:(NSString *)imageName{
    NSString* strPath = nil;
    if([UIScreen mainScreen].scale == 2){
        strPath = [[NSBundle bundleForClass:self] pathForResource:[NSString stringWithFormat:@"%@@2x", imageName] ofType:@"png"];
    }else if([UIScreen mainScreen].scale == 3){
        strPath = [[NSBundle bundleForClass:[self class]] pathForResource:[NSString stringWithFormat:@"%@@3x", imageName] ofType:@"png"];
    }
    return [UIImage imageWithContentsOfFile:strPath];
}

@end
