//
//  HeqingzhaoTestViewController.m
//  HeComponent
//
//  Created by qingzhao on 2019/6/10.
//  Copyright © 2019年 qingzhao. All rights reserved.
//

#import "DemoBaseViewController.h"

@interface DemoBaseViewController ()

@end

@implementation DemoBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.defaultNavibar.backgroundColor = [UIColor blueColor];
    self.defaultNavibar.barTintColor = [UIColor blueColor];
    
    NSMutableArray* arrayCells = [NSMutableArray array];
    for(NSInteger i = 0; i < 30; ++ i){
        Heqingzhao_TableViewCellConfig* cellConfig = [[Heqingzhao_TableViewCellConfig alloc] init];
        cellConfig.cellHeight = 80;
        cellConfig.userData = [NSString stringWithFormat:@"cell_%ld", i];
        cellConfig.cellName = @"TableControllerDemoCell";
        [arrayCells addObject:cellConfig];
    }
    self.tableController.arrayCells = arrayCells;
    [self.tableController reloadData];
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
