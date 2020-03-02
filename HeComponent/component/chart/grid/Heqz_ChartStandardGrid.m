//
//  Heqz_ChartCommonGrid.m
//  SinaFinance
//
//  Created by qingzhao on 2018/10/25.
//  Copyright © 2018年 qingzhao. All rights reserved.
//

#import "Heqz_ChartStandardGrid.h"

@interface Heqz_ChartStandardGrid()

@end

@implementation Heqz_ChartStandardGrid

+ (instancetype)standardGridWithColumn:(NSInteger)nCol row:(NSInteger)nRow
{
    Heqz_ChartStandardGrid* grid = [[self alloc] init];
    grid.nColumn = nCol;
    grid.nRow = nRow;
    return grid;
}

- (instancetype)init
{
    if(self = [super init])
    {
        self.enableRelativePosition = YES;
    }
    return self;
}

- (void)reloadData
{
    if([self.dataSource respondsToSelector:@selector(standardGrid:widthForGridColumn:)] && [self.dataSource respondsToSelector:@selector(standardGrid:heightForGridRow:)] && [self.dataSource respondsToSelector:@selector(standardGrid:elementsForGridIndex:)])
    {
        CGFloat fPosY = 0;
        CGSize gridSize = CGSizeZero;
        float* standardWidthBuffer = malloc(sizeof(float)*_nColumn);
        memset(standardWidthBuffer, 0, sizeof(float)*_nColumn);
        for(NSInteger i = 0; i < _nRow; ++ i)
        {
            CGFloat fPosX = 0;
            CGFloat fH = [self.dataSource standardGrid:self heightForGridRow:i];
            CGFloat fGridW = 0;
            for(NSInteger j = 0; j < _nColumn; ++ j)
            {
                CGFloat fW = standardWidthBuffer[j];
                if(fW == 0)
                {
                    fW = [self.dataSource standardGrid:self widthForGridColumn:j];
                    standardWidthBuffer[j] = fW;
                    fGridW += fW;
                }
                Heqz_ChartGrid* subGrid = [self gridAtIndex:[Heqz_ChartGridCellIndex indexWithRow:i column:j]];
                CGSize sizeGrid = CGSizeMake(fW, fH);
                subGrid.boundRect = CGRectMake(fPosX, fPosY, sizeGrid.width, sizeGrid.height);
                subGrid.arrayContent = [self.dataSource standardGrid:self elementsForGridIndex:subGrid.cellIndex];
                
                fPosX += sizeGrid.width;
            }
            fPosY += fH;
            if(gridSize.width == 0)
            {
                gridSize.width = fGridW;
            }
        }
        gridSize.height = fPosY;
        if([self.delegate respondsToSelector:@selector(standardGrid:getGridSize:)])
        {
            [self.delegate standardGrid:self getGridSize:gridSize];
        }
        
        free(standardWidthBuffer);
    }
}

@end
