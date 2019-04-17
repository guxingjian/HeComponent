//
//  MultiChannelDemoViewController.m
//  HeComponent
//
//  Created by qingzhao on 2019/2/19.
//  Copyright © 2019年 qingzhao. All rights reserved.
//

#import "MultiChannelDemoViewController.h"
#import "TableControllerDemoViewController.h"
#import "DUDemoChildObject.h"
#import <objc/runtime.h>

@interface MultiChannelDemoViewController ()

@end

@implementation MultiChannelDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    Heqingzhao_MultiChannelTopBar* topBar = self.topBar;
    
    NSArray* arrayConfig = [Heqingzhao_MultiChannelConfig getConfigArrayWithKey:MultiChannel_SelectedChannel_Key contentProvider:self];
    if(arrayConfig.count == 0){
        NSMutableArray* arrayItems = [NSMutableArray array];
        
        UIFont* font = [UIFont systemFontOfSize:15];
        UIColor* normalColor = [UIColor blackColor];
        UIColor* selectedColor = [UIColor blueColor];
        for(NSInteger i = 0; i < 20; ++ i){
            NSString* title = [NSString stringWithFormat:@"tab%ld", i];
            Heqingzhao_MultiChannelConfig* item = [[Heqingzhao_MultiChannelConfig alloc] init];
            item.topBarConfig.normalTitle = title;
            item.topBarConfig.normalTextColor = normalColor;
            item.topBarConfig.normalFont = font;
            
            item.topBarConfig.selectedTextColor = selectedColor;
            item.topBarConfig.selectedScale = 1.1;
            item.contentProvider = self;// 可以自由设定，可以是当前类，也可以是指定的类
            item.contentResuseIdentifier = @"contentView"; // 设置contentView重用标识
            
            [arrayItems addObject:item];
        }
        arrayConfig = arrayItems;
    }
    
    //    topBar.rightItemWidth = 80;
    topBar.tabItemSpace = 30;
    topBar.edgeSpace = 15;
    topBar.itemBottomDistance = 15;
    topBar.animateLineViewDis = 13;
    
    // 最好在设置arrayTabItem之前设置好参数
    topBar.arrayTabItem = arrayConfig;
    
    self.contentView.enableReuseContentView = YES;
    // 最好在设置arrayTabItem之前设置好参数
    self.contentView.arrayTabItem = arrayConfig;
    
//    DUDemoChildObject* childObj = [[DUDemoChildObject alloc] init];
//    [childObj test];
    
    [self test:^(NSInteger nIndex) {
        NSLog(@"nIndex: %ld", nIndex);
    }];


//
//    Method me = class_getInstanceMethod([self class], @selector(test:));
//    const char* methodDes = method_getTypeEncoding(me);
//    NSLog(@"methodDes: %s", methodDes);
}

- (void)test:(void(^)(NSInteger nIndex))compleHandler{
    NSLog(@"test");
    compleHandler(100);
}

- (UIView *)contentViewWithIndex:(NSInteger)nIndex config:(Heqingzhao_MultiChannelConfig *)config{
    UIView* contentView = nil;
    if([config.topBarConfig.normalTitle isEqualToString:@"tab0"]){
        TableControllerDemoViewController* tableViewController = [[TableControllerDemoViewController alloc] init];
        contentView = tableViewController.view;
        [self addChildViewController:tableViewController];
    }else{
        contentView = [super contentViewWithIndex:nIndex config:config];
    }
    
    return contentView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
