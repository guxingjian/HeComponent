//
//  Heqingzhao_tableViewBaseCell.m
//  HeComponent
//
//  Created by qingzhao on 2019/2/27.
//  Copyright © 2019年 qingzhao. All rights reserved.
//

#import "Heqingzhao_tableViewBaseCell.h"

@implementation Heqingzhao_tableViewBaseCell

+(UITableViewCell*) tableViewCellWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    UIViewController * viewController = [[UIViewController alloc] initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    UITableViewCell * view = (UITableViewCell*)[viewController view];
    if([view isKindOfClass:[UITableViewCell class]]){
        return view;
    }
    return nil;
}

@end
