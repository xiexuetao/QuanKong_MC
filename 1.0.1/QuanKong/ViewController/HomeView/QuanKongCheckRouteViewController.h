//
//  QuanKongCheckRouteViewController.h
//  QuanKong
//
//  Created by Rick on 14/12/23.
//  Copyright (c) 2014年 Rockcent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"

@interface QuanKongCheckRouteViewController : UIViewController<BMKMapViewDelegate,BMKLocationServiceDelegate,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>

@property(nonatomic,strong)BMKRouteLine *routeLine;
@property(nonatomic,strong)BMKLocationService *locService;
@property(nonatomic,assign)int lineType;

@property(nonatomic,assign)CLLocationCoordinate2D userLocat;

@property(nonatomic,copy)NSString *titleText;
@property(nonatomic,copy)NSString *detaiText;

@end
