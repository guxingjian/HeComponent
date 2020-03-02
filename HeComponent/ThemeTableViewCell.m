//
//  ThemeTableViewCell.m
//  HeComponent
//
//  Created by qingzhao on 2019/7/8.
//  Copyright © 2019年 qingzhao. All rights reserved.
//

#import "ThemeTableViewCell.h"
#import "UIView+ThemeConfig.h"
#import "Heqz_AppContext.h"

@interface ThemeTableViewCell()

@property(nonatomic, strong)UILabel* labelText;

@end

@implementation ThemeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.contentView.themeSkin = @"cell-back";
        UIView* lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.contentView.frame.size.height - 1, self.frame.size.width, 1)];
        lineView.themeSkin = @"cell-line";
        lineView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        [self.contentView addSubview:lineView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UILabel *)labelText{
    if(!_labelText){
        _labelText = [[UILabel alloc] initWithFrame:self.bounds];
        _labelText.textAlignment = NSTextAlignmentCenter;
        _labelText.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _labelText.font = [UIFont systemFontOfSize:15];
        _labelText.textColor = [UIColor blackColor];
        _labelText.themeSkin = @"cell-label";
        [self.contentView addSubview:_labelText];
    }
    return _labelText;
}

- (void)setUserData:(id)userData{
    [super setUserData:userData];
    NSString* text = (NSString*)userData;
    if(text.length == 0)
        return ;
    self.labelText.text = text;
}

//- (void)layoutSubviews{
//    [super layoutSubviews];
//    self.labelText.frame = CGRectMake(0, 0, Heqz_ScreenWidth, self.bounds.size.height);
//}

@end
