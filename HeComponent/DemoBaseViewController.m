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
    self.title = @"baseVC Demo";
    
    NSMutableArray* arrayCells = [NSMutableArray array];
    for(NSInteger i = 0; i < 30; ++ i){
        Heqz_TableViewCellConfig* cellConfig = [[Heqz_TableViewCellConfig alloc] init];
        cellConfig.cellHeight = 80;
        cellConfig.userData = [NSString stringWithFormat:@"cell_%ld", i];
        cellConfig.cellName = @"TableControllerDemoCell";
        [arrayCells addObject:cellConfig];
    }
    self.tableController.arrayCells = arrayCells;
    [self.tableController reloadData];
}

- (void)tableController:(Heqz_TableViewController *)controller tableCell:(Heqz_TableViewBaseCell *)cell doActionWithInfo:(id)info{
    NSString* userData = cell.userData;
    NSDictionary* dic = (NSDictionary*)info;
    NSString* userInfo = [dic objectForKey:@"userInfo"];
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:userInfo message:userData preferredStyle:UIAlertControllerStyleAlert];
    __weak UIAlertController* weakAlert = alert;
    UIAlertAction* action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakAlert dismissViewControllerAnimated:YES completion:^{
        }];
    }];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:^{
    }];
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
