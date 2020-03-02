//
//  SFChartGridView.m
//  SinaFinance
//
//  Created by qingzhao on 2018/5/24.
//  Copyright © 2018年 qingzhao. All rights reserved.
//

#import "SFChartGridView.h"

@interface SFChartGridView()

@property(nonatomic, strong)SFChartChart* chart;

@end

@implementation SFChartGridView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame grid:nil];
}

- (instancetype)initWithFrame:(CGRect)frame grid:(SFChartGrid*)grid
{
    if(self = [super initWithFrame:frame disableEffcient:NO])
    {
        if(!grid)
        {
            self.grid = [SFChartGrid grid];
        }
        self.layer.masksToBounds = NO;
    }
    return self;
}

- (SFChartChart *)chart
{
    if(!_chart)
    {
        _chart = [SFChartChart chartWithRangeH:SFChartRangeMake(0, self.bounds.size.width) rangeV:SFChartRangeMake(self.bounds.size.height, 0)];
        [self addChart:_chart];
    }
    return _chart;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    self.chart.rangeH = SFChartRangeMake(0, self.bounds.size.width);
    self.chart.rangeV = SFChartRangeMake(self.bounds.size.height, 0);
}

- (void)showGridData
{
    self.layer.sublayers = nil;
    [self.chart clearElements];
    [self.grid addElementsWithChart:self.chart];
    [super showChartData];
}

- (void)setGrid:(SFChartGrid*)grid
{
    _grid = grid;
    if(CGRectEqualToRect(grid.boundRect, CGRectZero))
    {
        grid.boundRect = self.bounds;
    }
}

- (void)removeGridData
{
    [self.chart clearElements];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    UITouch* touch = [touches anyObject];
    CGPoint pt = [touch locationInView:self];
    SFChartGrid* gridCell = [self.grid gridCellWithLocation:pt];
    if(gridCell.selectGridCell){
        gridCell.selectGridCell(pt);
        return ;
    }
    if(gridCell && [self.gridDelegate respondsToSelector:@selector(chartGridView:selectGridCell:withLocation:)]){
        [self.gridDelegate chartGridView:self selectGridCell:gridCell withLocation:pt];
    }
}

@end
