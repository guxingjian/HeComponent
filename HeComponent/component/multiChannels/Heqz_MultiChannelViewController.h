//
//  Heqz_MultiChannelViewController.h
//  HeComponent
//
//  Created by qingzhao on 2019/2/14.
//  Copyright © 2019年 qingzhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Heqz_MultiChannelTopBar.h"
#import "Heqz_MultiChannelContentView.h"

@interface Heqz_MultiChannelViewController : UIViewController<Heqz_MultiChannelTopBarDelegate,Heqz_MultiChannelContentViewDelegate,Heqz_MultiChannelConfigProtocol>

@property(nonatomic, strong)Heqz_MultiChannelTopBar* topBar;
@property(nonatomic, strong)Heqz_MultiChannelContentView* contentView;

@end
