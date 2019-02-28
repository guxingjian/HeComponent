//
//  Heqingzhao_tableViewConfig.h
//  HeComponent
//
//  Created by qingzhao on 2019/2/25.
//  Copyright © 2019年 qingzhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol Heqingzhao_tableViewCellUserDataProtocol <NSObject>

- (CGFloat)cellHeight;

@end

@interface Heqingzhao_tableViewCellConfig : NSObject

@property(nonatomic, strong)id<Heqingzhao_tableViewCellUserDataProtocol> userData;
@property(nonatomic, assign)CGFloat cellHeight;
@property(nonatomic, strong)NSString* cellName;
@property(nonatomic, strong)NSString* cellIdentifier;
@property(nonatomic, strong)UITableViewCell* cell;

@end

@interface Heqingzhao_tableViewSectionConfig : NSObject

@property(nonatomic, strong)IBOutlet UIView* headerView;
@property(nonatomic, strong)IBOutlet UIView* footerView;
@property(nonatomic, strong)IBOutletCollection(Heqingzhao_tableViewCellConfig)NSArray* arrayCells;

@end
