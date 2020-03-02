//
//  Heqz_tableViewBaseCell.h
//  HeComponent
//
//  Created by qingzhao on 2019/2/27.
//  Copyright © 2019年 qingzhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Heqz_TableViewBaseCell;

@protocol Heqz_TableViewBaseCellDelegate <NSObject>

- (void)baseCell:(Heqz_TableViewBaseCell*)cell doActionWithInfo:(id)info;

@end

@interface Heqz_TableViewBaseCell : UITableViewCell

@property(nonatomic, strong)id userData;
@property(nonatomic, weak)id<Heqz_TableViewBaseCellDelegate> delegate;

+(UITableViewCell*) tableViewCellWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
- (void)triggerActionWithInfo:(id)info;

@end
