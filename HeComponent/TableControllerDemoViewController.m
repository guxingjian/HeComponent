//
//  TableControllerDemoViewController.m
//  HeComponent
//
//  Created by qingzhao on 2019/3/1.
//  Copyright © 2019年 qingzhao. All rights reserved.
//

#import "TableControllerDemoViewController.h"
#import "Heqingzhao_TableViewController.h"
#import "Heqingzhao_TopLoadingView.h"
#import "UIView+view_frame.h"
#import "Heqingzhao_AppContext.h"
#import "Heqingzhao_BottomLoadingView.h"
#import "Heqingzhao_ScrollAdListView.h"

@interface TableControllerDemoViewController ()<Heqingzhao_ScrollAdListViewDelegate>

@property(nonatomic, strong)Heqingzhao_TableViewController* tableController;
@property(nonatomic, assign)NSInteger pageIndex;
@property(nonatomic, assign)NSInteger pageSize;

@end

@implementation TableControllerDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.pageIndex = 0;
    self.pageSize = 20;
    
    UITableView* tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:tableView];
    
    UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 120)];
    headerView.backgroundColor = [UIColor grayColor];
    tableView.tableHeaderView = headerView;
    Heqingzhao_ScrollAdListView* adListView = [[Heqingzhao_ScrollAdListView alloc] initWithFrame:headerView.bounds];
    [headerView addSubview:adListView];
    [self setupAdListView:adListView];
    
    Heqingzhao_TableViewController* tableController = [[Heqingzhao_TableViewController alloc] init];
    self.tableController = tableController;
    
    tableController.tableView = tableView;
    Heqingzhao_TopLoadingView* topLoadingView = [[Heqingzhao_TopLoadingView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 50)];
    
    weak_Self;
    [tableController installTopLoadingView:topLoadingView loadingHandler:^{
        [weakSelf refreshTableController];
    }];
    NSMutableArray* arrayCells = [NSMutableArray array];
    for(NSInteger i = 0; i < self.pageSize; ++ i){
        Heqingzhao_TableViewCellConfig* cellConfig = [[Heqingzhao_TableViewCellConfig alloc] init];
        cellConfig.cellHeight = 80;
        cellConfig.userData = [NSString stringWithFormat:@"cell_%ld", i];
        cellConfig.cellName = @"TableControllerDemoCell";
        [arrayCells addObject:cellConfig];
    }
    self.tableController.arrayCells = arrayCells;
    [self.tableController reloadData];
    
    Heqingzhao_BottomLoadingView* bottomLoadingView = [[Heqingzhao_BottomLoadingView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 50)];
    [tableController installBottomLoadingView:bottomLoadingView loadingHandler:^{
        [weakSelf loadMoreData];
    }];
}

- (void)adListView:(Heqingzhao_ScrollAdListView *)listView setupItemView:(UIView *)itemView itemIndex:(NSInteger)nIndex itemModel:(id)model{
    UIImageView* imageView = [listView viewWithTag:2001];
    if(imageView)
        return ;
    
    imageView = [[UIImageView alloc] initWithFrame:itemView.bounds];
    imageView.image = [model valueForKey:@"image"];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [itemView addSubview:imageView];
}

- (void)adListView:(Heqingzhao_ScrollAdListView *)listView didSelectIndex:(NSInteger)nIndex itemModel:(id)model{
    NSString* website = [model valueForKey:@"website"];
    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:website]]){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:website]];
    }
}

- (void)setupAdListView:(Heqingzhao_ScrollAdListView*)adListView{
    NSArray* arrayWebsits = @[@"https://www.baidu.com/", @"https://music.163.com", @"https://www.bilibili.com/", @"https://www.taobao.com/", @"https://www.jd.com/", @"https://github.com/"];
    NSMutableArray* arrayModels = [NSMutableArray array];
    for(NSInteger i = 0; i < 6; ++ i){
        NSMutableDictionary* dicModel = [NSMutableDictionary dictionary];
        [dicModel setObject:[arrayWebsits objectAtIndex:i] forKey:@"website"];
        UIImage* image = [UIImage imageNamed:[NSString stringWithFormat:@"cat0%ld.jpeg", i+1]];
        if(!image)
            continue;
        [dicModel setObject:image forKey:@"image"];
        [arrayModels addObject:dicModel];
    }
    adListView.arrayItems = arrayModels;
    adListView.delegate = self;
    adListView.scrollBottomEdge = 20;
    adListView.fTimerInterval = 2;
    [adListView reloadAdList];
}

- (void)refreshTableController{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.pageIndex = 0;
        NSMutableArray* arrayCells = [NSMutableArray array];
        for(NSInteger i = 0; i < self.pageSize; ++ i){
            Heqingzhao_TableViewCellConfig* cellConfig = [[Heqingzhao_TableViewCellConfig alloc] init];
            cellConfig.cellHeight = 80;
            cellConfig.userData = [NSString stringWithFormat:@"cell_%ld", i];
            cellConfig.cellName = @"TableControllerDemoCell";
            [arrayCells addObject:cellConfig];
        }
        self.tableController.arrayCells = arrayCells;
        [self.tableController reloadData];
        [self.tableController.topLoadingView endLoading];
    });
}

- (void)loadMoreData{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSMutableArray* arrayCells = [NSMutableArray arrayWithArray:self.tableController.arrayCells];
        self.pageIndex ++;
        for(NSInteger i = self.pageSize*self.pageIndex; i < self.pageSize*self.pageIndex + self.pageSize; ++ i){
            Heqingzhao_TableViewCellConfig* cellConfig = [[Heqingzhao_TableViewCellConfig alloc] init];
            cellConfig.cellHeight = 80;
            cellConfig.userData = [NSString stringWithFormat:@"cell_%ld", i];
            cellConfig.cellName = @"TableControllerDemoCell";
            [arrayCells addObject:cellConfig];
        }
        self.tableController.arrayCells = arrayCells;
        [self.tableController reloadData];
        [self.tableController.bottomLoadingView endLoading];
    });
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
