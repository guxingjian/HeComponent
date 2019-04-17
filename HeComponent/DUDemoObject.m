//
//  DUDemoObject.m
//  HeComponent
//
//  Created by qingzhao on 2019/3/6.
//  Copyright © 2019年 qingzhao. All rights reserved.
//

#import "DUDemoObject.h"

@interface DUDemoObject()

@property(nonatomic, assign)NSInteger nTest;

@end

@implementation DUDemoObject

-(void)test{
    _nTest = 100;
    NSLog(@"DUDemoObject: %d", _nTest);
}

@end
