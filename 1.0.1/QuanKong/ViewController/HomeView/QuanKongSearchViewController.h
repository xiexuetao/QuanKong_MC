//
//  QuanKongSearchViewController.h
//  QuanKong
//
//  Created by Rick on 14/12/2.
//  Copyright (c) 2014年 Rockcent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "LoadMoreTableFooterView.h"


@interface QuanKongSearchViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,EGORefreshTableHeaderDelegate,LoadMoreTableFooterDelegate,UISearchBarDelegate>

@end
