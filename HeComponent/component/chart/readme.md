/* 
  readme.md
  SinaFinance

  Created by qingzhao on 2018/7/17.
  Copyright © 2018年 qingzhao. All rights reserved.
*/

Heqz_Chart 目录结构

    common 定义了基础数据结构Heqz_ChartRange，工具类Heqz_ChartCommonFunc和公共头文件
    chart 定义了Heqz_Chart的整体关系结构。 Heqz_ChartView包含多个Heqz_ChartChart，Heqz_ChartChart包含多个Heqz_ChartElement
    最终有Heqz_ChartElement进行绘制
    coordinateAxis  定义了坐标轴，包括横向和纵向，继承于element
    element 定义了各种图形元素，使用CGContext进行绘制，继承于element
    animatableElement 定义了各种图形元素，使用CAShapeLayer进行绘制，继承于element
    customView 封装自定义view
    grid 封装了表格，包括通用表格，定制表格和只展示文字的定制表格


Heqz_Chart 使用
    1. Heqz_Chart的图形区域与坐标轴是不同的模块，事例代码
        Heqz_ChartView* chartView = [[Heqz_ChartView alloc] initWithFrame:chartRect disableEffcient:NO];
        ... 设置chartView数据...

        Heqz_ChartView* leftAxis = [[Heqz_ChartView alloc] initWithFrame:leftAxisRect disableEffcient:YES];
        ... 设置leftAxis数据...

        Heqz_ChartView* bottomAxis = [[Heqz_ChartView alloc] initWithFrame:bottomAxisRect disableEffcient:YES];
        ... 设置bottomAxis数据...

    2. Heqz_ChartView 绘制图形有两种方式。使用CGContext和使用CAShapeLayer
        Heqz_ChartView* chartView = [[Heqz_ChartView alloc] initWithFrame:chartRect disableEffcient:NO];
        disableEffcient YES 使用CGContext绘制 // 图表中的元素只能是elemnt中的元素
        disableEffcient NO  使用CAShapeLayer绘制 // 图表中的元素只能是animatableElemnt中的元素

        当前版本坐标轴的绘制只支持CGContext方式绘制
        基本图形绘制两种方式都支持











