//
//  Heqz_ChartAxisMarkLabel.m
//  SinaFinance
//
//  Created by qingzhao on 2018/5/1.
//  Copyright © 2018年 qingzhao. All rights reserved.
//

#import "Heqz_ChartAxisMarkLabel.h"

@interface Heqz_ChartAxisMarkLabel()

@property(nonatomic, assign)CGRect textRect;

@end

@implementation Heqz_ChartAxisMarkLabel

+ (instancetype)markLabelWithText:(NSAttributedString *)text
{
    Heqz_ChartAxisMarkLabel* label = [[self alloc] init];
    label.text = text;
    return label;
}

- (void)setText:(NSAttributedString *)text
{
    _text = text;
    
    CGFloat fW = MAXFLOAT;
    if(self.maxWidth > 0)
    {
        fW = self.maxWidth;
    }
    
    CGRect rtStr = [text boundingRectWithSize:CGSizeMake(fW, 1000) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    self.textRect = rtStr;
}

- (void)setMaxWidth:(CGFloat)maxWidth
{
    _maxWidth = maxWidth;
    if(self.text.length > 0)
    {
        CGRect rtStr = [self.text boundingRectWithSize:CGSizeMake(maxWidth, 1000) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
        self.textRect = rtStr;
    }
}

@end
