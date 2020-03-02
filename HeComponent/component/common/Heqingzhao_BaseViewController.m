//
//  Heqingzhao_BaseViewController.m
//  HeComponent
//
//  Created by qingzhao on 2019/6/6.
//  Copyright © 2019年 qingzhao. All rights reserved.
//

#import "Heqingzhao_BaseViewController.h"
#import "Heqingzhao_AppContext.h"
#import "Heqingzhao_ImageLoader.h"
#import "UIView+view_frame.h"
#import "Heqingzhao_SinglePixelView.h"
#import "UIColor+extension_qingzhao.h"
#import "Heqingzhao_ThemeSkinManager.h"
#import "UIView+ThemeConfig.h"

@interface Heqingzhao_BaseViewController ()

@property(nonatomic, strong)NSString* currentThemeConfigFile;

@end

@implementation Heqingzhao_BaseViewController

- (void)awakeFromNib{
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if(self.navigationController.navigationBar.hidden && !self.disableDefaultNavibar){
        [self createDefaultNavigationBar];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeSkinChanged:) name:Heqingzhao_ThemeSkinChanged object:nil];
}

- (void)createDefaultNavigationBar{
    UIButton* btnBack = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 60)];
    [btnBack setImage:[UIImage imageNamed:@"navi_back"] forState:UIControlStateNormal];
    [btnBack addTarget:self action:@selector(naviBack:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* backItem = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
    
    UINavigationBar* naviBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, Heqingzhao_ScreenWidth, Heqingzhao_ScreenSafeAreaInsets.top)];
    naviBar.barTintColor = [UIColor colorWithHexString:@"#EAEAEA"];
    naviBar.backgroundColor = [UIColor colorWithHexString:@"#EAEAEA"];
    UINavigationItem* naviItem = [[UINavigationItem alloc] initWithTitle:self.title];
    naviItem.leftBarButtonItem = backItem;
    naviBar.items = @[naviItem];
    [self.view addSubview:naviBar];
    self.defaultNavibar = naviBar;
    
    Heqingzhao_SinglePixelHorizontalView* horiLine = [[Heqingzhao_SinglePixelHorizontalView alloc] initWithFrame:CGRectMake(0, naviBar.height - 1, naviBar.width, 1)];
    [naviBar addSubview:horiLine];
}

- (void)naviBack:(UIButton*)btn{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UITableView *)safeAreaTableView{
    if(!_safeAreaTableView){
        _safeAreaTableView = [[UITableView alloc] initWithFrame:Heqingzhao_ScreenSafeAreaRect style:UITableViewStylePlain];
        _safeAreaTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_safeAreaTableView];
    }
    return _safeAreaTableView;
}

- (Heqingzhao_TableViewController *)tableController{
    if(!_tableController){
        _tableController = [[Heqingzhao_TableViewController alloc] init];
        _tableController.delegate = self;
        _tableController.tableView = self.safeAreaTableView;
    }
    return _tableController;
}

- (void)setTitle:(NSString *)title{
    if(self.defaultNavibar){
        self.defaultNavibar.topItem.title = title;
        return ;
    }
    [super setTitle:title];
}

- (void)setDisableDefaultNavibar:(BOOL)disableDefaultNavibar{
    _disableDefaultNavibar = disableDefaultNavibar;
    if(self.defaultNavibar){
        self.defaultNavibar.hidden = disableDefaultNavibar;
    }
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator{
    UIEdgeInsets insets = Heqingzhao_ScreenSafeAreaInsets;
    if(self.defaultNavibar){
        self.defaultNavibar.frame = CGRectMake(0, 0, size.width, insets.top);
    }
    if(_safeAreaTableView){
        _safeAreaTableView.frame = CGRectMake(insets.left, insets.top, size.width - insets.left - insets.right, size.height - insets.top - insets.bottom);
        [_safeAreaTableView reloadData];
    }
}

- (void)tableController:(Heqingzhao_TableViewController *)controller tableCell:(Heqingzhao_TableViewBaseCell *)cell doActionWithInfo:(id)info{
    
}

- (void)triggerTopLoadingWithTableController:(Heqingzhao_TableViewController *)tableController{
    
}

- (void)triggerBottomLoadingWithTableController:(Heqingzhao_TableViewController *)tableController{
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self viewWillAppearHandleTheme];
}

- (void)viewWillAppearHandleTheme{
    Heqingzhao_ThemeSkinManager* mgr = [Heqingzhao_ThemeSkinManager defaultThemeSkinManager];
    if(![mgr.currentTheme isEqualToString:self.currentThemeConfigFile]){ // 避免重复设置theme
        [mgr decorateViewAndSubView:self.view ignoreOriginalSetting:NO];
        self.currentThemeConfigFile = mgr.currentTheme;
    };
}

- (void)themeSkinChanged:(NSNotification*)notification{
    if(!self.view.window){
        return ;
    }
    Heqingzhao_ThemeSkinManager* mgr = [Heqingzhao_ThemeSkinManager defaultThemeSkinManager];
    [mgr decorateViewAndSubView:self.view ignoreOriginalSetting:NO];
    self.currentThemeConfigFile = mgr.currentTheme;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Heqingzhao_ThemeSkinChanged object:nil];
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
