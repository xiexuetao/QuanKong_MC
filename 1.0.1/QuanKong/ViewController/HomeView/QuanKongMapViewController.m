//
//  QuanKongMapViewController.m
//  QuanKong
//
//  Created by POWER on 14/11/3.
//  Copyright (c) 2014年 Rockcent. All rights reserved.
//

#import "QuanKongMapViewController.h"
#import "QuanKongRidePathViewController.h"

@interface QuanKongMapViewController (){
    UIView *bottomView;//底部view
    
    CLLocationCoordinate2D coor;
    CLLocationCoordinate2D from_coor;
    
    BMKLocationService *_locService;
    
    BMKGeoCodeSearch* _geocodesearch;
    
    bool isLocS;
    
    NSString *_name;
    NSString *_address;
}

@end

@implementation QuanKongMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.view.backgroundColor = [UIColor whiteColor];
        
        #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        {
            self.edgesForExtendedLayout = UIRectEdgeNone;
            self.extendedLayoutIncludesOpaqueBars = NO;
            self.modalPresentationCapturesStatusBarAppearance = NO;
        }
        
        #endif
        
    }
    return self;
}

#pragma button selector

- (void)pushBack:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    isLocS = false;
    [super viewDidLoad];
    [self startLocationService];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    couponMapView.delegate = nil;
    _geocodesearch.delegate = nil;
    
}

- (void)setMapViewWith:(float)lat And:(float)lng And:(NSString *)name And:(NSString *)address
{
    
    _name = name;
    _address = address;
    
    couponMapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-80)];
    couponMapView.delegate = self;
    [self.view insertSubview:couponMapView atIndex:1];
    
    _geocodesearch = [[BMKGeoCodeSearch alloc]init];
    _geocodesearch.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    [self searchGeocode];
    
    
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 25, 54, 32)];
    [backButton setImage:[UIImage imageNamed:@"back_btn.png"] forState:UIControlStateNormal];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(7.5, 7.5, 7.5, 7.5)];
    [backButton addTarget:self action:@selector(pushBack:) forControlEvents:UIControlEventTouchUpInside];
    backButton.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8f];
    backButton.alpha = 0.8;
    backButton.layer.cornerRadius = 5.0f;
    backButton.layer.shadowColor = [UIColor blackColor].CGColor;
    backButton.layer.shadowOffset = CGSizeMake(0, 0.5);
    backButton.layer.shadowRadius = 5.0f;
    backButton.layer.shadowOpacity = 0.5f;
    
    [self.view insertSubview:backButton aboveSubview:couponMapView];
    
    bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT-145, WIDTH, 145)];
    bottomView.backgroundColor = [UIColor colorWithRed:250.0/255.0 green:250.0/255.0 blue:250.0/255.0 alpha:1.0];
    bottomView.userInteractionEnabled = YES;
    bottomView.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    bottomView.layer.shadowOffset = CGSizeMake(0, 3);
    bottomView.layer.shadowOpacity = 3.0f;
    
    UILabel *shopNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, WIDTH-20, 30)];
    shopNameLabel.backgroundColor = [UIColor clearColor];
    shopNameLabel.textAlignment = NSTextAlignmentLeft;
    shopNameLabel.textColor = [UIColor darkGrayColor];
    shopNameLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    shopNameLabel.text = name;
    
    UILabel *shopAddressLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 45, WIDTH-20, 20)];
    shopAddressLabel.backgroundColor = [UIColor clearColor];
    shopAddressLabel.textAlignment = NSTextAlignmentLeft;
    shopAddressLabel.textColor = [UIColor lightGrayColor];
    shopAddressLabel.font = [UIFont systemFontOfSize:14.0f];
    shopAddressLabel.text = address;
    
    [bottomView addSubview:shopNameLabel];
    [bottomView addSubview:shopAddressLabel];
    
    UIButton *locationButton = [[UIButton alloc]initWithFrame:CGRectMake(10, self.view.frame.size.height-210, 32, 32)];
    [locationButton setImage:[UIImage imageNamed:@"localtion"] forState:UIControlStateNormal];
    [locationButton setImageEdgeInsets:UIEdgeInsetsMake(7.5, 7.5, 7.5, 7.5)];
    [locationButton addTarget:self action:@selector(clickLocation:) forControlEvents:UIControlEventTouchUpInside];
    locationButton.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8f];
    locationButton.alpha = 0.8;
    locationButton.layer.cornerRadius = 5.0f;
    locationButton.layer.shadowColor = [UIColor blackColor].CGColor;
    locationButton.layer.shadowOffset = CGSizeMake(0, 0.5);
    locationButton.layer.shadowRadius = 5.0f;
    locationButton.layer.shadowOpacity = 0.5f;
    
    [self.view addSubview:locationButton];
    [self createBottomButton];
    
    [self.view insertSubview:bottomView aboveSubview:couponMapView];
}

-(void)searchGeocode
{
    BMKGeoCodeSearchOption *geocodeSearchOption = [[BMKGeoCodeSearchOption alloc]init];
    geocodeSearchOption.city= @"广州";
    geocodeSearchOption.address = _address;
    BOOL flag = [_geocodesearch geoCode:geocodeSearchOption];
    if(flag)
    {
        NSLog(@"geo检索发送成功");
    }
    else
    {
        NSLog(@"geo检索发送失败");
    }
    
}

- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (error == 0) {
        BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
        item.coordinate = result.location;
        item.title = result.address;
        coor.latitude = result.location.latitude;
        coor.longitude = result.location.longitude;
        
         BMKCoordinateRegion viewRegion = BMKCoordinateRegionMake(coor, BMKCoordinateSpanMake(0.001, 0.001));
         BMKCoordinateRegion adjustedRegion = [couponMapView regionThatFits:viewRegion];
         [couponMapView setRegion:adjustedRegion animated:NO];
         [couponMapView setCenterCoordinate:coor];
         
         BMKPointAnnotation *shopAnnotation = [[BMKPointAnnotation alloc]init];
         shopAnnotation.coordinate = coor;
         shopAnnotation.title = _name;
         
         [couponMapView addAnnotation:shopAnnotation];//添加标注
    }
}


-(void)dealloc{
    [_locService stopUserLocationService];
}


/**
 *  移动到指定坐标中心位置
 *
 *  @param but
 */
-(void)clickLocation:(UIButton *) but{
    if (!isLocS) {
        [self moveMapLocation:couponMapView andCC2D:from_coor];
    }
}


-(void)startLocationService{
    //开始定位
    isLocS = true;
    _locService = [[BMKLocationService alloc]init];
    [_locService startUserLocationService];
    _locService.delegate = self;
    couponMapView.showsUserLocation = YES;
}


/**
 *  移动中心位置
 *
 *  @param mapView
 *  @param cc2d
 */
-(void)moveMapLocation:(BMKMapView *)mapView andCC2D:(CLLocationCoordinate2D) cc2d{
    BMKCoordinateRegion viewRegion = BMKCoordinateRegionMake(cc2d, BMKCoordinateSpanMake(0.001, 0.001));
    BMKCoordinateRegion adjustedRegion = [mapView regionThatFits:viewRegion];
    [couponMapView setRegion:adjustedRegion animated:YES];
}


/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserLocation:(BMKUserLocation *)userLocation{
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    isLocS = false;
    from_coor = userLocation.location.coordinate;
//    [self moveMapLocation:couponMapView andCC2D:userLocation.location.coordinate];
    from_coor = userLocation.location.coordinate;
    [couponMapView updateLocationData:userLocation];
    
    couponMapView.showsUserLocation = YES;//显示定位图层
    [couponMapView updateLocationData:userLocation];
}


/**
 *  创建底部按钮
 */
-(void)createBottomButton{
    
    NSArray *title = @[@"公交",@"驾车",@"步行"];
    NSArray *icon = @[@"bus_sel_icon",@"taxi_sel_icon",@"wlak_sel_icon"];

    
    for (int x=0; x<title.count; x++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        button.frame = CGRectMake(WIDTH/3*x+0.5, 95, WIDTH/3-0.5, 50);
        
        [button setBackgroundColor:[UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1]];
        button.tag = 200+x;
        [button addTarget:self action:@selector(clickPattern:) forControlEvents:UIControlEventTouchUpInside];
        
        [button setTitle:title[x] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14.f];
        
        
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, button.frame.size.width/2, 0,25)];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(button.frame.size.width/2-20, 35/2, 15, 15)];
        imageView.image = [UIImage imageNamed:icon[x]];
        [button addSubview:imageView];
        
       UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH/3*x, 100, 0.5, 40)];
        line.backgroundColor = [UIColor colorWithRed:210.0/255.0 green:210.0/255.0 blue:210.0/255.0 alpha:1.0];
        [bottomView addSubview:line];
        
        [bottomView addSubview:button];
    }
}

-(void)clickPattern:(UIButton *) but{
    QuanKongRidePathViewController *ride = [[QuanKongRidePathViewController alloc] init];
    switch (but.tag) {
        case 200:{
            ride.type = 1;
        }
            break;
        case 201:{
            ride.type = 2;
        }
            break;

        case 202:{
            ride.type = 3;
        }
            break;
        default:
            break;
    }
    ride.to_name = _name;
    ride.toLC = coor;
    ride.fromLC = from_coor;
    ride.to_city = _address;
    ride.locService = _locService;
    ride.locService.delegate = ride;
    [self.navigationController pushViewController:ride animated:YES];
}




#pragma mark - BKMapView delegate

- (BMKAnnotationView *)_mapView:(BMKMapView *)_mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        return newAnnotationView;
    }
    return nil;
}

@end
