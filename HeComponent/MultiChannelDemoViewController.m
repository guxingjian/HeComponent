//
//  MultiChannelDemoViewController.m
//  HeComponent
//
//  Created by qingzhao on 2019/2/19.
//  Copyright © 2019年 qingzhao. All rights reserved.
//

#import "MultiChannelDemoViewController.h"

@interface MultiChannelDemoViewController ()

@end

@implementation MultiChannelDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    Heqingzhao_MultiChannelTopBar* topBar = self.topBar;
    
    NSArray* arrayChannels = @[@"tab1", @"tab2",@"tab3",@"tab4", @"tab5",@"tab6",@"tab7", @"tab8",@"tab9"];
    NSMutableArray* arrayItems = [NSMutableArray array];
    
    UIFont* font = [UIFont systemFontOfSize:15];
    UIColor* normalColor = [UIColor blackColor];
    UIColor* selectedColor = [UIColor blueColor];
    for(NSString* title in arrayChannels){
        Heqingzhao_MultiChannelConfig* item = [[Heqingzhao_MultiChannelConfig alloc] init];
        item.topBarConfig.normalTitle = title;
        item.topBarConfig.normalTextColor = normalColor;
        item.topBarConfig.normalFont = font;
        
        item.topBarConfig.selectedTextColor = selectedColor;
        item.topBarConfig.selectedScale = 1.1;
        item.contentProvider = self;
        [arrayItems addObject:item];
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
