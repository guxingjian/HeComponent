//
//  Heqingzhao_tableController.m
//  HeComponent
//
//  Created by qingzhao on 2019/2/25.
//  Copyright © 2019年 qingzhao. All rights reserved.
//

#import "Heqingzhao_tableViewController.h"
#import "UIView+view_frame.h"
#import "Heqingzhao_tableViewBaseCell.h"

@implementation Heqingzhao_tableViewController

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
        [baseCell setDataItem:cellConfig.userData];
    }
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = nil;
    
    if(self.arraySections.count > 0 && indexPath.section < self.arraySections.count){
        Heqingzhao_tableViewSectionConfig* sectionConfig = [self.arraySections objectAtIndex:indexPath.section];
        if(indexPath.row < sectionConfig.arrayCells.count){
            Heqingzhao_tableViewCellConfig* cellConfig = [sectionConfig.arrayCells objectAtIndex:indexPath.row];
            cell = [self cellWithCellConfig:cellConfig];
        }
    }else if(self.arrayCells.count > 0){
        if(indexPath.row < self.arrayCells.count){
            Heqingzhao_tableViewCellConfig* cellConfig = [self.arrayCells objectAtIndex:indexPath.row];
            return cellConfig.cellHeight;
        }
    }
    return 0;
}

@end
