//
//  Heqz_CrashCatcher.h
//  HeComponent
//
//  Created by qingzhao on 2019/5/24.
//  Copyright © 2019年 qingzhao. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol Heqz_CrashCatcherDelegate <NSObject>

- (void)crashCatcherDidCatchInfo:(NSString*)strInfo;

@end

@interface Heqz_CrashCatcher : NSObject

@property(nonatomic, weak)id<Heqz_CrashCatcherDelegate> delegate;

+ (instancetype)sharedCrashCatcher;
- (void)startCrashCatcher;

@end
