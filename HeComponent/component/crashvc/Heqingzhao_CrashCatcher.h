//
//  Heqingzhao_CrashCatcher.h
//  HeComponent
//
//  Created by qingzhao on 2019/5/24.
//  Copyright © 2019年 qingzhao. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol Heqingzhao_CrashCatcherDelegate <NSObject>

- (void)crashCatcherDidCatchInfo:(NSString*)strInfo;

@end

@interface Heqingzhao_CrashCatcher : NSObject

@property(nonatomic, weak)id<Heqingzhao_CrashCatcherDelegate> delegate;

+ (instancetype)sharedCrashCatcher;
- (void)startCrashCatcher;

@end
