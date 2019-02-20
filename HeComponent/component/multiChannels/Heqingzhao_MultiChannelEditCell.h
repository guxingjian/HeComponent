//
//  Heqingzhao_MultiChannelEditCell.h
//  HeComponent
//
//  Created by qingzhao on 2019/2/20.
//  Copyright © 2019年 qingzhao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Heqingzhao_MultiChannelConfig.h"

@interface Heqingzhao_MultiChannelEditCell : UICollectionViewCell

@property(nonatomic,strong)NSIndexPath* indexPath;
@property(nonatomic,strong)UILabel* labelTitle;

- (void)setConfig:(Heqingzhao_MultiChannelConfig*)config;
- (void)beginMoving;
- (void)endMoving;

@end
