//
//  TableControllerDemoCell.m
//  HeComponent
//
//  Created by qingzhao on 2019/3/1.
//  Copyright © 2019年 qingzhao. All rights reserved.
//

#import "TableControllerDemoCell.h"
#import "UIView+view_frame.h"

@interface TableControllerDemoCell()

@property(nonatomic, strong)UILabel* labelText;

@end

@implementation TableControllerDemoCell

- (UILabel *)labelText{
    if(!_labelText){
        _labelText = [[UILabel alloc] initWithFrame:self.bounds];
        _labelText.textAlignment = NSTextAlignmentCenter;
        _labelText.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _labelText.font = [UIFont systemFontOfSize:15];
        _labelText.textColor = [UIColor blackColor];
        [self.contentView addSubview:_labelText];
    }
    return _labelText;
}

- (void)setUserData:(id)userData{
    NSString* text = (NSString*)userData;
    self.labelText.text = text;
}

@end
