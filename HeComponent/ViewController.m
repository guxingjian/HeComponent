//
//  ViewController.m
//  HeComponent
//
//  Created by qingzhao on 2019/2/14.
//  Copyright © 2019年 qingzhao. All rights reserved.
//

#import "ViewController.h"
#import "Heqingzhao_MultiChannelTopBar.h"
#import "UIView+view_frame.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    Heqingzhao_MultiChannelTopBar* topBar = [[Heqingzhao_MultiChannelTopBar alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 80)];
    
    NSArray* arrayChannels = @[@"沪深", @"港股",@"美股",@"英股",@"环球",@"外汇",@"基金",@"债券",@"新三板",@"数字货币",];
    NSMutableArray* arrayItems = [NSMutableArray array];
    
    UIFont* font = [UIFont systemFontOfSize:15];
    UIColor* normalColor = [UIColor blackColor];
    UIColor* selectedColor = [UIColor blueColor];
    for(NSString* title in arrayChannels){
        Heqingzhao_MultiChannelTopBarTabItem* item = [[Heqingzhao_MultiChannelTopBarTabItem alloc] init];
        item.normalTitle = title;
        item.normalTextColor = normalColor;
        item.normalFont = font;
        
        item.selectedTextColor = selectedColor;
        [arrayItems addObject:item];
    }
    
//    topBar.rightItemWidth = 80;
    topBar.tabItemSpace = 30;
    topBar.edgeSpace = 15;
    topBar.itemBottomDistance = 20;
    topBar.animateLineViewDis = 16;
    topBar.backgroundColor = [UIColor yellowColor];
    
    topBar.arrayTabItem = arrayItems;
    
    [self.view addSubview:topBar];
    
}


@end
