//
//  QuanKongRidePathViewController.m
//  QuanKong
//
//  Created by Rick on 14/12/19.
//  Copyright (c) 2014年 Rockcent. All rights reserved.
//

#import "QuanKongRidePathViewController.h"
#import "QuanKongCheckRouteViewController.h"
#import "LoadingHUDView.h"
#import "Prompt.h"

@interface QuanKongRidePathViewController (){
    UITableView *_resultView;
    NSArray *_busData;
    NSArray *_taxiData;
    NSArray *_wlakData;
    
    BMKRouteSearch *_routesearch;//乘坐路线
    BMKGeoCodeSearch *_geocodesearch;//反geo检索
    
    NSMutableArray *_titleArr;
    NSMutableArray *_detaiArr;
    
    
    bool isSearch;
    bool isGeoSearch;
    UIView *_subView;
    UIView *_lineView;
    
    NSArray *_title;
    NSArray *_icon;
    NSArray *_icon_sel;
    UIButton *_selBut;
}
@end



@implementation QuanKongRidePathViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    isSearch = false;
    _busData = [NSArray array];
    _taxiData = [NSArray array];
    _wlakData = [NSArray array];
    _titleArr = [NSMutableArray array];
    _detaiArr = [NSMutableArray array];
    
    _title = @[@"公交",@"驾车",@"步行"];
    _icon = @[@"bus_icon",@"taxi_icon",@"wlak_icon"];
    _icon_sel = @[@"bus_sel_icon",@"taxi_sel_icon",@"wlak_sel_icon"];
    
    self.navigationItem.title = @"查看路线";
    
    _subView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 142)];
    _subView.backgroundColor = [UIColor colorWithRed:241/255 green:241/255 blue:241/255 alpha:241/255];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 142, WIDTH, HEIGHT-180)];
    
    [self.view addSubview:_subView];
    [self.view addSubview:_lineView];
    
    [self createSearchConditionView];
    [self createBackBut];

    _routesearch = [[BMKRouteSearch alloc]init];
    _geocodesearch = [[BMKGeoCodeSearch alloc]init];
    _geocodesearch.delegate = self;
    
    
    
//    [self startLocationService];
    [self startReverseGeocode];
    [LoadingHUDView showLoadinginView:self.view AndFrame:_lineView.frame AndString:@"加载中···"];
}

-(void)createBackBut{
    //加入返回按钮
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 46, 22)];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back_btn.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(pushBack:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItemButton = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backItemButton];
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



-(void)createSearchConditionView{
    
    UIImageView *fromIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"position"]];
    fromIcon.frame = CGRectMake(14.2, 14.2, 9, 15.6);
    
    UIImageView *toIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"from"]];
    toIcon.frame = CGRectMake(17.5, 61.5, 9, 9);
    
    UITextField *from = [[UITextField alloc] initWithFrame:CGRectMake(44, 0, WIDTH/2, 44)];
    from.textColor = [UIColor darkGrayColor];
    from.font = [UIFont systemFontOfSize:14.f];
    from.text = @"我的位置";
    from.userInteractionEnabled = NO;
    
    UITextField *to = [[UITextField alloc] initWithFrame:CGRectMake(44, 44, WIDTH-50, 44)];
    to.textColor = [UIColor lightGrayColor];
    to.text = self.to_name;
    MyLog(@"%@",self.to_name);
    to.font = [UIFont systemFontOfSize:14.f];
    [to setUserInteractionEnabled:NO];
    
    [self createBottomButton];
    
    UIImageView *line1 = [[UIImageView alloc] initWithFrame:CGRectMake(44, 44, WIDTH/2, 0.5)];
    line1.backgroundColor = [UIColor colorWithRed:210.0/255.0 green:210.0/255.0 blue:210.0/255.0 alpha:1.0];
    UIImageView *line2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 88, WIDTH, 0.5)];
    line2.backgroundColor = [UIColor colorWithRed:210.0/255.0 green:210.0/255.0 blue:210.0/255.0 alpha:1.0];
    UIImageView *line3 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 139, WIDTH, 0.5)];
    line3.backgroundColor = [UIColor colorWithRed:210.0/255.0 green:210.0/255.0 blue:210.0/255.0 alpha:1.0];
    
    [_subView addSubview:fromIcon];
    [_subView addSubview:line1];
    [_subView addSubview:toIcon];
    [_subView addSubview:from];
    [_subView addSubview:to];
    [_subView addSubview:line2];
    [_subView addSubview:line3];
}

-(void)createBottomButton{
    for (int x=0; x<_title.count; x++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(x*WIDTH/3, 88, WIDTH/3, 50);
        button.tag = x+1;
        [button addTarget:self action:@selector(clickPattern:) forControlEvents:UIControlEventTouchUpInside];
        
        button.backgroundColor = [UIColor whiteColor];
        
        [button setTitle:_title[x] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, button.frame.size.width/2, 0,25)];
        
        UIImageView *lineIv = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH/3-1, 5, 0.5, 43)];
        lineIv.backgroundColor = [UIColor colorWithRed:210.0/255.0 green:210.0/255.0 blue:210.0/255.0 alpha:1.0];
        [button addSubview:lineIv];
        
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(button.frame.size.width/2-20, 35/2, 15, 15)];
        image.image = [UIImage imageNamed:_icon[x]];
        [button addSubview:image];
        if (_type==x+1) {
            _selBut = button;
            image.image = [UIImage imageNamed:_icon_sel[x]];
        }else{
            image.image = [UIImage imageNamed:_icon[x]];
        }
        
        image.tag = 110;
        
        [_subView addSubview:button];
    }
}

-(void)clickPattern:(UIButton *) but{
    [_titleArr removeAllObjects];
    [_detaiArr removeAllObjects];
    
    if (_type!=but.tag) {
        UIImageView *imageView = (UIImageView *)[but viewWithTag:110];
        imageView.image = [UIImage imageNamed:_icon_sel[but.tag-1]];
        
        UIImageView *selImageV = (UIImageView *)[_selBut viewWithTag:110];
        selImageV.image = [UIImage imageNamed:_icon[_selBut.tag-1]];
        
        _selBut = but;
        _type = but.tag;
    }
    
    if (!isSearch) {
        [LoadingHUDView showLoadinginView:self.view AndFrame:_lineView.frame AndString:@"加载中···"];
        [self startReverseGeocode];
    }
}

-(void)createResultView{
    if (!_resultView) {
        _resultView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, _lineView.frame.size.height) style:UITableViewStyleGrouped];
        _resultView.delegate = self;
        _resultView.dataSource = self;
        _resultView.separatorColor = [UIColor clearColor];

        [_lineView addSubview:_resultView];
    }else{
        [_resultView reloadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(void)takeWayData{
    if (!isSearch) {
        switch (_type) {
            case 2:{
                [self driveSearch];
            }
                break;
            case 3:{
                [self walkSearch];
            }
                break;
            default:{
                [self busSearch];
            }
                break;
        }
    }
}


-(void)busSearch{
    isSearch = true;
    BMKPlanNode* start = [[BMKPlanNode alloc]init];
    start.pt = self.fromLC;
    start.name = self.fromResult.address;
    start.cityName = self.fromResult.addressDetail.city;
    BMKPlanNode* end = [[BMKPlanNode alloc]init];
    end.pt = self.toLC;
    end.name = self.to_name;
    end.cityName = self.to_city;
    
    BMKTransitRoutePlanOption *transitRouteSearchOption = [[BMKTransitRoutePlanOption alloc]init];
    transitRouteSearchOption.city= self.fromResult.addressDetail.city;
    transitRouteSearchOption.from = start;
    transitRouteSearchOption.to = end;
    BOOL flag = [_routesearch transitSearch:transitRouteSearchOption];
    
    if(flag){
        NSLog(@"bus检索发送成功");
    }else{
        isSearch = false;
        [self showPromptHideLoading];
        NSLog(@"bus检索发送失败");
    }
}


-(void)walkSearch{
    isSearch = true;
    BMKPlanNode* start = [[BMKPlanNode alloc]init];
    start.pt = self.fromLC;
    start.name = self.fromResult.address;
    start.cityName = self.fromResult.addressDetail.city;
    BMKPlanNode* end = [[BMKPlanNode alloc]init];
    end.pt = self.toLC;
    end.name = self.to_name;
    end.cityName = self.to_city;
    
    
    BMKWalkingRoutePlanOption *walkingRouteSearchOption = [[BMKWalkingRoutePlanOption alloc]init];
    walkingRouteSearchOption.from = start;
    walkingRouteSearchOption.to = end;
    BOOL flag = [_routesearch walkingSearch:walkingRouteSearchOption];
    
    if(flag)
    {
        NSLog(@"walk检索发送成功");
    }
    else
    {
        isSearch = false;
        [self showPromptHideLoading];
        NSLog(@"walk检索发送失败");
    }
    
}

-(void)driveSearch{
    isSearch = true;
    BMKPlanNode* start = [[BMKPlanNode alloc]init];
    start.pt = self.fromLC;
    start.name = self.fromResult.address;
    start.cityName = self.fromResult.addressDetail.city;
    
    BMKPlanNode* end = [[BMKPlanNode alloc]init];
    end.pt = self.toLC;
    end.name = self.to_name;
    end.cityName = self.to_city;
    
    BMKDrivingRoutePlanOption *drivingRouteSearchOption = [[BMKDrivingRoutePlanOption alloc]init];
    drivingRouteSearchOption.from = start;
    drivingRouteSearchOption.to = end;
    BOOL flag = [_routesearch drivingSearch:drivingRouteSearchOption];

    if(flag)
    {
        NSLog(@"car检索发送成功");
    }
    else
    {
        isSearch = false;
        [self showPromptHideLoading];
        NSLog(@"car检索发送失败");
    }
    
}


-(void)startLocationService{
    //开始定位
    _locService = [[BMKLocationService alloc]init];
    [_locService startUserLocationService];
    _locService.delegate = self;
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserLocation:(BMKUserLocation *)userLocation{
//    [_locService stopUserLocationService];
    
//    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);

    self.fromLC = userLocation.location.coordinate;
    
//    [self startReverseGeocode];
    
}



/**
 *  反geo检索
 */
-(void)startReverseGeocode
{
    isGeoSearch = true;
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = self.fromLC;
    BOOL flag = [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
    NSLog(@"didUpdateUserLocation lat %f,long %f",self.fromLC.latitude,self.fromLC.longitude);
    if(flag){
        NSLog(@"反geo检索发送成功");
    }else{
        isSearch = false;
        [self showPromptHideLoading];
        NSLog(@"反geo检索发送失败");
    }
}



-(void)viewWillAppear:(BOOL)animated {
    _routesearch.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    self.view.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
}

-(void)viewWillDisappear:(BOOL)animated {
    _routesearch.delegate = nil; // 不用时，置nil
}


#pragma mark - 检索代理方法
/**
 *返回公交搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结果，类型为BMKTransitRouteResult
 *@param error 错误号，@see BMKSearchErrorCode
 */
- (void)onGetTransitRouteResult:(BMKRouteSearch*)searcher result:(BMKTransitRouteResult*)result errorCode:(BMKSearchErrorCode)error{
    _busData = result.routes;
    [self viewProcessing:_busData];
}


- (void)onGetWalkingRouteResult:(BMKRouteSearch*)searcher result:(BMKWalkingRouteResult*)result errorCode:(BMKSearchErrorCode)error{
    _wlakData = result.routes;
    [self viewProcessing:_wlakData];
}

- (void)onGetDrivingRouteResult:(BMKRouteSearch*)searcher result:(BMKDrivingRouteResult*)result errorCode:(BMKSearchErrorCode)error{
    _taxiData = result.routes;
    [self viewProcessing:_taxiData];
}


-(void)viewProcessing:(NSArray *)arr{
    isSearch = false;
    if (arr.count == 0) {
        [self showPromptHideLoading];
    }else{
        [self createResultView];
        [self hidePromptAndLoading];
    }
}


-(void)showPromptHideLoading{
    [Prompt showPromptWihtView:_lineView message:@"没有找到适合的路线，请尝试其他方式"];
    [LoadingHUDView hideLoadingView];
    [_resultView reloadData];
}

-(void)hidePromptAndLoading{
    [LoadingHUDView hideLoadingView];
    [Prompt removerPromptViewWithView:_lineView animated:YES];
}

#pragma mark-BMKGeoCodeSearchDelegate
/**
 *  反地理编码请求成功后回调传递位置
 *
 *
 */
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    isGeoSearch = false;
    if (error == 0) {
        NSLog(@"%@",result.address);
        NSLog(@"%@",result.addressDetail.city);
        self.fromResult = result;
        [self takeWayData];
    }
}



#pragma mark - delegate and dataSource method
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    switch (_type) {
        case 2:{
            return _taxiData.count;
        }
            break;
        case 3:{
            return _wlakData.count;
        }
            break;
        default:{
            return _busData.count;
        }
            break;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}

#pragma mark 每当有一个cell进入视野范围内就会调用，返回当前这行显示的cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //0.用static修饰局部变量，只会初始化一次
    NSString *ID = [NSString stringWithFormat:@"rideCell_%i",_type];
    
    //1.拿到一个标识先去缓冲池中查找对应的cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    UIImageView *imgView;
    //2.如果缓冲池中没有，才需要传入一个标识创新的cell
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.backgroundColor = [UIColor whiteColor];
        cell.imageView.image = [UIImage imageNamed:@"cell_image"];
        imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
        [cell.imageView addSubview:imgView];
    }
    
    
    //3.覆盖数据
    NSMutableString *stepsTitle = [NSMutableString string];
    NSArray *steps;
    BMKTime *time;
    NSString *lineTitle;
    long distance;
    UIImage *img;
    switch (_type) {
        case 2:{
            BMKDrivingRouteLine *plan = _taxiData[indexPath.section];
            steps = plan.steps;
            time = plan.duration;
            distance = plan.distance;
            lineTitle = plan.title;
            MyLog(@"时间：%@_____长度：%li_____站点：%i_____路线名称：%@",time,distance,steps.count,lineTitle);
    
            for (BMKDrivingStep *transitStep in steps) {
//                NSLog(@"%@________%@",transitStep.vehicleInfo.title,transitStep.instruction);
//                if (transitStep.vehicleInfo.title) {
//                    if (stepsTitle.length == 0) {
//                        [stepsTitle appendString:transitStep.vehicleInfo.title];
//                    }else{
//                        [stepsTitle appendFormat:@"-%@",transitStep.vehicleInfo.title];
//                    }
//                }
            }
            
            img = [UIImage imageNamed:@"taxi_icon"];
        }
            break;
        case 3:{
            BMKWalkingRouteLine *walk = _wlakData[indexPath.section];
            steps = walk.steps;
            time = walk.duration;
            distance = walk.distance;
            lineTitle = walk.title;
            for (BMKWalkingStep *walkingStep in steps) {
            
            }
            img = [UIImage imageNamed:@"wlak_icon"];
        }
            break;
        default:{
            BMKTransitRouteLine *line = _busData[indexPath.section];
            steps = line.steps;
            time = line.duration;
            distance = line.distance;
            lineTitle = line.title;
            MyLog(@"时间：%@_____长度：%li_____站点：%i_____路线名称：%@",time,distance,steps.count,lineTitle);
            
            
            for (BMKTransitStep *transitStep in steps) {
                NSLog(@"%@________%@",transitStep.vehicleInfo.title,transitStep.instruction);
                if (transitStep.vehicleInfo.title) {
                    if (stepsTitle.length == 0) {
                        [stepsTitle appendString:transitStep.vehicleInfo.title];
                    }else{
                        [stepsTitle appendFormat:@"-%@",transitStep.vehicleInfo.title];
                    }
                }
            }
            img = [UIImage imageNamed:@"bus_icon"];
        }
            break;
    }
    
    bool boolean = time.hours==0?true:false;
    
    NSString *format = time.hours==0?@"%i分钟 | %0.1f公里":@"%i小时%i分钟 | %0.1f公里";
    
    cell.textLabel.text = stepsTitle;
    [_titleArr addObject:stepsTitle];
    
    if (boolean) {
        cell.detailTextLabel.text = [NSString stringWithFormat:format,time.minutes,distance/1000.f];
        [_detaiArr addObject:[NSString stringWithFormat:format,time.minutes,distance/1000.f]];
    }else{
        cell.detailTextLabel.text = [NSString stringWithFormat:format,time.hours,time.minutes,distance/1000.f];
        [_detaiArr addObject:[NSString stringWithFormat:format,time.hours,time.minutes,distance/1000.f]];
    }
    imgView.image = img;

    cell.textLabel.font = [UIFont systemFontOfSize:14.f];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12.f];
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    QuanKongCheckRouteViewController *checkRouteC = [[QuanKongCheckRouteViewController alloc] init];
    checkRouteC.userLocat = self.fromLC;
    checkRouteC.locService = self.locService;
    checkRouteC.locService.delegate = checkRouteC;
    checkRouteC.titleText = _titleArr[indexPath.section];
    checkRouteC.detaiText = _detaiArr[indexPath.section];
    switch (_type) {
        case 2:{
            checkRouteC.routeLine = _taxiData[indexPath.section];
        }
            break;
        case 3:{
            checkRouteC.routeLine = _wlakData[indexPath.section];
        }
            break;
        default:{
            checkRouteC.routeLine = _busData[indexPath.section];
        }
            break;
    }

    checkRouteC.lineType = _type;
    [self.navigationController pushViewController:checkRouteC animated:YES];
}


@end
