//
//  SFSinglePixelHorizontalView.h
//  SinaFinance
//
//  Created by qingzhao on 2018/3/23.
//  Copyright © 2018年 sina.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Heqz_SinglePixelView : UIView

@property(nonatomic, assign)CGFloat onePixelInPoint;
@property(nonatomic, strong)CALayer* lineLayer;
@property(nonatomic, strong)NSString* strColor;

@end

@interface Heqz_SinglePixelHorizontalView : Heqz_SinglePixelView

@property(nonatomic, assign)BOOL bTop;

@end

@interface Heqz_SinglePixelVerticalView : Heqz_SinglePixelView

@property(nonatomic, assign)BOOL bLeft;

@end

