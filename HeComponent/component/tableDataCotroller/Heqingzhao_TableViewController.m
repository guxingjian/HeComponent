//
//  Heqingzhao_tableController.m
//  HeComponent
//
//  Created by qingzhao on 2019/2/25.
//  Copyright © 2019年 qingzhao. All rights reserved.
//

#import "Heqingzhao_TableViewController.h"
#import "UIView+view_frame.h"

@interface Heqingzhao_TableViewController()

@property(nonatomic,copy)void(^topLoadingHandler)(void);
@property(nonatomic,copy)void(^bottomLoadingHandler)(void);

@end

@implementation Heqingzhao_TableViewController

- (void)dealloc{
    self.topLoadingView = nil;
    self.bottomLoadingView = nil;
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
}

- (void)setTableView:(UITableView *)tableView{
    _tableView = tableView;
    tableView.delegate = self;
    tableView.dataSource = self;
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
        [self.topLoadingView removeObserver:self forKeyPath:@"state"];
    }
    _topLoadingView = topLoadingView;
    [self.topLoadingView addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
    topLoadingView.frame = CGRectMake(0, self.tableView.contentInset.top - topLoadingView.height, self.tableView.width, topLoadingView.height);
    [self.tableView addSubview:topLoadingView];
}

- (void)setBottomLoadingView:(Heqingzhao_LoadingView *)bottomLoadingView{
    if(self.bottomLoadingView){
        [self.bottomLoadingView endLoading];
        [self.bottomLoadingView removeFromSuperview];
        [self.bottomLoadingView removeObserver:self forKeyPath:@"state"];
    }
    _bottomLoadingView = bottomLoadingView;
    [self.bottomLoadingView addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
    bottomLoadingView.frame = CGRectMake(0, self.tableView.contentSize.height + self.tableView.contentInset.bottom, self.tableView.width, bottomLoadingView.height);
    [self.tableView addSubview:bottomLoadingView];
}

- (void)installTopLoadingView:(Heqingzhao_LoadingView *)loadingView loadingHandler:(void (^)(void))handler{
    self.topLoadingView = loadingView;
    self.topLoadingHandler = handler;
}

- (void)installBottomLoadingView:(Heqingzhao_LoadingView *)loadingView loadingHandler:(void (^)(void))handler{
    self.bottomLoadingView = loadingView;
    self.bottomLoadingHandler = handler;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat fOffsetY = scrollView.contentOffset.y;
    UIEdgeInsets insets = self.tableView.contentInset;
    if(fOffsetY < -insets.top - self.topLoadingView.height){
        
        // to do ...
        if(Heqingzhao_LoadingViewState_Normal == self.topLoadingView.state){
            [self.topLoadingView prepareLoading];
        }
    }else if(fOffsetY < (scrollView.contentSize.height + insets.bottom - scrollView.height)){
        if(Heqingzhao_LoadingViewState_Loading == self.bottomLoadingView.state){
            [self bottomLoadingViewChangeState:Heqingzhao_LoadingViewState_Normal];
        }
    }
    
    if(fOffsetY > (scrollView.contentSize.height + insets.bottom - scrollView.height)){
        if(self.bottomLoadingView.state != Heqingzhao_LoadingViewState_Loading){
            [self.bottomLoadingView startLoading];
        }
    }
    else if(fOffsetY > -insets.top){
        if(Heqingzhao_LoadingViewState_Loading == self.topLoadingView.state){
            [self topLoadingViewChangeState:Heqingzhao_LoadingViewState_Normal];
        }
    }
}

- (void)topLoadingViewChangeState:(Heqingzhao_LoadingViewState)state{
    UIEdgeInsets insets = self.tableView.contentInset;
    if(Heqingzhao_LoadingViewState_Loading == state){
        self.tableView.contentInset = UIEdgeInsetsMake(insets.top + self.topLoadingView.height, insets.left, insets.bottom, insets.right);
        if(self.topLoadingHandler){
            self.topLoadingHandler();
            self.topLoadingHandler = nil;
        }else if([self.delegate respondsToSelector:@selector(triggerTopLoadingWithTableController:)]){
            [self.delegate triggerTopLoadingWithTableController:self];
        }
    }else if(Heqingzhao_LoadingViewState_Normal == state){
        self.tableView.contentInset = UIEdgeInsetsMake(insets.top - self.topLoadingView.height, insets.left, insets.bottom, insets.right);
        insets = self.tableView.contentInset;
        int a = 10;
    }
}

- (void)bottomLoadingViewChangeState:(Heqingzhao_LoadingViewState)state{
    UIEdgeInsets insets = self.tableView.contentInset;
    if(Heqingzhao_LoadingViewState_Loading == state){
        self.tableView.contentInset = UIEdgeInsetsMake(insets.top, insets.left, insets.bottom + self.bottomLoadingView.height, insets.right);
        if(self.bottomLoadingHandler){
            self.bottomLoadingHandler();
            self.bottomLoadingHandler = nil;
        }else if([self.delegate respondsToSelector:@selector(triggerBottomLoadingWithTableController:)]){
            [self.delegate triggerBottomLoadingWithTableController:self];
        }
    }else if(Heqingzhao_LoadingViewState_Normal == state){
        self.tableView.contentInset = UIEdgeInsetsMake(insets.top - self.topLoadingView.height, insets.left, insets.bottom, insets.right);
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if([keyPath isEqualToString:@"state"]){
        Heqingzhao_LoadingViewState state = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
        if(object == self.topLoadingView){
            [self topLoadingViewChangeState:state];
        }else if(object == self.bottomLoadingView){
            [self bottomLoadingViewChangeState:state];
        }
    }
}

@end
