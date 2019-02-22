//
//  Heqingzhao_MultiChannelViewController.m
//  HeComponent
//
//  Created by qingzhao on 2019/2/14.
//  Copyright © 2019年 qingzhao. All rights reserved.
//

#import "Heqingzhao_MultiChannelViewController.h"
#import "UIView+view_frame.h"
#import "Heqingzhao_MultiChannelEditViewController.h"

@interface Heqingzhao_MultiChannelViewController ()<Heqingzhao_MultiChannelEditViewControllerDelegate>

@end

@implementation Heqingzhao_MultiChannelViewController

- (CGFloat)topNaviHeight{
    return 88;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGFloat fNaviHeight = [self topNaviHeight];
    
    Heqingzhao_MultiChannelTopBar* topBar = [[Heqingzhao_MultiChannelTopBar alloc] initWithFrame:CGRectMake(0, 0, self.view.width, fNaviHeight)];
    topBar.delegate = self;
    [self.view addSubview:topBar];
    self.topBar = topBar;
    
    Heqingzhao_MultiChannelContentView* channelContentView = [[Heqingzhao_MultiChannelContentView alloc] initWithFrame:CGRectMake(0, topBar.bottom, self.view.width, self.view.height - topBar.bottom)];
    channelContentView.delegate = self;
    
    [self.view addSubview:channelContentView];
    self.contentView = channelContentView;
}

- (void)topBar:(Heqingzhao_MultiChannelTopBar *)topBar didSelectIndex:(NSInteger)index item:(Heqingzhao_MultiChannelConfig *)item{
    self.contentView.selectedIndex = index;
}

- (void)topBar:(Heqingzhao_MultiChannelTopBar *)topBar rightItemAction:(UIButton *)btn arrayItems:(NSArray *)arrayItems{
    Heqingzhao_MultiChannelEditViewController* editVc = [[Heqingzhao_MultiChannelEditViewController alloc] init];
    editVc.delegate = self;
    editVc.selectedTabConfigs = arrayItems;
    
    NSArray* arrayConfig = [[NSUserDefaults standardUserDefaults] objectForKey:MultiChannel_UnSelectedChannel_Key];
    NSMutableArray* arrayUnSelectedConfig = [NSMutableArray array];
    
    for(NSInteger i = 0; i < arrayConfig.count; ++ i){
        NSData* data = [arrayConfig objectAtIndex:i];
        Heqingzhao_MultiChannelConfig* config = [NSKeyedUnarchiver unarchivedObjectOfClass:[Heqingzhao_MultiChannelConfig class] fromData:data error:nil];
        if(config){
            [arrayUnSelectedConfig addObject:config];
        }
        config.contentProvider = self;
    }
    
    editVc.unselectedTabConfigs = arrayUnSelectedConfig;
    [self presentViewController:editVc animated:YES completion:^{
        
    }];
}

- (void)saveSelectedConfig:(NSArray *)selectedConfig unSelectedConfig:(NSArray *)unSelectedConfig{
    [self.topBar setArrayTabItem:selectedConfig];
    [self.contentView setArrayTabItem:selectedConfig];
    
    [Heqingzhao_MultiChannelConfig saveConfigArray:selectedConfig dataKey:MultiChannel_SelectedChannel_Key];
    [Heqingzhao_MultiChannelConfig saveConfigArray:unSelectedConfig dataKey:MultiChannel_UnSelectedChannel_Key];
}

- (void)multiChannelContentView:(Heqingzhao_MultiChannelContentView *)contentView willSelectIndex:(NSInteger)nIndex withChannelView:(UIView *)view andConfig:(Heqingzhao_MultiChannelConfig *)config{
    UILabel* labelContent = [view viewWithTag:1001];
    labelContent.text = config.topBarConfig.normalTitle;
    NSArray* array = [self colorArray];
    view.backgroundColor = [array objectAtIndex:(nIndex%array.count)];
}

- (void)multiChannelContentView:(Heqingzhao_MultiChannelContentView *)contentView didSelectIndex:(NSInteger)nIndex withChannelView:(UIView *)view andConfig:(Heqingzhao_MultiChannelConfig *)config{
    self.topBar.selectedIndex = nIndex;
}

- (void)multiChannelContentView:(Heqingzhao_MultiChannelContentView *)contentView scrollingWithIndex:(CGFloat)fIndex{
    [self.topBar scrollToIndex:fIndex];
}

- (NSArray*)colorArray{
    return @[[UIColor whiteColor], [UIColor grayColor], [UIColor greenColor], [UIColor blueColor], [UIColor yellowColor]];
}

- (UIView *)contentViewWithIndex:(NSInteger)nIndex config:(Heqingzhao_MultiChannelConfig *)config{
    UIView* contentView = [[UIView alloc] initWithFrame:self.contentView.bounds];
    
    UILabel* labelContent = [[UILabel alloc] initWithFrame:CGRectMake(contentView.center.x - 100/2, contentView.center.y - 80/2, 100, 80)];
    labelContent.font = [UIFont systemFontOfSize:15];
    labelContent.textColor = [UIColor redColor];
    labelContent.text = config.topBarConfig.normalTitle;
    labelContent.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:labelContent];
    labelContent.tag = 1001;
    
    NSArray* array = [self colorArray];
    contentView.backgroundColor = [array objectAtIndex:(nIndex%array.count)];
    
    return contentView;
}

@end
