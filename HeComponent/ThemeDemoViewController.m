//
//  SkinDemoViewController.m
//  HeComponent
//
//  Created by qingzhao on 2019/7/4.
//  Copyright © 2019年 qingzhao. All rights reserved.
//

#import "ThemeDemoViewController.h"
#import "UIView+ThemeConfig.h"
#import "Heqz_ThemeSkinManager.h"
#import "ThemeDemo2ViewController.h"

@interface ThemeDemoViewController ()

@end

@implementation ThemeDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"切换皮肤demo";
    
    UIButton* btnRight = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    [btnRight addTarget:self action:@selector(nextPage) forControlEvents:UIControlEventTouchUpInside];
    [btnRight setTitle:@"下一页" forState:UIControlStateNormal];
    [btnRight setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc] initWithCustomView:btnRight];
    self.defaultNavibar.topItem.rightBarButtonItem = rightItem;
    
    UILabel* labelTest = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 200, 50)];
    labelTest.text = @"UILabel 皮肤测试";
    labelTest.themeSkin = @"test-label";
    [self.view addSubview:labelTest];
    
    Heqz_ThemeSkinManager* themeMgr = [Heqz_ThemeSkinManager defaultThemeSkinManager];
    if(themeMgr.currentTheme.length == 0){
        [self changeSkin:nil];
    }
}

- (void)nextPage{
    ThemeDemo2ViewController* vc = [[ThemeDemo2ViewController alloc] initWithNibName:@"ThemeDemo2ViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)changeSkin:(UIButton*)sender{
    Heqz_ThemeSkinManager* themeMgr = [Heqz_ThemeSkinManager defaultThemeSkinManager];
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
