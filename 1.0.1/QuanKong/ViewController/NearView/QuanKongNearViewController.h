//
//  QuanKongNearViewController.h
//  QuanKong
//
//  Created by POWER on 14-9-16.
//  Copyright (c) 2014年 Rockcent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMKLocationService.h"
#import "BMKGeocodeSearch.h"
#import "LoadMoreTableFooterView.h"
#import "UIImageView+WebCache.h"

#import "couponLIstViewCell.h"
#import "HTTPTool.h"
#import "QuanKongVoucher.h"

@interface QuanKongNearViewController : UIViewController<BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,LoadMoreTableFooterDelegate,UITableViewDelegate,UITableViewDataSource>
{
    BMKLocationService *_locService;
    BMKGeoCodeSearch *_geocodesearch;
}

@property (strong, nonatomic) UIView *locationBar_Bg;

@property (strong, nonatomic) UILabel *locationLB;

@property (strong, nonatomic) UIButton *relocationBtn;

@property (strong, nonatomic) UITableView *nearCouponTableView;

@end
