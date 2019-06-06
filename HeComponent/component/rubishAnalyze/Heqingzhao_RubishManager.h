//
//  Heqingzhao_RubishManager.h
//  HeComponent
//
//  Created by qingzhao on 2019/6/6.
//  Copyright © 2019年 qingzhao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Heqingzhao_RubishManager : NSObject

// 指定收集的类的前缀
@property(nonatomic, strong)NSArray* arrayClassPreStr;

+ (instancetype)sharedManager;

- (void)collectAllClassName;
- (void)collectUsedClassName:(NSString*)clsName;

// 收集mainBundle中所有png图片
- (void)collectAllImageName;
- (void)collectUsedImageName:(NSString*)imgName;

// 收集mainBundle中所有xib资源
- (void)collectAllXibName;
- (void)collectUsedXibName:(NSString*)xibName;

- (void)analyzeUnUsedResource;

@end

NS_ASSUME_NONNULL_END
