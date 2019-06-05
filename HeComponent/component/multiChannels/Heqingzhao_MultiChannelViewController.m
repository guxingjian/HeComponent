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
#import "Heqingzhao_AppContext.h"
#import "UIColor+extension_qingzhao.h"

#define LABEL_TAG 139018423

@interface Heqingzhao_MultiChannelViewController ()<Heqingzhao_MultiChannelEditViewControllerDelegate>

@end

@implementation Heqingzhao_MultiChannelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGFloat fTopBarHeight = [[Heqingzhao_AppContext sharedAppContext] topBarHeight];
    
    Heqingzhao_MultiChannelTopBar* topBar = [[Heqingzhao_MultiChannelTopBar alloc] initWithFrame:CGRectMake(0, 0, self.view.width, fTopBarHeight)];
    topBar.delegate = self;
    topBar.backgroundColor = [UIColor colorWithHexString:@"#F3F4F9"];
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
    editVc.unselectedTabConfigs = [Heqingzhao_MultiChannelConfig getConfigArrayWithKey:MultiChannel_UnSelectedChannel_Key];
    [self presentViewController:editVc animated:YES completion:^{
        
    }];
}

- (void)saveSelectedConfig:(NSArray *)selectedConfig unSelectedConfig:(NSArray *)unSelectedConfig{
    if(selectedConfig.count > 0){
        Heqingzhao_MultiChannelConfig* config = selectedConfig.firstObject;
        id<Heqingzhao_MultiChannelConfigProtocol> contentProvider = config.contentProvider;
        for(Heqingzhao_MultiChannelConfig* config in selectedConfig){
            if(!config.contentProvider){
                config.contentProvider = contentProvider;
            }
        }
    }
    [self.topBar setArrayTabItem:selectedConfig];
    [self.contentView setArrayTabItem:selectedConfig];
    
    [Heqingzhao_MultiChannelConfig saveConfigArray:selectedConfig dataKey:MultiChannel_SelectedChannel_Key];
    [Heqingzhao_MultiChannelConfig saveConfigArray:unSelectedConfig dataKey:MultiChannel_UnSelectedChannel_Key];
}

- (void)multiChannelContentView:(Heqingzhao_MultiChannelContentView *)contentView willSelectIndex:(NSInteger)nIndex withChannelView:(UIView *)view andConfig:(Heqingzhao_MultiChannelConfig *)config{
    UILabel* labelContent = [view viewWithTag:LABEL_TAG];
    labelContent.text = config.topBarConfig.normalTitle;
    NSArray* array = [self colorArray];
    view.backgroundColor = [array objectAtIndex:(nIndex%array.count)];
}

- (void)multiChannelContentView:(Heqingzhao_MultiChannelContentView *)contentView didSelectIndex:(NSInteger)nIndex withChannelView:(UIView *)view andConfig:(Heqingzhao_MultiChannelConfig *)config{
    self.topBar.selectedIndex = nIndex;
}

- (void)multiChannelContentView:(Heqingzhao_MultiChannelContentView *)contentView scrollingWithIndex:(CGFloat)fIndex{
    [self.topBar scrollToIndex:fIndex gradient:YES];
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
    labelContent.tag = LABEL_TAG;
    
    NSArray* array = [self colorArray];
    contentView.backgroundColor = [array objectAtIndex:(nIndex%array.count)];
    
    return contentView;
}

@end
