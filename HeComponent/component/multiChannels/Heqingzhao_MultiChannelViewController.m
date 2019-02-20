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

#define MultiChannel_UnSelectedChannel_Key @"MultiChannel_UnSelectedChannel_Key"
#define MultiChannel_SelectedChannel_Key @"MultiChannel_SelectedChannel_Key"

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
    
    editVc.unselectedTabConfigs = [[NSUserDefaults standardUserDefaults] objectForKey:MultiChannel_UnSelectedChannel_Key];
    [self presentViewController:editVc animated:YES completion:^{
        
    }];
}

- (void)saveSelectedConfig:(NSArray *)selectedConfig unSelectedConfig:(NSArray *)unSelectedConfig{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSMutableArray* arrayTempSelected = [NSMutableArray array];
    for(Heqingzhao_MultiChannelConfig* config in selectedConfig){
        NSData* data = [NSKeyedArchiver archivedDataWithRootObject:config requiringSecureCoding:YES error:nil];
        if(data){
            [arrayTempSelected addObject:data];
        }
    }
    [userDefaults setObject:[NSArray arrayWithArray:arrayTempSelected] forKey:MultiChannel_SelectedChannel_Key];
    
    NSMutableArray* arrayTempUnSelected = [NSMutableArray array];
    for(Heqingzhao_MultiChannelConfig* config in unSelectedConfig){
        NSData* data = [NSKeyedArchiver archivedDataWithRootObject:config requiringSecureCoding:YES error:nil];
        if(data){
            [arrayTempUnSelected addObject:data];
        }
    }
    [userDefaults setObject:[NSArray arrayWithArray:arrayTempUnSelected] forKey:MultiChannel_UnSelectedChannel_Key];
    [self.topBar setArrayTabItem:selectedConfig];
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
    
    NSArray* array = [self colorArray];
    contentView.backgroundColor = [array objectAtIndex:(nIndex%array.count)];
    
    return contentView;
}

@end
