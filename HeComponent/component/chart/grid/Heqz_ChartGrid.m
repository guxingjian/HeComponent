//
//  Heqz_ChartGrid.m
//  SinaFinance
//
//  Created by qingzhao on 2018/5/25.
//  Copyright © 2018年 qingzhao. All rights reserved.
//

#import "Heqz_ChartGrid.h"
#import "Heqz_ChartPolylineAnimatable.h"

@implementation Heqz_ChartGridCellIndex

+ (instancetype)indexWithRow:(NSInteger)row column:(NSInteger)col
{
    Heqz_ChartGridCellIndex* index = [[self alloc] init];
    index.nRow = row;
    index.nCol = col;
    return index;
}

- (BOOL)equalToindex:(Heqz_ChartGridCellIndex *)index
{
    return (self.nRow == index.nRow && self.nCol == index.nCol);
}

@end

@interface Heqz_ChartGrid()

@property(nonatomic, weak)Heqz_ChartGrid* superGrid;

@end

@implementation Heqz_ChartGrid

+ (instancetype)grid
{
    Heqz_ChartGrid* grid = [[self alloc] init];
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
        for(Heqz_ChartGrid* grid in arrayRows)
        {
            [grid setEnableRelativePosition:YES];
        }
    }
}

- (Heqz_ChartGrid *)gridAtIndex:(Heqz_ChartGridCellIndex *)index
{
    Heqz_ChartGrid* grid = [self exitGridAtIndex:index];
    if(!grid)
    {
        grid = [Heqz_ChartGrid grid];
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
                Heqz_ChartGrid* emptyGrid = [Heqz_ChartGrid grid];
                emptyGrid.cellIndex = [Heqz_ChartGridCellIndex indexWithRow:index.nRow column:i];
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

- (Heqz_ChartGrid*)exitGridAtIndex:(Heqz_ChartGridCellIndex*)index
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

- (void)addElementsWithChart:(Heqz_ChartChart *)chart
{
    if(self.subGrids.count == 0)
    {
        for(Heqz_ChartElement* chartEle in self.arrayContent)
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
            for(Heqz_ChartGrid* subGrid in arrayCols)
            {
                [subGrid addElementsWithChart:chart];
            }
        }
    }
    
    if(self.superGrid && self.lineWidth > 0)
    {
        Heqz_ChartPointCollection* ptCol = [self.superGrid subGridBoundingPoints:self];
        Heqz_ChartPolylineAnimatable* polyLine = [Heqz_ChartPolylineAnimatable chartElement];
        polyLine.ptCollection = ptCol;
        polyLine.lineWidth = self.lineWidth;
        polyLine.lineColor = self.lineColor;
        [chart addElement:polyLine];
    }
    else
    {
//        CGRect rt = self.boundRect;
//        Heqz_ChartPointCollection* ptCol = [Heqz_ChartPointCollection chartElement];
//        [ptCol addPoint:self.boundRect.origin];
//        [ptCol addPoint:CGPointMake(rt.origin.x + rt.size.width, rt.origin.y)];
//        [ptCol addPoint:CGPointMake(rt.origin.x + rt.size.width, rt.origin.y + rt.size.height)];
//        [ptCol addPoint:CGPointMake(rt.origin.x, rt.origin.y + rt.size.height)];
//        [ptCol addPoint:self.boundRect.origin];
//
//        Heqz_ChartPolylineAnimatable* polyLine = [Heqz_ChartPolylineAnimatable chartElement];
//        polyLine.ptCollection = ptCol;
//        polyLine.lineWidth = self.lineWidth;
//        polyLine.lineColor = self.lineColor;
//        [chart addElement:polyLine];
    }
}

- (Heqz_ChartPointCollection *)subGridBoundingPoints:(Heqz_ChartGrid *)subGrid
{
    Heqz_ChartGridCellIndex* index = subGrid.cellIndex;
    CGRect subRt = subGrid.boundRect;
    
    Heqz_ChartPointCollection* ptCol = [Heqz_ChartPointCollection chartElement];
    
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

- (Heqz_ChartGrid *)gridCellWithLocation:(CGPoint)pt{
    if(CGRectContainsPoint(self.boundRect, pt)){
        if(self.subGrids.count == 0)
            return self;
        
        for(NSArray* arrayGrid in self.subGrids){
            for(Heqz_ChartGrid* grid in arrayGrid){
                if(CGRectContainsPoint(grid.boundRect, pt)){
                    return [grid gridCellWithLocation:pt];
                }
            }
        }
    }
    return nil;
}

@end
