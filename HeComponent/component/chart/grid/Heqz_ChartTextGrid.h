//
//  Heqz_ChartTextGrid.h
//  SinaFinance
//
//  Created by qingzhao on 2018/10/25.
//  Copyright © 2018年 qingzhao. All rights reserved.
//
//  只显示文本的定制表格，支持行列和列行两种方式的数据结构
//  可设置通用文本样式，或者通过delegate提供指定index的cell的样式
//
//

#import "Heqz_ChartStandardGrid.h"

@class Heqz_ChartTextGrid;
@class Heqz_ChartTextGridConfigration;

@protocol Heqz_ChartTextGridDelegate <Heqz_ChartStandardGridDelegate>

@optional
- (CGFloat)textGrid:(Heqz_ChartTextGrid*)grid widthForGridColumn:(NSInteger)nColumn;
- (Heqz_ChartTextGridConfigration*)textGrid:(Heqz_ChartTextGrid*)grid configForGridIndex:(Heqz_ChartGridCellIndex*)cellIndex text:(NSString*)text;
- (NSArray<Heqz_ChartElement*>*)textGrid:(Heqz_ChartTextGrid*)grid elementsForCellIndex:(Heqz_ChartGridCellIndex*)cellIndex text:(NSString*)text;

@end

typedef NS_OPTIONS(NSUInteger, SFTextAlignmentVertical){
    SFTextAlignmentTop,
    SFTextAlignmentCenter,
    SFTextAlignmentBottom
};

@interface Heqz_ChartTextGridConfigration : NSObject

@property(nonatomic, strong)NSDictionary* textAttribute;
@property(nonatomic, assign)NSTextAlignment alignment; // 水平对齐方式
@property(nonatomic, assign)SFTextAlignmentVertical alignmentVertical; // 垂直布局方式;
@property(nonatomic, assign)UIEdgeInsets edgeInset;
@property(nonatomic, assign)CGFloat contraintWidth; // 多行
@property(nonatomic, assign)CGFloat maxWidth; // 单行

+ (instancetype)defaultTextConfigration;

@end

@interface Heqz_ChartTextGrid : Heqz_ChartStandardGrid

@property(nonatomic, strong)NSArray<NSArray*>* rowsData;
@property(nonatomic, strong)NSArray<NSArray*>* columnsData;

@property(nonatomic, weak)id<Heqz_ChartTextGridDelegate> textDelegate;

// 每个子数组是一列的text数据  和rowsData只能有一个起作用
// config 所有text的配置，也可使用- (Heqz_ChartTextGridConfigration*)textGrid:(Heqz_ChartTextGrid*)grid configForGridIndex:(Heqz_ChartGridCellIndex*)cellIndex单独设置grid中text的样式
+ (instancetype)textGridWidhtConfigration:(Heqz_ChartTextGridConfigration*)config columnsData:(NSArray<NSArray*>*)columnsData;

// 每个子数组是一行的text数据
+ (instancetype)textGridWidhtConfigration:(Heqz_ChartTextGridConfigration*)config rowsData:(NSArray<NSArray*>*)rowsData;

@end
