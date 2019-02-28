//
//  Heqingzhao_tableViewBaseCell.h
//  HeComponent
//
//  Created by qingzhao on 2019/2/27.
//  Copyright © 2019年 qingzhao. All rights reserved.
//

#import "Heqingzhao_MultiChannelConfig.h"

@protocol Heqingzhao_tableViewBaseCell <NSObject>



@end

@interface Heqingzhao_tableViewBaseCell : Heqingzhao_MultiChannelConfig

@property(nonatomic, strong)id userData;
@property(nonatomic, weak)id delegate;

+(UITableViewCell*) tableViewCellWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;

@end
