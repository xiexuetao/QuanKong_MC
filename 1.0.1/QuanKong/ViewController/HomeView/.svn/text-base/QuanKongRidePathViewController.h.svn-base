//
//  QuanKongRidePathViewController.h
//  QuanKong
//
//  Created by Rick on 14/12/19.
//  Copyright (c) 2014年 Rockcent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"

@interface QuanKongRidePathViewController : UIViewController<UITableViewDelegate,UITableViewDataSource, BMKRouteSearchDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>

@property(nonatomic,assign)CLLocationCoordinate2D fromLC;
@property(nonatomic,retain)BMKReverseGeoCodeResult *fromResult;
@property(nonatomic,retain)BMKLocationService *locService;//开始定位


@property(nonatomic,assign)CLLocationCoordinate2D toLC;
@property(nonatomic,copy)NSString *to_name;
@property(nonatomic,copy)NSString *to_city;

@property(nonatomic,assign)int type;//标识，1：公交，2：的士，3：步行;

@end
