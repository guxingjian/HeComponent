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

@interface TableControllerDemoViewController ()

@property(nonatomic, strong)Heqingzhao_TableViewController* tableController;

@end

@implementation TableControllerDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UITableView* tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:tableView];
    
    Heqingzhao_TableViewController* tableController = [[Heqingzhao_TableViewController alloc] init];
    self.tableController = tableController;
    
    tableController.tableView = tableView;
    Heqingzhao_TopLoadingView* topLoadingView = [[Heqingzhao_TopLoadingView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 50)];
    
    weak_Self;
    [tableController installTopLoadingView:topLoadingView loadingHandler:^{
        [weakSelf refreshTableController];
    }];
//    [tableController.topLoadingView startLoading];
    
    NSMutableArray* arrayCells = [NSMutableArray array];
    for(NSInteger i = 0; i < 20; ++ i){
        Heqingzhao_TableViewCellConfig* cellConfig = [[Heqingzhao_TableViewCellConfig alloc] init];
        cellConfig.cellHeight = 80;
        cellConfig.userData = [NSString stringWithFormat:@"cell_%ld", i];
        cellConfig.cellName = @"TableControllerDemoCell";
        [arrayCells addObject:cellConfig];
    }
    self.tableController.arrayCells = arrayCells;
    [self.tableController reloadData];
}

- (void)refreshTableController{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSMutableArray* arrayCells = [NSMutableArray array];
        for(NSInteger i = 0; i < 20; ++ i){
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
