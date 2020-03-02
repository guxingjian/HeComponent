//
//  Heqz_RubishManager.h
//  HeComponent
//
//  Created by qingzhao on 2019/6/6.
//  Copyright © 2019年 qingzhao. All rights reserved.
//

#import <UIKit/UIKit.h>

// 只能收集使用代码创建的图片的名字
// 从xib上加载的UIImageView和UIButton等的图片暂时不能hook到

@interface UIImage(nameCollection)

+ (void)exchangeImageNamed;

@end
