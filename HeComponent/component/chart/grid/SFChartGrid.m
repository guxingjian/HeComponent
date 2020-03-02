//
//  SFChartGrid.m
//  SinaFinance
//
//  Created by qingzhao on 2018/5/25.
//  Copyright © 2018年 qingzhao. All rights reserved.
//

#import "SFChartGrid.h"
#import "SFChartPolylineAnimatable.h"

@implementation SFChartGridCellIndex

+ (instancetype)indexWithRow:(NSInteger)row column:(NSInteger)col
{
    SFChartGridCellIndex* index = [[self alloc] init];
    index.nRow = row;
    index.nCol = col;
    return index;
}

- (BOOL)equalToindex:(SFChartGridCellIndex *)index
{
    return (self.nRow == index.nRow && self.nCol == index.nCol);
}

@end

@interface SFChartGrid()

@property(nonatomic, weak)SFChartGrid* superGrid;

@end

@implementation SFChartGrid

+ (instancetype)grid
{
    SFChartGrid* grid = [[self alloc] init];
    return grid;
}

- (instancetype)init
{
    if(self = [super init])
    {
        self.lineWidth = 1;
    }
    return self;
}

- (NSMutableArray *)subGrids
{
    if(!_subGrids)
    {
        _subGrids = [NSMutableArray array];
    }
    return _subGrids;
}

- (void)setEnableRelativePosition:(BOOL)enableRelativePosition
{
    _enableRelativePosition = enableRelativePosition;
    for(NSArray* arrayRows in self.subGrids)
    {
        for(SFChartGrid* grid in arrayRows)
        {
            [grid setEnableRelativePosition:YES];
        }
    }
}

- (SFChartGrid *)gridAtIndex:(SFChartGridCellIndex *)index
{
    SFChartGrid* grid = [self exitGridAtIndex:index];
    if(!grid)
    {
        grid = [SFChartGrid grid];
        grid.enableRelativePosition = self.enableRelativePosition;
        grid.cellIndex = index;
        grid.superGrid = self;
        grid.lineColor = self.lineColor;
        grid.lineWidth = self.lineWidth;
        
        if(index.nRow >= self.subGrids.count)
        {
            for(NSInteger i = self.subGrids.count; i <= index.nRow; ++ i)
            {
                NSMutableArray* arrayCols = [NSMutableArray array];
                [self.subGrids addObject:arrayCols];
            }
        }
        
        NSMutableArray* arrayCols = [self.subGrids objectAtIndex:index.nRow];
        if(index.nCol >= arrayCols.count)
        {
            for(NSInteger i = arrayCols.count; i < index.nCol; ++ i)
            {
                SFChartGrid* emptyGrid = [SFChartGrid grid];
                emptyGrid.cellIndex = [SFChartGridCellIndex indexWithRow:index.nRow column:i];
                emptyGrid.superGrid = self;
                emptyGrid.boundRect = CGRectZero;
                emptyGrid.lineColor = self.lineColor;
                emptyGrid.lineWidth = self.lineWidth;
                [arrayCols addObject:emptyGrid];
            }
        }
        [arrayCols addObject:grid];
    }
    return grid;
}

- (SFChartGrid*)exitGridAtIndex:(SFChartGridCellIndex*)index
{
    if(index.nRow >= self.subGrids.count)
        return nil;
    
    NSArray* arrayCol = [self.subGrids objectAtIndex:index.nRow];
    if(index.nCol >= arrayCol.count)
        return nil;
    
    return [arrayCol objectAtIndex:index.nCol];
}

- (void)setBoundRect:(CGRect)boundRect
{
    CGRect superRt = self.superGrid.boundRect;
    _boundRect = CGRectMake(superRt.origin.x + boundRect.origin.x, superRt.origin.y + boundRect.origin.y, boundRect.size.width, boundRect.size.height);
}

- (void)setBoundingLines
{
    
}

- (void)addElementsWithChart:(SFChartChart *)chart
{
    if(self.subGrids.count == 0)
    {
        for(SFChartElement* chartEle in self.arrayContent)
        {
            if(self.enableRelativePosition)
            {
                chartEle.relativeRect = self.boundRect;
            }
            [chart addElement:chartEle];
        }
    }
    else
    {
        for(NSArray* arrayCols in self.subGrids)
        {
            for(SFChartGrid* subGrid in arrayCols)
            {
                [subGrid addElementsWithChart:chart];
            }
        }
    }
    
    if(self.superGrid && self.lineWidth > 0)
    {
        SFChartPointCollection* ptCol = [self.superGrid subGridBoundingPoints:self];
        SFChartPolylineAnimatable* polyLine = [SFChartPolylineAnimatable chartElement];
        polyLine.ptCollection = ptCol;
        polyLine.lineWidth = self.lineWidth;
        polyLine.lineColor = self.lineColor;
        [chart addElement:polyLine];
    }
    else
    {
//        CGRect rt = self.boundRect;
//        SFChartPointCollection* ptCol = [SFChartPointCollection chartElement];
//        [ptCol addPoint:self.boundRect.origin];
//        [ptCol addPoint:CGPointMake(rt.origin.x + rt.size.width, rt.origin.y)];
//        [ptCol addPoint:CGPointMake(rt.origin.x + rt.size.width, rt.origin.y + rt.size.height)];
//        [ptCol addPoint:CGPointMake(rt.origin.x, rt.origin.y + rt.size.height)];
//        [ptCol addPoint:self.boundRect.origin];
//
//        SFChartPolylineAnimatable* polyLine = [SFChartPolylineAnimatable chartElement];
//        polyLine.ptCollection = ptCol;
//        polyLine.lineWidth = self.lineWidth;
//        polyLine.lineColor = self.lineColor;
//        [chart addElement:polyLine];
    }
}

- (SFChartPointCollection *)subGridBoundingPoints:(SFChartGrid *)subGrid
{
    SFChartGridCellIndex* index = subGrid.cellIndex;
    CGRect subRt = subGrid.boundRect;
    
    SFChartPointCollection* ptCol = [SFChartPointCollection chartElement];
    
    if(index.nRow >= self.subGrids.count)
        return nil;

    if(index.nCol == 0)
    {
        [ptCol addPoint:CGPointMake(subRt.origin.x, subRt.origin.y)];
        [ptCol addPoint:CGPointMake(subRt.origin.x , subRt.origin.y + subRt.size.height)];
    }
    
    [ptCol addPoint:CGPointMake(subRt.origin.x, subRt.origin.y + subRt.size.height)];
    [ptCol addPoint:CGPointMake(subRt.origin.x + subRt.size.width, subRt.origin.y + subRt.size.height)];
    
    [ptCol addPoint:CGPointMake(subRt.origin.x + subRt.size.width, subRt.origin.y + subRt.size.height)];
    [ptCol addPoint:CGPointMake(subRt.origin.x + subRt.size.width, subRt.origin.y)];
    
    if(index.nRow == 0)
    {
        [ptCol addPoint:CGPointMake(subRt.origin.x + subRt.size.width, subRt.origin.y)];
        [ptCol addPoint:CGPointMake(subRt.origin.x, subRt.origin.y)];
    }
    
    return ptCol;
}

- (void)clearContent
{
    [self.subGrids removeAllObjects];
}

- (SFChartGrid *)gridCellWithLocation:(CGPoint)pt{
    if(CGRectContainsPoint(self.boundRect, pt)){
        if(self.subGrids.count == 0)
            return self;
        
        for(NSArray* arrayGrid in self.subGrids){
            for(SFChartGrid* grid in arrayGrid){
                if(CGRectContainsPoint(grid.boundRect, pt)){
                    return [grid gridCellWithLocation:pt];
                }
            }
        }
    }
    return nil;
}

@end
