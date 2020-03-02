//
//  SFTabbarAdjustPosition.m
//  SinaFinance
//
//  Created by work_lenovo on 2018/1/9.
//  Copyright © 2018年 sina.com. All rights reserved.
//

#import "Heqz_TabbarAdjustPosition.h"
#import "UIView+view_frame.h"

@implementation Heqz_TabbarAdjustPosition

+ (UIView*)beforeView:(UIView*)view
{
    NSArray* subViews = view.superview.subviews;
    NSUInteger nIndex = [subViews indexOfObject:view];
    if(nIndex == NSNotFound)
        return nil;
    
    if(nIndex > 0)
        return [subViews objectAtIndex:nIndex - 1];
    return nil;
}

+ (UIView*)afterView:(UIView*)view
{
    NSArray* subViews = view.superview.subviews;
    NSUInteger nIndex = [subViews indexOfObject:view];
    if(nIndex == NSNotFound)
        return nil;
    
    if(nIndex < subViews.count - 1)
        return [subViews objectAtIndex:nIndex + 1];
    return nil;
}

+ (void)showHiddenTabWith:(id)selectTab splitDis:(CGFloat)tabDis containerScrollView:(UIView*)scroll
{
    [Heqz_TabbarAdjustPosition showHiddenTabWith:selectTab splitDis:tabDis containerScrollView:scroll animation:YES];
}

+ (void)showHiddenTabWith:(id)selectTab splitDis:(CGFloat)dis containerScrollView:(UIView*)scrollView animation:(BOOL)animation
{
    if(![selectTab isKindOfClass:[UIButton class]])
    {
        NSLog(@"not a button");
        return ;
    }
    if(![scrollView isKindOfClass:[UIScrollView class]])
    {
        NSLog(@"not a scrollview");
        return ;
    }
    
    UIScrollView* scroll = (UIScrollView*)scrollView;
    if(scroll.contentSize.width <= scroll.width)
        return ;
    
    UIButton* tabBtn = (UIButton*)selectTab;
    
    if((![scroll hitTest:CGPointMake(tabBtn.x + 1, tabBtn.y + 1) withEvent:nil] && ![scroll hitTest:CGPointMake(tabBtn.x + tabBtn.width - 1, tabBtn.y + tabBtn.height - 1) withEvent:nil]) &&
       ![scroll.subviews containsObject:tabBtn])
    {
        NSLog(@"selectTab is not subview");
        return ;
    }
    
    UIWindow* wnd = [UIApplication sharedApplication].delegate.window;
    CGPoint ptBtn = [wnd convertPoint:CGPointZero fromView:tabBtn];
    
    CGPoint ptStart = [wnd convertPoint:CGPointZero fromView:scroll];
    if(ptBtn.x - ptStart.x > 20 + dis)
    {
        CGFloat basePosX = [wnd convertPoint:CGPointMake(scroll.contentOffset.x, 0) fromView:scrollView].x;
        UIView* beforeTab = [self beforeView:tabBtn];
        if(beforeTab && (ptBtn.x < basePosX + beforeTab.width + dis && ptStart.x < basePosX))
        {
            CGFloat fOffset = ptBtn.x - dis - beforeTab.width;
            if(fOffset < ptStart.x)
            {
                fOffset = ptStart.x;
            }
            [self setScrollView:scroll offsent:(scroll.contentOffset.x - (basePosX - fOffset)) animation:animation];
        }
    }
    else
    {
        [self setScrollView:scroll offsent:0 animation:animation];
    }
    
    CGPoint ptEnd = [wnd convertPoint:CGPointMake(scroll.contentSize.width, 0) fromView:scroll];
    if(ptEnd.x - ptBtn.x > tabBtn.width + dis + 20)
    {
        CGFloat basePosX = [wnd convertPoint:CGPointMake(scroll.contentOffset.x + scroll.width, 0) fromView:scroll].x;
        UIView* afterView = [self afterView:tabBtn];
        if(afterView && (basePosX - ptBtn.x < tabBtn.width + afterView.width + dis) && ptEnd.x > basePosX)
        {
            CGFloat fOffset = ptBtn.x + tabBtn.width + afterView.width + dis;
            if(fOffset > ptEnd.x)
            {
                fOffset = ptEnd.x;
            }
            [self setScrollView:scroll offsent:scroll.contentOffset.x + (fOffset - basePosX) animation:animation];
        }
    }
    else
    {
            [self setScrollView:scroll offsent:scroll.contentSize.width - scroll.width animation:animation];
    }
}

+ (void)setScrollView:(UIScrollView*)scroll offsent:(CGFloat)offsetX animation:(BOOL)animation
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (animation) {
            [UIView animateWithDuration:0.25 animations:^{
                [scroll setContentOffset:CGPointMake(offsetX, scroll.contentOffset.y) animated:YES];
            }];
        }else{
            [scroll setContentOffset:CGPointMake(offsetX, scroll.contentOffset.y) animated:NO];
        }
    });
}

@end
