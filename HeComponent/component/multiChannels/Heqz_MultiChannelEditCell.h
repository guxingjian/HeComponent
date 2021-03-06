//
//  Heqz_MultiChannelEditCell.h
//  HeComponent
//
//  Created by qingzhao on 2019/2/20.
//  Copyright © 2019年 qingzhao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Heqz_MultiChannelConfig.h"

@class Heqz_MultiChannelEditCell;

@protocol Heqz_MultiChannelEditCellProtocol <NSObject>

- (void)willRemoveeditCell:(Heqz_MultiChannelEditCell*)cell;

@end

@interface Heqz_MultiChannelEditCell : UICollectionViewCell

@property(nonatomic,strong)UILabel* labelTitle;
@property(nonatomic,strong)Heqz_MultiChannelConfig* config;
@property(nonatomic,assign)BOOL status; // 0 表示在未选中标签集合中  1 表示在选中标签集合中
@property(nonatomic,assign)BOOL editting; // 0 表示没有在编辑  1 表示在编辑状态中
@property(nonatomic,strong)id<Heqz_MultiChannelEditCellProtocol> delegate;

@end
