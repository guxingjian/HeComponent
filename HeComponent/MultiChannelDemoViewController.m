//
//  MultiChannelDemoViewController.m
//  HeComponent
//
//  Created by qingzhao on 2019/2/19.
//  Copyright © 2019年 qingzhao. All rights reserved.
//

#import "MultiChannelDemoViewController.h"

#define MultiChannel_SelectedChannel_Key @"MultiChannel_SelectedChannel_Key"

@interface MultiChannelDemoViewController ()

@end

@implementation MultiChannelDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    Heqingzhao_MultiChannelTopBar* topBar = self.topBar;
    
    NSMutableArray* arrayItems = [NSMutableArray array];
    
    NSArray* arrayConfig = [[NSUserDefaults standardUserDefaults] objectForKey:MultiChannel_SelectedChannel_Key];
    if(!arrayConfig){
        UIFont* font = [UIFont systemFontOfSize:15];
        UIColor* normalColor = [UIColor blackColor];
        UIColor* selectedColor = [UIColor blueColor];
        for(NSInteger i = 0; i < 10; ++ i){
            NSString* title = [NSString stringWithFormat:@"tab%ld", i];
            Heqingzhao_MultiChannelConfig* item = [[Heqingzhao_MultiChannelConfig alloc] init];
            item.topBarConfig.normalTitle = title;
            item.topBarConfig.normalTextColor = normalColor;
            item.topBarConfig.normalFont = font;
            
            item.topBarConfig.selectedTextColor = selectedColor;
            item.topBarConfig.selectedScale = 1.1;
            item.contentProvider = self;// 可以自由设定，可以是当前类，也可以是指定的类
            [arrayItems addObject:item];
        }
    }else{
        [arrayItems addObjectsFromArray:arrayConfig];
        
        UIFont* font = [UIFont systemFontOfSize:15];
        for(NSInteger i = 0; i < arrayItems.count; ++ i){
            Heqingzhao_MultiChannelConfig* item = [arrayItems objectAtIndex:i];
            item.topBarConfig.normalFont = font;
            item.contentProvider = self;// 可以自由设定，可以是当前类，也可以是指定的类
        }
    }
    
    //    topBar.rightItemWidth = 80;
    topBar.tabItemSpace = 30;
    topBar.edgeSpace = 15;
    topBar.itemBottomDistance = 20;
    topBar.animateLineViewDis = 16;
    topBar.arrayTabItem = arrayItems;
    
    self.contentView.arrayTabItem = arrayItems;
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
