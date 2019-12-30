//
//  ThemeDemo2ViewController.m
//  HeComponent
//
//  Created by qingzhao on 2019/7/8.
//  Copyright © 2019年 qingzhao. All rights reserved.
//

#import "ThemeDemo2ViewController.h"
#import "Heqingzhao_ThemeSkinManager.h"
#import "UIView+themeConfig.h"

@interface ThemeDemo2ViewController ()

@end

@implementation ThemeDemo2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIButton* btnRight = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    [btnRight addTarget:self action:@selector(changeSkin:) forControlEvents:UIControlEventTouchUpInside];
    [btnRight setTitle:@"切换皮肤" forState:UIControlStateNormal];
    [btnRight setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc] initWithCustomView:btnRight];
    self.defaultNavibar.topItem.rightBarButtonItem = rightItem;
    
    self.title = @"切换皮肤demo";
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSMutableArray* arrayCells = [NSMutableArray array];
        for(NSInteger i = 0; i < 30; ++ i){
            Heqingzhao_TableViewCellConfig* cellConfig = [[Heqingzhao_TableViewCellConfig alloc] init];
            cellConfig.cellHeight = 80;
            cellConfig.userData = [NSString stringWithFormat:@"cell_%ld", i];
            cellConfig.cellName = @"ThemeTableViewCell";
            [arrayCells addObject:cellConfig];
        }
        self.tableController.arrayCells = arrayCells;
        [self.tableController reloadData];
    });
    
    self.safeAreaTableView.themeSkin = self.view.themeSkin;
}

- (IBAction)changeSkin:(UIButton*)sender{
    //    NSLog(@"sender: %@", sender);
    Heqingzhao_ThemeSkinManager* themeMgr = [Heqingzhao_ThemeSkinManager defaultThemeSkinManager];
    if([themeMgr.currentTheme isEqualToString:@"skin_1.plist"]){
        [themeMgr setCurrentTheme:@"skin_2.plist"];
    }else{
        [themeMgr setCurrentTheme:@"skin_1.plist"];
    }
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
