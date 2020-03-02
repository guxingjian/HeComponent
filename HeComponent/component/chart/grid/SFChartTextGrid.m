//
//  SFChartTextGrid.m
//  SinaFinance
//
//  Created by qingzhao on 2018/10/25.
//  Copyright © 2018年 qingzhao. All rights reserved.
//

#import "SFChartTextGrid.h"
#import "SFChartCommonFunc.h"
#import "SFChartTextAnimatable.h"

@implementation SFChartTextGridConfigration

+ (instancetype)defaultTextConfigration
{
    SFChartTextGridConfigration* config = [[self alloc] init];
    config.textAttribute = @{NSForegroundColorAttributeName:[UIColor blackColor], NSFontAttributeName:[UIFont systemFontOfSize:15]};
    config.alignment = NSTextAlignmentLeft;
    config.alignmentVertical = SFTextAlignmentCenter;
    config.edgeInset = UIEdgeInsetsZero;
    config.contraintWidth = 0;
    return config;
}



@end

@interface SFChartTextGrid()<SFChartStandardGridDataSource, SFChartStandardGridDelegate>

@property(nonatomic, strong)SFChartTextGridConfigration* config;

@property(nonatomic, strong)NSMutableDictionary* textLayerCache;
@property(nonatomic, strong)NSMutableDictionary* dicGridRowHeight;

@end

@implementation SFChartTextGrid

+ (instancetype)textGridWidhtConfigration:(SFChartTextGridConfigration *)config columnsData:(NSArray<NSArray *> *)columnsData
{
    SFChartTextGrid* textGrid = [[self alloc] init];
    textGrid.config = config;
    textGrid.dataSource = textGrid;
    textGrid.delegate = textGrid;
    textGrid.columnsData = columnsData;
    return textGrid;
}

+ (instancetype)textGridWidhtConfigration:(SFChartTextGridConfigration *)config rowsData:(NSArray<NSArray *> *)rowsData
{
    SFChartTextGrid* textGrid = [[self alloc] init];
    textGrid.config = config;
    textGrid.dataSource = textGrid;
    textGrid.delegate = textGrid;
    textGrid.rowsData = rowsData;
    return textGrid;
}

- (void)setColumnsData:(NSArray<NSArray *> *)columnsData
{
    _columnsData = columnsData;
    
    NSInteger nRow = 0;
    for(NSInteger i = 0; i < columnsData.count; ++ i)
    {
        NSArray* arrayRows =  [columnsData objectAtIndex:i];
        if(arrayRows.count > nRow)
        {
            nRow = arrayRows.count;
        }
    }
    self.nRow = nRow;
    self.nColumn = columnsData.count;
}

- (void)setRowsData:(NSArray<NSArray *> *)rowsData
{
    _rowsData = rowsData;
    
    NSInteger nCol = 0;
    for(NSInteger i = 0; i < rowsData.count; ++ i)
    {
        NSArray* arrayColumns =  [rowsData objectAtIndex:i];
        if(arrayColumns.count > nCol)
        {
            nCol = arrayColumns.count;
        }
    }
    self.nRow = rowsData.count;
    self.nColumn = nCol;
}

- (NSMutableDictionary *)textLayerCache
{
    if(!_textLayerCache)
    {
        _textLayerCache = [NSMutableDictionary dictionary];
    }
    return _textLayerCache;
}

- (NSMutableDictionary *)dicGridRowHeight
{
    if(!_dicGridRowHeight)
    {
        _dicGridRowHeight = [NSMutableDictionary dictionary];
    }
    return _dicGridRowHeight;
}

- (NSString*)cacheKeyWithCellIndex:(SFChartGridCellIndex *)cellIndex
{
    NSString* strKey = [NSString stringWithFormat:@"key_%ld_%ld", cellIndex.nRow, cellIndex.nCol];
    return strKey;
}

- (void)addCacheLayer:(CAShapeLayer*)textLayer cellIndex:(SFChartGridCellIndex *)cellIndex
{
    if(!textLayer)
        return ;
    NSString* strKey = [self cacheKeyWithCellIndex:cellIndex];
    [self.textLayerCache setObject:textLayer forKey:strKey];
}

- (CGFloat)standardGrid:(SFChartStandardGrid *)gird widthForGridColumn:(NSInteger)nCol
{
    if([self.textDelegate respondsToSelector:@selector(textGrid:widthForGridColumn:)])
    {
        return [self.textDelegate textGrid:self widthForGridColumn:nCol];
    }
    return 0;
}

- (CAShapeLayer*)textLayerForCellIndex:(SFChartGridCellIndex*)cellIndex text:(NSString*)text adjustHeight:(CGFloat*)adjustH
{
    SFChartTextGridConfigration* config = self.config;
    CAShapeLayer* textLayer = [self.textLayerCache objectForKey:[self cacheKeyWithCellIndex:cellIndex]];
    if(!textLayer)
    {
        if([self.textDelegate respondsToSelector:@selector(textGrid:configForGridIndex:text:)])
        {
            config = [self.textDelegate textGrid:self configForGridIndex:cellIndex text:text];
        }
        if(config.maxWidth == 0)
        {
            if(NSTextAlignmentLeft == config.alignment)
            {
                config.maxWidth = [self standardGrid:self widthForGridColumn:cellIndex.nCol] - config.edgeInset.left;
            }
            else if(NSTextAlignmentRight == config.alignment)
            {
                config.maxWidth = [self standardGrid:self widthForGridColumn:cellIndex.nCol] - config.edgeInset.right;
            }
            else
            {
                config.maxWidth = [self standardGrid:self widthForGridColumn:cellIndex.nCol];
            }
        }
        
        if(config.contraintWidth > 0)
        {
            textLayer = [SFChartCommonFunc boundingLayerWithText:text attributes:config.textAttribute contraintWidth:config.contraintWidth];
        }
        else
        {
            textLayer = [SFChartCommonFunc boundingLayerWithText:text attributes:config.textAttribute maxWidth:config.maxWidth scaled:1];
        }
        textLayer.masksToBounds = YES;
    }
    *adjustH = config.edgeInset.top + config.edgeInset.bottom;
    
    return textLayer;
}

- (CGFloat)standardGrid:(SFChartStandardGrid *)gird heightForGridRow:(NSInteger)nRow
{
    CGFloat cellHeight = 0;
    CGFloat fAdjustH = 0;
    SFChartGridCellIndex* cellIndex = [SFChartGridCellIndex indexWithRow:0 column:0];
    if(self.rowsData.count > 0)
    {
        if(nRow < self.rowsData.count)
        {
            NSArray* arrayColumns = [self.rowsData objectAtIndex:nRow];
            for(NSInteger i = 0; i < arrayColumns.count; ++ i)
            {
                NSString* text = [arrayColumns objectAtIndex:i];
                if(![text isKindOfClass:[NSString class]])
                    continue ;
                
                cellIndex.nRow = nRow;
                cellIndex.nCol = i;
                CAShapeLayer* textLayer = [self textLayerForCellIndex:cellIndex text:text adjustHeight:&fAdjustH];
                if(textLayer.bounds.size.height > cellHeight)
                {
                    cellHeight = textLayer.bounds.size.height;
                }
                [self addCacheLayer:textLayer cellIndex:[SFChartGridCellIndex indexWithRow:nRow column:i]];
            }
        }
    }
    else if(self.columnsData.count > 0)
    {
        for(NSInteger i = 0; i < self.columnsData.count; ++ i)
        {
            NSArray* arrayRows = [self.columnsData objectAtIndex:i];
            if(nRow < arrayRows.count)
            {
                NSString* text = [arrayRows objectAtIndex:nRow];
                if(![text isKindOfClass:[NSString class]])
                    continue ;
                
                cellIndex.nRow = nRow;
                cellIndex.nCol = i;
                
                CAShapeLayer* textLayer = [self textLayerForCellIndex:cellIndex text:text adjustHeight:&fAdjustH];
                if(textLayer.bounds.size.height > cellHeight)
                {
                    cellHeight = textLayer.bounds.size.height;
                }
                [self addCacheLayer:textLayer cellIndex:[SFChartGridCellIndex indexWithRow:nRow column:i]];
            }
        }
    }
    
    cellHeight += fAdjustH;
    
    NSString* strHeightKey = [NSString stringWithFormat:@"height_%ld", nRow];
    NSNumber* numH = [NSNumber numberWithFloat:cellHeight];
    [self.dicGridRowHeight setObject:numH forKey:strHeightKey];
    
    return cellHeight;
}

- (NSString*)textForGridCellIndex:(SFChartGridCellIndex*)cellIndex
{
    NSString* text = nil;
    if(self.rowsData.count > 0)
    {
        if(cellIndex.nRow < self.rowsData.count)
        {
            NSArray* arrayColumns = [self.rowsData objectAtIndex:cellIndex.nRow];
            if(cellIndex.nCol < arrayColumns.count)
            {
                text = [arrayColumns objectAtIndex:cellIndex.nCol];
            }
        }
    }
    else if(self.columnsData.count > 0)
    {
        if(cellIndex.nCol < self.columnsData.count)
        {
            NSArray* arrayRowData = [self.columnsData objectAtIndex:cellIndex.nCol];
            if(cellIndex.nRow < arrayRowData.count)
            {
                text = [arrayRowData objectAtIndex:cellIndex.nRow];
            }
        }
    }
    return text;
}

- (NSArray<SFChartElement *> *)standardGrid:(SFChartStandardGrid *)gird elementsForGridIndex:(SFChartGridCellIndex *)cellIndex
{
    NSString* text = nil;
    if([self.textDelegate respondsToSelector:@selector(textGrid:elementsForCellIndex:text:)])
    {
        text = [self textForGridCellIndex:cellIndex];
        NSArray* arrayEle = [self.textDelegate textGrid:self elementsForCellIndex:cellIndex text:text];
        if(arrayEle.count > 0)
            return arrayEle;
    }
    
    CAShapeLayer* textLayer = [self.textLayerCache objectForKey:[self cacheKeyWithCellIndex:cellIndex]];
    if(!textLayer)
        return nil;
    
    SFChartTextGridConfigration* config = self.config;
    if([self.textDelegate respondsToSelector:@selector(textGrid:configForGridIndex:text:)])
    {
        if(!text)
        {
            text = [self textForGridCellIndex:cellIndex];
        }
        config = [self.textDelegate textGrid:self configForGridIndex:cellIndex text:text];
    }
    
    SFChartTextAnimatable* textEle = [SFChartTextAnimatable chartElement];
    
    SFChartTextModel* model =  [SFChartTextModel model];
    model.dicAttr = config.textAttribute;
    model.constraintWidth = config.contraintWidth;
    
    CGPoint positionPt = CGPointZero;
    
    if(SFTextAlignmentTop == config.alignmentVertical)
    {
        positionPt.y = config.edgeInset.top + textLayer.bounds.size.height/2;
    }
    else if(SFTextAlignmentCenter == config.alignmentVertical)
    {
        NSString* strHeightKey = [NSString stringWithFormat:@"height_%ld", cellIndex.nRow];
        NSNumber* numH = [self.dicGridRowHeight objectForKey:strHeightKey];
        positionPt.y = [numH floatValue]/2;
    }
    else if(SFTextAlignmentBottom == config.alignmentVertical)
    {
        NSString* strHeightKey = [NSString stringWithFormat:@"height_%ld", cellIndex.nRow];
        NSNumber* numH = [self.dicGridRowHeight objectForKey:strHeightKey];
        positionPt.y = [numH floatValue] - config.edgeInset.bottom - textLayer.bounds.size.height/2;
    }
    
    if(NSTextAlignmentLeft == config.alignment)
    {
        positionPt.x = config.edgeInset.left + textLayer.bounds.size.width/2;
    }
    else if(NSTextAlignmentCenter == config.alignment)
    {
        SFChartGrid* currentGrid = [self gridAtIndex:cellIndex];
        positionPt.x = currentGrid.boundRect.size.width/2;
    }
    else if(NSTextAlignmentRight == config.alignment)
    {
        SFChartGrid* currentGrid = [self gridAtIndex:cellIndex];
        positionPt.x = currentGrid.boundRect.size.width - config.edgeInset.right - textLayer.bounds.size.width/2;
    }
    model.posiInValue = positionPt;
    textEle.arrayTextLayer = @[textLayer];
    textEle.arrayText = @[model];
    
    return @[textEle];
}

- (void)standardGrid:(SFChartStandardGrid *)grid getGridSize:(CGSize)size
{
    if([self.textDelegate respondsToSelector:@selector(standardGrid:getGridSize:)])
    {
        [self.textDelegate standardGrid:grid getGridSize:size];
    }
}

@end
