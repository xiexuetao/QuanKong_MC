//
//  QuanKongCheckRouteViewController.m
//  QuanKong
//
//  Created by Rick on 14/12/23.
//  Copyright (c) 2014年 Rockcent. All rights reserved.
//
#define MYBUNDLE_NAME @ "mapapi.bundle"
#define MYBUNDLE_PATH [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: MYBUNDLE_NAME]
#define MYBUNDLE [NSBundle bundleWithPath: MYBUNDLE_PATH]

#import "QuanKongCheckRouteViewController.h"
#import "BMKMapView.h"

@interface UIImage(InternalMethod)

- (UIImage*)imageRotatedByDegrees:(CGFloat)degrees;

@end

@implementation UIImage(InternalMethod)

- (UIImage*)imageRotatedByDegrees:(CGFloat)degrees
{
    
    CGFloat width = CGImageGetWidth(self.CGImage);
    CGFloat height = CGImageGetHeight(self.CGImage);
    
    CGSize rotatedSize;
    
    rotatedSize.width = width;
    rotatedSize.height = height;
    
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    CGContextRotateCTM(bitmap, degrees * M_PI / 180);
    CGContextRotateCTM(bitmap, M_PI);
    CGContextScaleCTM(bitmap, -1.0, 1.0);
    CGContextDrawImage(bitmap, CGRectMake(-rotatedSize.width/2, -rotatedSize.height/2, rotatedSize.width, rotatedSize.height), self.CGImage);
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end

@interface RouteAnnotation : BMKPointAnnotation
{
    int _type; ///<0:起点 1：终点 2：公交 3：地铁 4:驾乘 5:途经点
    int _degree;
}

@property (nonatomic) int type;
@property (nonatomic) int degree;
@end

@implementation RouteAnnotation

@synthesize type = _type;
@synthesize degree = _degree;
@end

@interface QuanKongCheckRouteViewController (){
    BMKMapView *_mapView;
    UIView *lineView;
    
    UITableView *_mTableView;
    NSMutableArray *_stepDatas;
    NSMutableArray *_stepTypes;
    
    NSString *_sectionTitle;
    NSString *_detailText;
    
    float netTranslation;
    
    BOOL isButOpen;
    
    NSThread* myThread;
    BOOL isStart;
}

@end

@implementation QuanKongCheckRouteViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _stepDatas = [NSMutableArray array];
    _stepTypes = [NSMutableArray array];
    isButOpen = false;
    
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
    
    
    [self checkTheRoute];
    [self createTabelView];
    
    
    self.title = @"路线导航";
    
    [self createBackBut];
}

- (void)viewWillAppear:(BOOL)animated
{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [self startLocationService];
    isStart = YES;
    [self click];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}


-(void)createBackBut{
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
    
    [self.view insertSubview:backButton aboveSubview:_mapView];
    
    
    UIButton *locationButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-10-32, 25, 32, 32)];
    [locationButton setImage:[UIImage imageNamed:@"localtion"] forState:UIControlStateNormal];
    [locationButton setImageEdgeInsets:UIEdgeInsetsMake(7.5, 7.5, 7.5, 7.5)];
    [locationButton addTarget:self action:@selector(startLocationService) forControlEvents:UIControlEventTouchUpInside];
    locationButton.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8f];
    locationButton.alpha = 0.8;
    locationButton.layer.cornerRadius = 5.0f;
    locationButton.layer.shadowColor = [UIColor blackColor].CGColor;
    locationButton.layer.shadowOffset = CGSizeMake(0, 0.5);
    locationButton.layer.shadowRadius = 5.0f;
    locationButton.layer.shadowOpacity = 0.5f;
    
    [self.view addSubview:locationButton];
}


-(void)createTabelView{
    
    lineView = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT-60, WIDTH, HEIGHT/2)];
    lineView.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 55)];
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    panGesture.delegate = self;
    [headerView addGestureRecognizer:panGesture];

    
    UITapGestureRecognizer *recognizerTop = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleFingerEvent:)];
    recognizerTop.numberOfTouchesRequired = 1;
    recognizerTop.numberOfTapsRequired = 1;
    recognizerTop.delegate = self;
    [headerView addGestureRecognizer:recognizerTop];

    
    
    UIButton *headerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    headerButton.frame = CGRectMake(0, 0, 60, 12);
    headerButton.center = CGPointMake(WIDTH/2, 6);
    [headerButton setBackgroundImage:[UIImage imageNamed:@"header_but"] forState:UIControlStateNormal];
    [headerButton addGestureRecognizer:recognizerTop];
    
    UITextField *titleText = [[UITextField alloc] initWithFrame:CGRectMake(20, 15, WIDTH, 20)];
    titleText.text = self.titleText;
    titleText.font = [UIFont systemFontOfSize:14.f];
    titleText.textColor = [UIColor darkTextColor];
    titleText.userInteractionEnabled = NO;
    
    UITextField *dicText = [[UITextField alloc] initWithFrame:CGRectMake(20, 35, WIDTH, 20)];
    dicText.text = self.detaiText;
    dicText.font = [UIFont systemFontOfSize:12.f];
    dicText.textColor = [UIColor darkGrayColor];
    dicText.userInteractionEnabled = NO;
    
    [headerView addSubview:headerButton];
    [headerView addSubview:titleText];
    [headerView addSubview:dicText];
    
    [lineView addSubview:headerView];

    
    _mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, WIDTH, HEIGHT/2-60) style:UITableViewStylePlain];
    _mTableView.dataSource = self;
    _mTableView.delegate = self;
    _mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mTableView.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
    [lineView addSubview:_mTableView];
    [self.view insertSubview:lineView atIndex:1];
    
}


-(void)handleSwipeFrom:(UIGestureRecognizer *)recognizer{
    CGPoint translation=[(UIPanGestureRecognizer*)recognizer translationInView:lineView];
    MyLog(@"%f_%f",translation.x,translation.y);
    
    float viewLation;
    isButOpen == true?viewLation=HEIGHT/2+translation.y:viewLation=HEIGHT/2-translation.y;
    
    
    if (viewLation>HEIGHT/2) {
        isButOpen == true?viewLation=HEIGHT/2+translation.y:viewLation=HEIGHT-60+translation.y;
        lineView.frame = CGRectMake(0, viewLation, WIDTH, HEIGHT/2);
        isButOpen == true?netTranslation=netTranslation+translation.y:netTranslation=netTranslation-translation.y;
        if(recognizer.state==UIGestureRecognizerStateEnded){
            if (translation.y>30 ||translation.y<-30) {
                NSLog(@"------------------>>%f",translation.y);
                netTranslation = 0;
                [self click];
            }else{
                isButOpen == true?isButOpen=false:isButOpen=true;
                [self click];
            }
        }
    }
}


- (void)handleSingleFingerEvent:(UITapGestureRecognizer *)sender
{
    if (sender.numberOfTapsRequired == 1) {
        [self click];
    }
}

-(void)click{
    if (isButOpen) {
        myThread = [[NSThread alloc] initWithTarget:self
                                                     selector:@selector(downAnimate)
                                                       object:nil];
        [myThread start];
    }else{
        myThread = [[NSThread alloc] initWithTarget:self
                                           selector:@selector(upAnimate)
                                             object:nil];
        [myThread start];
    }

}


- (void)downAnimate {
    isButOpen = false;
    [UIView animateWithDuration:0.25 animations:^{
        lineView.frame = CGRectMake(0, HEIGHT-60, WIDTH, HEIGHT/2);
    } completion:^(BOOL finished) {
        
    }];
}

-(void)upAnimate{
    isButOpen = true;
    if (isStart == YES) {
        [NSThread sleepForTimeInterval:0.8];
        isStart = NO;
    }
    [UIView animateWithDuration:0.25 animations:^{
        lineView.frame = CGRectMake(0, HEIGHT/2, WIDTH, HEIGHT/2);
    } completion:^(BOOL finished) {
        
    }];
}

-(void)startLocationService{
    [self moveMapLocation:_mapView andCC2D:self.userLocat];
}

/**
 *  移动中心位置
 *
 *  @param mapView
 *  @param cc2d
 */
-(void)moveMapLocation:(BMKMapView *)mapView andCC2D:(CLLocationCoordinate2D) cc2d{
    BMKCoordinateRegion viewRegion = BMKCoordinateRegionMake(cc2d, BMKCoordinateSpanMake(0.03, 0.03));
    BMKCoordinateRegion adjustedRegion = [mapView regionThatFits:viewRegion];
    [_mapView setRegion:adjustedRegion animated:YES];
//    [_mapView setCenterCoordinate:cc2d];
}


/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserLocation:(BMKUserLocation *)userLocation{
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    
    [_mapView updateLocationData:userLocation];
    self.userLocat = userLocation.location.coordinate;
//    [_locService stopUserLocationService];
    
//    [self moveMapLocation:_mapView andCC2D:userLocation.location.coordinate];
    
    _mapView.showsUserLocation = YES;
    [_mapView updateLocationData:userLocation];
}


-(void)checkTheRoute{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    
    [_mapView removeOverlays:array];
    
    if (_lineType == 1) {
        BMKTransitRouteLine* plan = (BMKTransitRouteLine *)self.routeLine;
        
        int size = [plan.steps count];
        int planPointCounts = 0;
        for (int i = 0; i < size; i++) {
            BMKTransitStep* transitStep = [plan.steps objectAtIndex:i];
            
            if(i==0){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.starting.location;
        
                [self moveMapLocation:_mapView andCC2D:plan.starting.location];

                item.title = @"起点";
                item.type = 0;
                [_mapView addAnnotation:item]; // 添加起点标注
                
            }else if(i==size-1){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.terminal.location;
                item.title = @"终点";
                item.type = 1;
                [_mapView addAnnotation:item]; // 添加起点标注
            }
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = transitStep.entrace.location;
            item.title = transitStep.instruction;
            item.type = 3;
            [_mapView addAnnotation:item];
            planPointCounts += transitStep.pointsCount;
        }
        
        BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKTransitStep* transitStep = [plan.steps objectAtIndex:j];
            int k=0;
            for(k=0;k<transitStep.pointsCount;k++) {
                temppoints[i].x = transitStep.points[k].x;
                temppoints[i].y = transitStep.points[k].y;
                i++;
            }
            
        }
        BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
        [_mapView addOverlay:polyLine];
        delete []temppoints;
        
        
        NSMutableString *stepsTitle = [NSMutableString string];
       NSArray *steps = plan.steps;
       BMKTime *time = plan.duration;
       long distance = plan.distance;
       NSString *lineTitle = plan.title;
       for (BMKTransitStep *transitStep in steps) {
            NSLog(@"%@________%@",transitStep.vehicleInfo.title,transitStep.instruction);
           [_stepTypes addObject:transitStep];
            [_stepDatas addObject:transitStep.instruction];
            
            if (transitStep.vehicleInfo.title) {
                if (stepsTitle.length == 0) {
                    [stepsTitle appendString:transitStep.vehicleInfo.title];
                }else{
                    [stepsTitle appendFormat:@"-%@",transitStep.vehicleInfo.title];
                }
            }
        }
        _sectionTitle = stepsTitle;
        bool boolean = time.hours==0?true:false;
        
        NSString *format = time.hours==0?@"%i分钟 | %0.1f公里":@"%i小时%i分钟 | %0.1f公里";
        
        if (boolean) {
            _detailText = [NSString stringWithFormat:format,time.minutes,distance/1000.f];
        }else{
            _detailText = [NSString stringWithFormat:format,time.hours,time.minutes,distance/1000.f];
        }

    }else if (_lineType == 2){
        
        BMKDrivingRouteLine* plan = (BMKDrivingRouteLine *)self.routeLine;
        // 计算路线方案中的路段数目
        int size = [plan.steps count];
        int planPointCounts = 0;
        for (int i = 0; i < size; i++) {
            BMKDrivingStep* transitStep = [plan.steps objectAtIndex:i];
            BMKTime *time = plan.duration;
            long distance = plan.distance;
            
            [_stepDatas addObject:transitStep.instruction];
            
            _sectionTitle = transitStep.instruction;
            
            bool boolean = time.hours==0?true:false;
            
            NSString *format = time.hours==0?@"%i分钟 | %0.1f公里":@"%i小时%i分钟 | %0.1f公里";
            
            if (boolean) {
                _detailText = [NSString stringWithFormat:format,time.minutes,distance/1000.f];
            }else{
                _detailText = [NSString stringWithFormat:format,time.hours,time.minutes,distance/1000.f];
            }

            
            if(i==0){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.starting.location;
                item.title = @"起点";
                item.type = 0;
                [_mapView addAnnotation:item]; // 添加起点标注
                
            }else if(i==size-1){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.terminal.location;
                item.title = @"终点";
                item.type = 1;
                [_mapView addAnnotation:item]; // 添加起点标注
            }
            
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = transitStep.entrace.location;
            item.title = transitStep.entraceInstruction;
            MyLog(@"%@",item.title);
            item.degree = transitStep.direction * 30;
            item.type = 4;
            [_mapView addAnnotation:item];
            
            planPointCounts += transitStep.pointsCount;
        }
        
        if (plan.wayPoints) {
            for (BMKPlanNode* tempNode in plan.wayPoints) {
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item = [[RouteAnnotation alloc]init];
                item.coordinate = tempNode.pt;
                item.type = 5;
                item.title = tempNode.name;
                [_mapView addAnnotation:item];
            }
        }
        
        BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKDrivingStep* transitStep = [plan.steps objectAtIndex:j];
            int k=0;
            for(k=0;k<transitStep.pointsCount;k++) {
                temppoints[i].x = transitStep.points[k].x;
                temppoints[i].y = transitStep.points[k].y;
                i++;
            }
            
        }
        
        BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
        [_mapView addOverlay:polyLine];
        delete []temppoints;
        
    }else if (_lineType == 3){
        BMKWalkingRouteLine* plan = (BMKWalkingRouteLine *)self.routeLine;
        int size = [plan.steps count];
        int planPointCounts = 0;
        for (int i = 0; i < size; i++) {
            BMKWalkingStep* transitStep = [plan.steps objectAtIndex:i];
            BMKTime *time = plan.duration;
            long distance = plan.distance;
            
            [_stepDatas addObject:transitStep.instruction];
            
            _sectionTitle = transitStep.instruction;
            
            bool boolean = time.hours==0?true:false;
            
            NSString *format = time.hours==0?@"%i分钟 | %0.1f公里":@"%i小时%i分钟 | %0.1f公里";
            
            if (boolean) {
                _detailText = [NSString stringWithFormat:format,time.minutes,distance/1000.f];
            }else{
                _detailText = [NSString stringWithFormat:format,time.hours,time.minutes,distance/1000.f];
            }
            
            if(i==0){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.starting.location;
                item.title = @"起点";
                item.type = 0;
                [_mapView addAnnotation:item];
                
            }else if(i==size-1){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.terminal.location;
                item.title = @"终点";
                item.type = 1;
                [_mapView addAnnotation:item];
            }
            
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = transitStep.entrace.location;
            item.title = transitStep.entraceInstruction;
            item.degree = transitStep.direction * 30;
            item.type = 4;
            [_mapView addAnnotation:item];
            planPointCounts += transitStep.pointsCount;
        }
        
        BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKWalkingStep* transitStep = [plan.steps objectAtIndex:j];
            int k=0;
            for(k=0;k<transitStep.pointsCount;k++) {
                temppoints[i].x = transitStep.points[k].x;
                temppoints[i].y = transitStep.points[k].y;
                i++;
            }
            
        }
        
        BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
        [_mapView addOverlay:polyLine];
        delete []temppoints;
    }
}

- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[RouteAnnotation class]]) {
        return [self getRouteAnnotationView:view viewForAnnotation:(RouteAnnotation*)annotation];
    }
    return nil;
}

- (BMKAnnotationView*)getRouteAnnotationView:(BMKMapView *)mapview viewForAnnotation:(RouteAnnotation*)routeAnnotation
{
    BMKAnnotationView* view = nil;
    switch (routeAnnotation.type) {
        case 0:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"start_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"start_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath:@"images/icon_nav_start.png"]];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 1:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"end_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"end_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath:@"images/icon_nav_end.png"]];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 2:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"bus_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"bus_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath:@"images/icon_nav_bus.png"]];
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 3:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"rail_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"rail_node"];
                view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath:@"images/icon_nav_rail.png"]];
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 4:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"route_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"route_node"];
                view.canShowCallout = TRUE;
            } else {
                [view setNeedsDisplay];
            }
            
            UIImage* image = [UIImage imageWithContentsOfFile:[self getMyBundlePath:@"images/icon_direction.png"]];
            view.image = [image imageRotatedByDegrees:routeAnnotation.degree];
            view.annotation = routeAnnotation;
            
        }
            break;
        case 5:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"waypoint_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"waypoint_node"];
                view.canShowCallout = TRUE;
            } else {
                [view setNeedsDisplay];
            }
            
            UIImage* image = [UIImage imageWithContentsOfFile:[self getMyBundlePath:@"images/icon_nav_waypoint.png"]];
            view.image = [image imageRotatedByDegrees:routeAnnotation.degree];
            view.annotation = routeAnnotation;
        }
            break;
        default:
            break;
    }
    
    return view;
}


- (BMKOverlayView*)mapView:(BMKMapView *)map viewForOverlay:(id<BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.fillColor = [[UIColor cyanColor] colorWithAlphaComponent:1];
        polylineView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.7];
        polylineView.lineWidth = 3.0;
        return polylineView;
    }
    return nil;
}


/**
 *  导航栏按钮放回处理事件
 *
 *  @param sender 弹出
 */
-(void)pushBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


///**
// *  移动中心位置
// *
// *  @param mapView
// *  @param cc2d
// */
//-(void)moveMapLocation:(BMKMapView *)mapView2 andCC2D:(CLLocationCoordinate2D) cc2d{
//    BMKCoordinateRegion viewRegion = BMKCoordinateRegionMake(cc2d, BMKCoordinateSpanMake(0.001, 0.001));
//    BMKCoordinateRegion adjustedRegion = [mapView2 regionThatFits:viewRegion];
//    [mapView2 setRegion:adjustedRegion animated:NO];
//    [mapView2 setCenterCoordinate:cc2d];
//}


/**
 *  查找文件
 *
 *  @param filename
 *
 *  @return
 */
- (NSString*)getMyBundlePath:(NSString *)filename
{
    
    NSBundle * libBundle = MYBUNDLE ;
    if ( libBundle && filename ){
        NSString * s=[[libBundle resourcePath ] stringByAppendingPathComponent : filename];
        return s;
    }
    return nil ;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _stepDatas.count;
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"Check_Route_Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    UIImageView *imgView;
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.imageView.image = [UIImage imageNamed:@"cell_image"];
        imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
        [cell.imageView addSubview:imgView];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSString *strpText = _stepDatas[indexPath.row];
    [cell.textLabel setNumberOfLines:0];
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    UIFont *font = [UIFont systemFontOfSize:14.f];
    CGSize size = CGSizeMake(WIDTH,2000);
    CGSize labelsize = [strpText sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    CGPoint cellPoint = cell.textLabel.frame.origin;
    cell.textLabel.frame = CGRectMake(cellPoint.x,cellPoint.y,labelsize.width, labelsize.height);
    cell.textLabel.textColor = [UIColor darkGrayColor];
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithData:[_stepDatas[indexPath.row] dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0, attrStr.length)];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.0f] range:NSMakeRange(0, attrStr.length)];
    
//    cell.contentLabel.attributedText = attrStr;
    
    cell.textLabel.attributedText = attrStr;
    
    
    UIImage *img;
    if(self.lineType == 1){
        BMKTransitStep *transitStep = _stepTypes[indexPath.row];
        switch (transitStep.stepType) {
            case BMK_BUSLINE:
                img = [UIImage imageNamed:@"bus_icon"];
                break;
            case BMK_SUBWAY:
                img = [UIImage imageNamed:@"bus_icon"];
                break;
            default:
                img = [UIImage imageNamed:@"wlak_icon"];
                break;
        }
    }else if (self.lineType == 2){
        img = [UIImage imageNamed:@"taxi_icon"];
    }else if(self.lineType == 3){
        img = [UIImage imageNamed:@"wlak_icon"];
    }
    
    imgView.image = img;
    
    cell.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
    
    return cell;
}

@end
