//
//  Heqingzhao_MultiChannelViewController.h
//  HeComponent
//
//  Created by qingzhao on 2019/2/14.
//  Copyright © 2019年 qingzhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Heqingzhao_MultiChannelTopBar.h"
#import "Heqingzhao_MultiChannelContentView.h"

@interface Heqingzhao_MultiChannelViewController : UIViewController<Heqingzhao_MultiChannelTopBarDelegate,Heqingzhao_MultiChannelContentViewDelegate,Heqingzhao_MultiChannelConfigProtocol>

@property(nonatomic, strong)Heqingzhao_MultiChannelTopBar* topBar;
@property(nonatomic, strong)Heqingzhao_MultiChannelContentView* contentView;

@end
