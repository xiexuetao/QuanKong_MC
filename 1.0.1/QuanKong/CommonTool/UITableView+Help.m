//
//  UITableView+Help.m
//  QuanKong
//
//  Created by Rick on 14/12/11.
//  Copyright (c) 2014年 Rockcent. All rights reserved.
//

#import "UITableView+Help.h"

@implementation UITableView (Help)

/**
 *  隐藏多余分割线
 *
 *  @param tableView 需要隐藏分割线的tableview
 */
+ (void)setExtraCellLineHidden: (UITableView *)tableView{
    
    UIView *view =[ [UIView alloc]init];
    
    view.backgroundColor = [UIColor clearColor];
    
    [tableView setTableFooterView:view];
    
    [tableView setTableHeaderView:view];
}


@end
