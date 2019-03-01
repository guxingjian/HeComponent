//
//  Heqingzhao_tableViewConfig.m
//  HeComponent
//
//  Created by qingzhao on 2019/2/25.
//  Copyright © 2019年 qingzhao. All rights reserved.
//

#import "Heqingzhao_TableViewSectionConfig.h"

@implementation Heqingzhao_TableViewCellConfig

- (CGFloat)cellHeight{
    if([self.cellHeightDelegate respondsToSelector:@selector(cellHeightWithUserData:)]){
        return [self.cellHeightDelegate cellHeightWithUserData:self.userData];
    }
    return _cellHeight;
}

- (NSString *)cellIdentifier{
    if(!_cellIdentifier){
        return self.cellName;
    }
    return _cellIdentifier;
}

@end

@implementation Heqingzhao_TableViewSectionConfig

@end
