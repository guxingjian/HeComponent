//
//  Heqingzhao_tableViewBaseCell.h
//  HeComponent
//
//  Created by qingzhao on 2019/2/27.
//  Copyright © 2019年 qingzhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Heqingzhao_TableViewBaseCell;

@protocol Heqingzhao_TableViewBaseCellDelegate <NSObject>

- (void)baseCell:(Heqingzhao_TableViewBaseCell*)cell doActionWithInfo:(id)info;

@end

@interface Heqingzhao_TableViewBaseCell : UITableViewCell

@property(nonatomic, strong)id userData;
@property(nonatomic, weak)id<Heqingzhao_TableViewBaseCellDelegate> delegate;

+(UITableViewCell*) tableViewCellWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
- (void)triggerActionWithInfo:(id)info;

@end
