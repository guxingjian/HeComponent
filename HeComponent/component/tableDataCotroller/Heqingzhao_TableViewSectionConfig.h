//
//  Heqingzhao_tableViewConfig.h
//  HeComponent
//
//  Created by qingzhao on 2019/2/25.
//  Copyright © 2019年 qingzhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol Heqingzhao_TableViewCellUserDataProtocol <NSObject>

- (CGFloat)cellHeightWithUserData:(id)userData;

@end

@interface Heqingzhao_TableViewCellConfig : NSObject

@property(nonatomic, strong)id userData;
@property(nonatomic, assign)CGFloat cellHeight;
@property(nonatomic, weak)id<Heqingzhao_TableViewCellUserDataProtocol> cellHeightDelegate;
@property(nonatomic, strong)NSString* cellName;
@property(nonatomic, strong)NSString* cellIdentifier;
@property(nonatomic, strong)UITableViewCell* cell;

@end

@interface Heqingzhao_TableViewSectionConfig : NSObject

@property(nonatomic, strong)IBOutlet UIView* headerView;
@property(nonatomic, strong)IBOutlet UIView* footerView;
@property(nonatomic, strong)IBOutletCollection(Heqingzhao_TableViewCellConfig)NSArray* arrayCells;

@end
