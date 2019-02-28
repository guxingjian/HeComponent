//
//  Heqingzhao_tableController.m
//  HeComponent
//
//  Created by qingzhao on 2019/2/25.
//  Copyright © 2019年 qingzhao. All rights reserved.
//

#import "Heqingzhao_tableViewController.h"
#import "UIView+view_frame.h"

@interface Heqingzhao_tableViewController()

@property(nonatomic,copy)void(^topLoadingHandler)(void);
@property(nonatomic,copy)void(^bottomLoadingHandler)(void);

@end

@implementation Heqingzhao_tableViewController

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
        Heqingzhao_tableViewSectionConfig* sectionConfig = [self.arraySections objectAtIndex:section];
        return sectionConfig.arrayCells.count;
    }else if(self.arrayCells.count > 0){
        return self.arrayCells.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(self.arraySections.count > 0  && section < self.arraySections.count){
        Heqingzhao_tableViewSectionConfig* sectionConfig = [self.arraySections objectAtIndex:section];
        return sectionConfig.headerView.height;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(self.arraySections.count > 0 && section < self.arraySections.count){
        Heqingzhao_tableViewSectionConfig* sectionConfig = [self.arraySections objectAtIndex:section];
        return sectionConfig.headerView;
    }
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(self.arraySections.count > 0 && section < self.arraySections.count){
        Heqingzhao_tableViewSectionConfig* sectionConfig = [self.arraySections objectAtIndex:section];
        return sectionConfig.footerView.height;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if(self.arraySections.count > 0 && section < self.arraySections.count){
        Heqingzhao_tableViewSectionConfig* sectionConfig = [self.arraySections objectAtIndex:section];
        return sectionConfig.footerView;
    }
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.arraySections.count > 0 && indexPath.section < self.arraySections.count){
        Heqingzhao_tableViewSectionConfig* sectionConfig = [self.arraySections objectAtIndex:indexPath.section];
        if(indexPath.row < sectionConfig.arrayCells.count){
            Heqingzhao_tableViewCellConfig* cellConfig = [sectionConfig.arrayCells objectAtIndex:indexPath.row];
            return cellConfig.cellHeight;
        }
    }else if(self.arrayCells.count > 0){
        if(indexPath.row < self.arrayCells.count){
            Heqingzhao_tableViewCellConfig* cellConfig = [self.arrayCells objectAtIndex:indexPath.row];
            return cellConfig.cellHeight;
        }
    }
    return 0;
}

- (void)baseCell:(Heqingzhao_tableViewBaseCell *)cell doActionWithInfo:(id)info{
    
}

- (UITableViewCell*)cellWithCellConfig:(Heqingzhao_tableViewCellConfig*)cellConfig tableView:(UITableView*)tableView{
    if(cellConfig.cell)
        return cellConfig.cell;
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellConfig.cellIdentifier];
    if(!cell){
        cell = [Heqingzhao_tableViewBaseCell tableViewCellWithNibName:cellConfig.cellName bundle:[NSBundle bundleForClass:[self class]]];
    }
    if(!cell){
        Class cellClass = NSClassFromString(cellConfig.cellName);
        cell = [cellClass alloc];
        if([cell isKindOfClass:[UITableViewCell class]]){
            cell = [cell initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellConfig.cellIdentifier];
        }
    }
    if([cell isKindOfClass:[Heqingzhao_tableViewBaseCell class]]){
        Heqingzhao_tableViewBaseCell* baseCell = (Heqingzhao_tableViewBaseCell*)cell;
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
        Heqingzhao_tableViewSectionConfig* sectionConfig = [self.arraySections objectAtIndex:indexPath.section];
        if(indexPath.row < sectionConfig.arrayCells.count){
            Heqingzhao_tableViewCellConfig* cellConfig = [sectionConfig.arrayCells objectAtIndex:indexPath.row];
            cell = [self cellWithCellConfig:cellConfig tableView:tableView];
        }
    }else if(self.arrayCells.count > 0){
        if(indexPath.row < self.arrayCells.count){
            Heqingzhao_tableViewCellConfig* cellConfig = [self.arrayCells objectAtIndex:indexPath.row];
            cell = [self cellWithCellConfig:cellConfig tableView:tableView];
        }
    }
    
    return 0;
}

- (void)reloadData{
    [self.tableView reloadData];
}

- (void)setTopLoadingView:(Heqingzhao_loadingView *)topLoadingView{
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

- (void)setBottomLoadingView:(Heqingzhao_loadingView *)bottomLoadingView{
    if(self.bottomLoadingView){
        [self.bottomLoadingView endLoading];
        [self.bottomLoadingView removeFromSuperview];
        [self.bottomLoadingView removeObserver:self forKeyPath:@"state"];
    }
    _bottomLoadingView = bottomLoadingView;
    [self.bottomLoadingView addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)installTopLoadingView:(Heqingzhao_loadingView *)loadingView loadingHandler:(void (^)(void))handler{
    self.topLoadingView = loadingView;
    self.topLoadingHandler = handler;
}

- (void)installBottomLoadingView:(Heqingzhao_loadingView *)loadingView loadingHandler:(void (^)(void))handler{
    self.bottomLoadingView = loadingView;
    self.bottomLoadingHandler = handler;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(scrollView.contentOffset.y < (scrollView.contentInset.top - self.topLoadingView.height)){
        [self.topLoadingView startLoading];
    }
}

@end
