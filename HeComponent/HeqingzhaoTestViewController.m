//
//  HeqingzhaoTestViewController.m
//  HeComponent
//
//  Created by qingzhao on 2019/6/10.
//  Copyright © 2019年 qingzhao. All rights reserved.
//

#import "HeqingzhaoTestViewController.h"
#import "Heqingzhao_RubishManager.h"

@interface HeqingzhaoTestViewController ()

@end

@implementation HeqingzhaoTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [[Heqingzhao_RubishManager sharedManager] analyzeUnUsedResource];
}

@end
