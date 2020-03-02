//
//  SFChartTextGrid.h
//  SinaFinance
//
//  Created by qingzhao on 2018/10/25.
//  Copyright © 2018年 qingzhao. All rights reserved.
//
//  只显示文本的定制表格，支持行列和列行两种方式的数据结构
//  可设置通用文本样式，或者通过delegate提供指定index的cell的样式
//
//

#import "SFChartStandardGrid.h"

@class SFChartTextGrid;
@class SFChartTextGridConfigration;

@protocol SFChartTextGridDelegate <SFChartStandardGridDelegate>

@optional
- (CGFloat)textGrid:(SFChartTextGrid*)grid widthForGridColumn:(NSInteger)nColumn;
- (SFChartTextGridConfigration*)textGrid:(SFChartTextGrid*)grid configForGridIndex:(SFChartGridCellIndex*)cellIndex text:(NSString*)text;
- (NSArray<SFChartElement*>*)textGrid:(SFChartTextGrid*)grid elementsForCellIndex:(SFChartGridCellIndex*)cellIndex text:(NSString*)text;

@end

typedef NS_OPTIONS(NSUInteger, SFTextAlignmentVertical){
    SFTextAlignmentTop,
    SFTextAlignmentCenter,
    SFTextAlignmentBottom
};

@interface SFChartTextGridConfigration : NSObject

@property(nonatomic, strong)NSDictionary* textAttribute;
@property(nonatomic, assign)NSTextAlignment alignment; // 水平对齐方式
@property(nonatomic, assign)SFTextAlignmentVertical alignmentVertical; // 垂直布局方式;
@property(nonatomic, assign)UIEdgeInsets edgeInset;
@property(nonatomic, assign)CGFloat contraintWidth; // 多行
@property(nonatomic, assign)CGFloat maxWidth; // 单行

+ (instancetype)defaultTextConfigration;

@end

@interface SFChartTextGrid : SFChartStandardGrid

@property(nonatomic, strong)NSArray<NSArray*>* rowsData;
@property(nonatomic, strong)NSArray<NSArray*>* columnsData;

@property(nonatomic, weak)id<SFChartTextGridDelegate> textDelegate;

// 每个子数组是一列的text数据  和rowsData只能有一个起作用
// config 所有text的配置，也可使用- (SFChartTextGridConfigration*)textGrid:(SFChartTextGrid*)grid configForGridIndex:(SFChartGridCellIndex*)cellIndex单独设置grid中text的样式
+ (instancetype)textGridWidhtConfigration:(SFChartTextGridConfigration*)config columnsData:(NSArray<NSArray*>*)columnsData;

// 每个子数组是一行的text数据
+ (instancetype)textGridWidhtConfigration:(SFChartTextGridConfigration*)config rowsData:(NSArray<NSArray*>*)rowsData;

@end
