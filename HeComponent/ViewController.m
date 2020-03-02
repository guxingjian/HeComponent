//
//  ViewController.m
//  HeComponent
//
//  Created by qingzhao on 2019/2/14.
//  Copyright © 2019年 qingzhao. All rights reserved.
//

#import "ViewController.h"
#import "Heqz_MultiChannelTopBar.h"
#import "UIView+view_frame.h"
#import "Heqz_MultiChannelContentView.h"

@interface ViewController ()<Heqz_MultiChannelConfigProtocol, Heqz_MultiChannelTopBarDelegate, Heqz_MultiChannelContentViewDelegate>

@property(nonatomic, strong)Heqz_MultiChannelTopBar* topBar;
@property(nonatomic, strong)Heqz_MultiChannelContentView* contentView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    Heqz_MultiChannelTopBar* topBar = [[Heqz_MultiChannelTopBar alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 80)];
    topBar.delegate = self;
    topBar.tabItemLayout = Heqz_MultiChannelTopBarLayout_Divide;
    topBar.hideAnimatedLine = YES;
    
    NSArray* arrayChannels = @[@"沪深", @"港股",@"美股"];
    NSMutableArray* arrayItems = [NSMutableArray array];
    
    UIFont* font = [UIFont systemFontOfSize:15];
    UIColor* normalColor = [UIColor blackColor];
    UIColor* selectedColor = [UIColor blueColor];
    for(NSString* title in arrayChannels){
        Heqz_MultiChannelConfig* item = [[Heqz_MultiChannelConfig alloc] init];
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
    topBar.backgroundColor = [UIColor yellowColor];
    topBar.arrayTabItem = arrayItems;
    [self.view addSubview:topBar];
    
    self.topBar = topBar;
    
    Heqz_MultiChannelContentView* channelContentView = [[Heqz_MultiChannelContentView alloc] initWithFrame:CGRectMake(0, topBar.bottom, self.view.width, self.view.height - topBar.bottom)];
    channelContentView.delegate = self;
    channelContentView.arrayTabItem = arrayItems;
    
    [self.view addSubview:channelContentView];
    self.contentView = channelContentView;
}

- (NSArray*)colorArray{
    return @[[UIColor whiteColor], [UIColor grayColor], [UIColor greenColor], [UIColor blueColor], [UIColor yellowColor]];
}

- (UIView *)contentViewWithIndex:(NSInteger)nIndex config:(Heqz_MultiChannelConfig *)config{
    UIView* contentView = [[UIView alloc] initWithFrame:self.contentView.bounds];
    
    UILabel* labelContent = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 100, 80)];
    labelContent.font = [UIFont systemFontOfSize:15];
    labelContent.textColor = [UIColor redColor];
    labelContent.text = config.topBarConfig.normalTitle;
    [contentView addSubview:labelContent];
    
    NSArray* array = [self colorArray];
    contentView.backgroundColor = [array objectAtIndex:(nIndex%array.count)];
    
    return contentView;
}

- (void)topBar:(Heqz_MultiChannelTopBar *)topBar willSelectIndex:(NSInteger)index item:(Heqz_MultiChannelConfig *)item{
//    self.contentView.selectedIndex = index;
}

- (void)topBar:(Heqz_MultiChannelTopBar *)topBar didSelectIndex:(NSInteger)index item:(Heqz_MultiChannelConfig *)item{
    self.contentView.selectedIndex = index;
}

- (void)multiChannelContentView:(Heqz_MultiChannelContentView *)contentView willSelectIndex:(NSInteger)nIndex withChannelView:(UIView *)view andConfig:(Heqz_MultiChannelConfig *)config{
    self.topBar.selectedIndex = nIndex;
}

- (void)multiChannelContentView:(Heqz_MultiChannelContentView *)contentView didSelectIndex:(NSInteger)nIndex withChannelView:(UIView *)view andConfig:(Heqz_MultiChannelConfig *)config{
    self.topBar.selectedIndex = nIndex;
}

- (void)multiChannelContentView:(Heqz_MultiChannelContentView *)contentView scrollingWithIndex:(CGFloat)fIndex{
    [self.topBar scrollToIndex:fIndex gradient:YES];
}

@end
