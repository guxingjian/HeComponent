//
//  Heqingzhao_tableViewConfig.m
//  HeComponent
//
//  Created by qingzhao on 2019/2/25.
//  Copyright © 2019年 qingzhao. All rights reserved.
//

#import "Heqingzhao_tableViewSectionConfig.h"

@implementation Heqingzhao_tableViewCellConfig

- (CGFloat)cellHeight{
    if(0 == _cellHeight){
        if([self.userData respondsToSelector:@selector(cellHeight)]){
            _cellHeight = [self.userData cellHeight];
        }
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

@implementation Heqingzhao_tableViewSectionConfig

@end
