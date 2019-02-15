//
//  HeView.m
//  HeComponent
//
//  Created by qingzhao on 2019/2/14.
//  Copyright © 2019年 qingzhao. All rights reserved.
//

#import "UIView+view_frame.h"

@implementation UIView(view_frame)

- (void)setX:(CGFloat)x{
    self.frame = CGRectMake(x, self.y, self.width, self.height);
}

- (CGFloat)x{
    return self.frame.origin.x;
}

- (void)setY:(CGFloat)y{
    self.frame = CGRectMake(self.x, y, self.width, self.height);
}

- (CGFloat)y{
    return self.frame.origin.y;
}

- (void)setWidth:(CGFloat)width{
    self.frame = CGRectMake(self.x, self.y, width, self.height);
}

- (CGFloat)width{
    return self.frame.size.width;
}

- (void)setHeight:(CGFloat)height{
    self.frame = CGRectMake(self.x, self.y, self.width, height);
}

- (CGFloat)height{
    return self.frame.size.height;
}

- (void)setTop:(CGFloat)top{
    self.y = top;
}

- (CGFloat)top{
    return self.y;
}

- (void)setLeft:(CGFloat)left{
    self.x = left;
}

- (CGFloat)left{
    return self.x;
}

- (void)setBottom:(CGFloat)bottom{
    self.top = bottom - self.height;
}

- (CGFloat)bottom{
    return self.top + self.height;
}

- (void)setRight:(CGFloat)right{
    self.left = right - self.width;
}

- (CGFloat)right{
    return self.left + self.width;
}

@end
