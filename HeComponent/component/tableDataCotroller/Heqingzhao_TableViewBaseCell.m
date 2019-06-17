//
//  Heqingzhao_tableViewBaseCell.m
//  HeComponent
//
//  Created by qingzhao on 2019/2/27.
//  Copyright © 2019年 qingzhao. All rights reserved.
//

#import "Heqingzhao_TableViewBaseCell.h"

@implementation Heqingzhao_TableViewBaseCell

+(UITableViewCell*) tableViewCellWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    NSString* strPath = [nibBundleOrNil pathForResource:nibNameOrNil ofType:@"xib"];
    if(![[NSFileManager defaultManager] fileExistsAtPath:strPath])
        return nil;
    
    UIViewController * viewController = [[UIViewController alloc] initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    UITableViewCell * view = (UITableViewCell*)[viewController view];
    if([view isKindOfClass:[UITableViewCell class]]){
        return view;
    }
    return nil;
}

- (void)triggerActionWithInfo:(id)info{
    if([self.delegate respondsToSelector:@selector(baseCell:doActionWithInfo:)]){
        [self.delegate baseCell:self doActionWithInfo:info];
    }
}

@end
