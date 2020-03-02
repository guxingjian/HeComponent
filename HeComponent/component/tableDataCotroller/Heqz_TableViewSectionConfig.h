//
//  Heqz_tableViewConfig.h
//  HeComponent
//
//  Created by qingzhao on 2019/2/25.
//  Copyright © 2019年 qingzhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol Heqz_TableViewCellUserDataProtocol <NSObject>

- (CGFloat)cellHeightWithUserData:(id)userData;

@end

@interface Heqz_TableViewCellConfig : NSObject

@property(nonatomic, strong)id userData;
@property(nonatomic, assign)CGFloat cellHeight;
@property(nonatomic, weak)id<Heqz_TableViewCellUserDataProtocol> cellHeightDelegate;
@property(nonatomic, strong)NSString* cellName;
@property(nonatomic, strong)NSString* cellIdentifier;
@property(nonatomic, strong)UITableViewCell* cell;

@end

@interface Heqz_TableViewSectionConfig : NSObject

@property(nonatomic, strong)IBOutlet UIView* headerView;
@property(nonatomic, strong)IBOutlet UIView* footerView;
@property(nonatomic, strong)IBOutletCollection(Heqz_TableViewCellConfig)NSArray* arrayCells;

@end
