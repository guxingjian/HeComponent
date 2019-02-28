//
//  Heqingzhao_tableViewBaseCell.h
//  HeComponent
//
//  Created by qingzhao on 2019/2/27.
//  Copyright © 2019年 qingzhao. All rights reserved.
//

#import "Heqingzhao_MultiChannelConfig.h"

@class Heqingzhao_tableViewBaseCell;

@protocol Heqingzhao_tableViewBaseCellDelegate <NSObject>

- (void)baseCell:(Heqingzhao_tableViewBaseCell*)cell doActionWithInfo:(id)info;

@end

@interface Heqingzhao_tableViewBaseCell : Heqingzhao_MultiChannelConfig

@property(nonatomic, strong)id userData;
@property(nonatomic, weak)id<Heqingzhao_tableViewBaseCellDelegate> delegate;

+(UITableViewCell*) tableViewCellWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;

@end
