//
//  Heqingzhao_loadingView.h
//  HeComponent
//
//  Created by qingzhao on 2019/2/28.
//  Copyright © 2019年 qingzhao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSInteger, Heqingzhao_loadingViewState){
    Heqingzhao_loadingViewState_Normal,
    Heqingzhao_loadingViewState_Loading
};

@interface Heqingzhao_loadingView : UIView

@property(nonatomic, readonly)Heqingzhao_loadingViewState state;

- (void)startLoading;
- (void)endLoading;

@end
