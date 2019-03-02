//
//  Heqingzhao_tableController.m
//  HeComponent
//
//  Created by qingzhao on 2019/2/25.
//  Copyright © 2019年 qingzhao. All rights reserved.
//

#import "Heqingzhao_TableViewController.h"
#import "UIView+view_frame.h"
#import "Heqingzhao_AppContext.h"

#define Min_Equal_dis 0.0001f

@interface Heqingzhao_TableViewController()

@property(nonatomic,assign)CGFloat fEdgeTop;
@property(nonatomic,assign)CGFloat fEdgeBottom;

@property(nonatomic,copy)void(^topLoadingHandler)(void);
@property(nonatomic,copy)void(^bottomLoadingHandler)(void);

@end

@implementation Heqingzhao_TableViewController

- (void)dealloc{
    self.topLoadingView = nil;
    self.bottomLoadingView = nil;
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
    self.tableView = nil;
}

- (instancetype)init{
    if(self = [super init]){
        self.fEdgeTop = MAXFLOAT;
        self.fEdgeBottom = MAXFLOAT;
    }
    return self;
}

- (void)setTableView:(UITableView *)tableView{
    if(_tableView){
        [_tableView removeObserver:self forKeyPath:@"contentSize"];
        _tableView = nil;
    }
    _tableView = tableView;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.estimatedRowHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    [_tableView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(self.arraySections.count > 0){
        return self.arraySections.count;
    }else if(self.arrayCells.count > 0){
        return 1;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(self.arraySections.count > 0 && section < self.arraySections.count){
        Heqingzhao_TableViewSectionConfig* sectionConfig = [self.arraySections objectAtIndex:section];
        return sectionConfig.arrayCells.count;
    }else if(self.arrayCells.count > 0){
        return self.arrayCells.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(self.arraySections.count > 0  && section < self.arraySections.count){
        Heqingzhao_TableViewSectionConfig* sectionConfig = [self.arraySections objectAtIndex:section];
        return sectionConfig.headerView.height;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(self.arraySections.count > 0 && section < self.arraySections.count){
        Heqingzhao_TableViewSectionConfig* sectionConfig = [self.arraySections objectAtIndex:section];
        return sectionConfig.headerView;
    }
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(self.arraySections.count > 0 && section < self.arraySections.count){
        Heqingzhao_TableViewSectionConfig* sectionConfig = [self.arraySections objectAtIndex:section];
        return sectionConfig.footerView.height;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if(self.arraySections.count > 0 && section < self.arraySections.count){
        Heqingzhao_TableViewSectionConfig* sectionConfig = [self.arraySections objectAtIndex:section];
        return sectionConfig.footerView;
    }
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.arraySections.count > 0 && indexPath.section < self.arraySections.count){
        Heqingzhao_TableViewSectionConfig* sectionConfig = [self.arraySections objectAtIndex:indexPath.section];
        if(indexPath.row < sectionConfig.arrayCells.count){
            Heqingzhao_TableViewCellConfig* cellConfig = [sectionConfig.arrayCells objectAtIndex:indexPath.row];
            return cellConfig.cellHeight;
        }
    }else if(self.arrayCells.count > 0){
        if(indexPath.row < self.arrayCells.count){
            Heqingzhao_TableViewCellConfig* cellConfig = [self.arrayCells objectAtIndex:indexPath.row];
            return cellConfig.cellHeight;
        }
    }
    return 0;
}

- (void)baseCell:(Heqingzhao_TableViewBaseCell *)cell doActionWithInfo:(id)info{
    
}

- (UITableViewCell*)cellWithCellConfig:(Heqingzhao_TableViewCellConfig*)cellConfig tableView:(UITableView*)tableView{
    if(cellConfig.cell)
        return cellConfig.cell;
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellConfig.cellIdentifier];
    if(!cell){
        cell = [Heqingzhao_TableViewBaseCell tableViewCellWithNibName:cellConfig.cellName bundle:[NSBundle bundleForClass:[self class]]];
    }
    if(!cell){
        Class cellClass = NSClassFromString(cellConfig.cellName);
        cell = [cellClass alloc];
        if([cell isKindOfClass:[UITableViewCell class]]){
            cell = [cell initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellConfig.cellIdentifier];
        }
    }
    if([cell isKindOfClass:[Heqingzhao_TableViewBaseCell class]]){
        Heqingzhao_TableViewBaseCell* baseCell = (Heqingzhao_TableViewBaseCell*)cell;
        [baseCell setUserData:cellConfig.userData];
        [baseCell setDelegate:self];
    }
    
    if(!cell){
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if(!cell){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
    }
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = nil;
    
    if(self.arraySections.count > 0 && indexPath.section < self.arraySections.count){
        Heqingzhao_TableViewSectionConfig* sectionConfig = [self.arraySections objectAtIndex:indexPath.section];
        if(indexPath.row < sectionConfig.arrayCells.count){
            Heqingzhao_TableViewCellConfig* cellConfig = [sectionConfig.arrayCells objectAtIndex:indexPath.row];
            cell = [self cellWithCellConfig:cellConfig tableView:tableView];
        }
    }else if(self.arrayCells.count > 0){
        if(indexPath.row < self.arrayCells.count){
            Heqingzhao_TableViewCellConfig* cellConfig = [self.arrayCells objectAtIndex:indexPath.row];
            cell = [self cellWithCellConfig:cellConfig tableView:tableView];
        }
    }
    
    return cell;
}

- (void)reloadData{
    [self.tableView reloadData];
}

- (void)setTopLoadingView:(Heqingzhao_LoadingView *)topLoadingView{
    if(self.topLoadingView){
        [self.topLoadingView endLoading];
        [self.topLoadingView removeFromSuperview];
        [self.topLoadingView removeObserver:self forKeyPath:@"loadingState"];
    }
    _topLoadingView = topLoadingView;
    [self.topLoadingView addObserver:self forKeyPath:@"loadingState" options:NSKeyValueObservingOptionNew context:nil];
    CGFloat fPosY = _tableView.contentInset.top - topLoadingView.height;
    if(@available(iOS 11.0, *)){
        fPosY -= _tableView.adjustedContentInset.top;
    }
    topLoadingView.frame = CGRectMake(0, fPosY, self.tableView.width, topLoadingView.height);
    [self.tableView addSubview:topLoadingView];
}

- (void)setBottomLoadingView:(Heqingzhao_LoadingView *)bottomLoadingView{
    if(self.bottomLoadingView){
        [self.bottomLoadingView endLoading];
        [self.bottomLoadingView removeFromSuperview];
        [self.bottomLoadingView removeObserver:self forKeyPath:@"loadingState"];
    }
    _bottomLoadingView = bottomLoadingView;
    [self.bottomLoadingView addObserver:self forKeyPath:@"loadingState" options:NSKeyValueObservingOptionNew context:nil];
    CGFloat fVisibleHeight = _tableView.height + _tableView.contentInset.bottom + _tableView.contentInset.top;
    CGFloat fAdjust = 0;
    if(@available(iOS 11.0,*)){
        fVisibleHeight += _tableView.adjustedContentInset.top + _tableView.adjustedContentInset.bottom;
        fAdjust = _tableView.adjustedContentInset.bottom;
    }
    
    if(fVisibleHeight < _tableView.height){
        bottomLoadingView.hidden = YES;
    }else{
        bottomLoadingView.frame = CGRectMake(0, _tableView.contentInset.bottom + _tableView.contentSize.height + fAdjust, _tableView.width, bottomLoadingView.height);
    }
    [_tableView addSubview:bottomLoadingView];
}

- (void)installTopLoadingView:(Heqingzhao_LoadingView *)loadingView loadingHandler:(void (^)(void))handler{
    self.topLoadingView = loadingView;
    self.topLoadingHandler = handler;
}

- (void)installBottomLoadingView:(Heqingzhao_LoadingView *)loadingView loadingHandler:(void (^)(void))handler{
    self.bottomLoadingView = loadingView;
    self.bottomLoadingHandler = handler;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if(_topLoadingView && !_topLoadingView.hidden && _topLoadingView.height > 0){
        [self processTopLoadingWithScrollView:scrollView];
    }
    if(_bottomLoadingView && !_bottomLoadingView.hidden && _bottomLoadingView.height > 0){
        [self processBottomLoadingWithScrollView:scrollView];
    }
}

- (void)processTopLoadingWithScrollView:(UIScrollView*)scrollView{
    CGFloat fOffsetY = scrollView.contentOffset.y;
    UIEdgeInsets insets = self.tableView.contentInset;
    if(Heqingzhao_LoadingViewState_PrePareLoading == _topLoadingView.loadingState){
        [_topLoadingView startLoading];
    }else if(Heqingzhao_LoadingViewState_Loading == _topLoadingView.loadingState){
        CGFloat fAdjust = 0;
        if(@available(iOS 11.0, *)){
            fAdjust = scrollView.adjustedContentInset.top;
        }
        if(fOffsetY > -insets.top - fAdjust + Min_Equal_dis){
            [self setScrollViewContentInset:UIEdgeInsetsMake(self.fEdgeTop, insets.left, insets.bottom, insets.right) completeHanlder:nil];
        }
    }else if(Heqingzhao_LoadingViewState_Normal == _topLoadingView.loadingState){
        self.fEdgeTop = MAXFLOAT;
    }
}

- (void)processBottomLoadingWithScrollView:(UIScrollView*)scrollView{
    CGFloat fOffsetY = scrollView.contentOffset.y;
    UIEdgeInsets insets = self.tableView.contentInset;
    if(Heqingzhao_LoadingViewState_PrePareLoading == _bottomLoadingView.loadingState){
        [_bottomLoadingView startLoading];
    }else if(Heqingzhao_LoadingViewState_Loading == _bottomLoadingView.loadingState){
        CGFloat fTargetPosY = scrollView.contentSize.height + insets.bottom - scrollView.height;
        if(fOffsetY < fTargetPosY - Min_Equal_dis){
            [self setScrollViewContentInset:UIEdgeInsetsMake(insets.top, insets.left, self.fEdgeBottom, insets.right) completeHanlder:nil];
        }
    }else if(Heqingzhao_LoadingViewState_Normal == _bottomLoadingView.loadingState){
        self.fEdgeBottom = MAXFLOAT;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat fOffsetY = scrollView.contentOffset.y;
    UIEdgeInsets insets = self.tableView.contentInset;
    
    if(_topLoadingView && !_topLoadingView.hidden && _topLoadingView.height > 0){
        if(MAXFLOAT == _fEdgeTop){
            _fEdgeTop = insets.top;
        }
        CGFloat fAdjust = 0;
        if(@available(iOS 11.0, *)){
            fAdjust = scrollView.adjustedContentInset.top;
        }
        _topLoadingView.loadingScale = (-_fEdgeTop - fAdjust - fOffsetY)/_topLoadingView.height;
        if(Heqingzhao_LoadingViewState_Normal == _topLoadingView.loadingState){
            if(fOffsetY < (-insets.top - fAdjust - _topLoadingView.height) - Min_Equal_dis){
                _topLoadingView.loadingState = Heqingzhao_LoadingViewState_PrePareLoading;
            }
        }else if(Heqingzhao_LoadingViewState_PrePareLoading == _topLoadingView.loadingState){
            if(fOffsetY > (-insets.top - fAdjust - _topLoadingView.height) + Min_Equal_dis){
                _topLoadingView.loadingState = Heqingzhao_LoadingViewState_Normal;
            }
        }
    }
    if(_bottomLoadingView && !_bottomLoadingView.hidden && _bottomLoadingView.height > 0){
        if(MAXFLOAT == _fEdgeBottom){
            _fEdgeBottom = insets.bottom;
        }
        CGFloat fTargetPosY = scrollView.contentSize.height + _fEdgeBottom - scrollView.height;
        if(fOffsetY > fTargetPosY){
            _bottomLoadingView.loadingScale = (fOffsetY - fTargetPosY)/_bottomLoadingView.height;
            if(Heqingzhao_LoadingViewState_Normal == _bottomLoadingView.loadingState){
                if(fOffsetY > fTargetPosY + _bottomLoadingView.height + Min_Equal_dis){
                    _bottomLoadingView.loadingState = Heqingzhao_LoadingViewState_PrePareLoading;
                }
            }else if(Heqingzhao_LoadingViewState_PrePareLoading == _bottomLoadingView.loadingState){
                if(fOffsetY < fTargetPosY + _bottomLoadingView.height - Min_Equal_dis){
                    _bottomLoadingView.loadingState = Heqingzhao_LoadingViewState_Normal;
                }
            }
        }
    }
}

- (void)setScrollViewContentInset:(UIEdgeInsets)insets completeHanlder:(void(^)(void))handler{
    if(insets.top == MAXFLOAT || insets.bottom == MAXFLOAT)
        return ;
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [UIView animateWithDuration:0.5 animations:^{
        self.tableView.contentInset = insets;
    } completion:^(BOOL finished) {
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        if(handler){
            handler();
        }
    }];
}

- (void)topLoadingViewChangeState:(Heqingzhao_LoadingViewState)state{
    UIEdgeInsets insets = self.tableView.contentInset;
    if(Heqingzhao_LoadingViewState_Loading == state){
        [self setScrollViewContentInset:UIEdgeInsetsMake(insets.top + self.topLoadingView.height, insets.left, insets.bottom, insets.right) completeHanlder:nil];
        if(self.topLoadingHandler){
            self.topLoadingHandler();
        }else if([self.delegate respondsToSelector:@selector(triggerTopLoadingWithTableController:)]){
            [self.delegate triggerTopLoadingWithTableController:self];
        }
    }else if(Heqingzhao_LoadingViewState_EndLoading == state){
        weak_Self;
        [self setScrollViewContentInset:UIEdgeInsetsMake(self.fEdgeTop, insets.left, insets.bottom, insets.right) completeHanlder:^{
            weakSelf.topLoadingView.loadingState = Heqingzhao_LoadingViewState_Normal;
            weakSelf.fEdgeTop = MAXFLOAT;
        }];
    }
}

- (void)bottomLoadingViewChangeState:(Heqingzhao_LoadingViewState)state{
    UIEdgeInsets insets = self.tableView.contentInset;
    if(Heqingzhao_LoadingViewState_Loading == state){
        [self setScrollViewContentInset:UIEdgeInsetsMake(insets.top, insets.left, self.fEdgeBottom + self.bottomLoadingView.height, insets.right) completeHanlder:nil];
        if(self.bottomLoadingHandler){
            self.bottomLoadingHandler();
        }else if([self.delegate respondsToSelector:@selector(triggerBottomLoadingWithTableController:)]){
            [self.delegate triggerBottomLoadingWithTableController:self];
        }
    }else if(Heqingzhao_LoadingViewState_EndLoading == state){
        _tableView.contentInset = UIEdgeInsetsMake(insets.top, insets.left, self.fEdgeBottom, insets.right);
        self.bottomLoadingView.loadingState = Heqingzhao_LoadingViewState_Normal;
        self.fEdgeBottom = MAXFLOAT;
    }
}

- (void)scrollViewDidChangeAdjustedContentInset:(UIScrollView *)scrollView{
    [self tableViewChangeContentSize:scrollView.contentSize];
}

- (void)tableViewChangeContentSize:(CGSize)size{
    CGFloat fVisibleHeight = size.height + _tableView.contentInset.bottom + _tableView.contentInset.top;
    CGFloat fAdjust = 0;
    if(@available(iOS 11.0,*)){
        fVisibleHeight += _tableView.adjustedContentInset.top + _tableView.adjustedContentInset.bottom;
        fAdjust = _tableView.adjustedContentInset.bottom;
    }
    
    if(fVisibleHeight >= _tableView.height){
        if(_bottomLoadingView.loadingState != Heqingzhao_LoadingViewState_Loading){
            _bottomLoadingView.hidden = NO;
            _bottomLoadingView.frame = CGRectMake(0, size.height + _tableView.contentInset.bottom + fAdjust, _tableView.width, _bottomLoadingView.height);
        }
    }else{
        _bottomLoadingView.hidden = YES;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if([keyPath isEqualToString:@"loadingState"]){
        Heqingzhao_LoadingViewState state = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
        if(object == self.topLoadingView){
            [self topLoadingViewChangeState:state];
        }else if(object == self.bottomLoadingView){
            [self bottomLoadingViewChangeState:state];
        }
    }else if([keyPath isEqualToString:@"contentSize"]){
        if(!_bottomLoadingView)
            return;
        NSNumber* numSize = [change objectForKey:NSKeyValueChangeNewKey];
        CGSize size = [numSize CGSizeValue];
        [self tableViewChangeContentSize:size];
    }
}

@end
