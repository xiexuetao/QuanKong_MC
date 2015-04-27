//
//  QuanKongClassViewController.m
//  QuanKong
//
//  Created by POWER on 14-9-16.
//  Copyright (c) 2014年 Rockcent. All rights reserved.
//

#import "QuanKongClassViewController.h"
#import "QuanKongClass.h"
#import "HTTPTool.h"
#import "QuanKongCategoryViewController.h"
#import "IntnetPrompt.h"
#import "UIWindow+AlertHud.h"
#import "ClassTableViewCell.h"
#import "LoadingHUDView.h"
#import "UITableView+Help.h"

@interface QuanKongClassViewController (){
    UITableView *_classTableView;//一级类目
    NSMutableArray *_classData;
}

@end

@implementation QuanKongClassViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.navigationItem.title = @"分类";
        [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initClassViewWithDataSource];
    [self sendReqClass];
    [LoadingHUDView showLoadinginView:self.view];
}



-(void)sendReqClass{

    NSString *str = [NSString stringWithFormat:@"%@%@&appKey=%@",NEW_HEAD_LINK,CLASS_TYPE_METHOD,APP_KEY];
    
    [self requestDataWithUrl:str];
}



/**
 *  请求数据
 *
 *  @param str 请求路径
 *  @param i   请求数据类型
 */
-(void)requestDataWithUrl:(NSString *)str{
    
    [HTTPTool getWithPath:str success:^(id success) {
        NSDictionary *dic = (NSDictionary *)success;
        NSString *msg = [dic objectForKey:@"msg"];
        if ([msg isEqualToString:@"success"]) {
            [IntnetPrompt hideIntnetPromptForView:self.view animated:YES];
           NSArray *arr = [dic objectForKey:@"objList"];
            for (NSDictionary *dictionary in arr) {
                QuanKongClass *class = [QuanKongClass initWihtData:dictionary];
                [_classData addObject:class];
            }
                [_classTableView reloadData];
        }
        [LoadingHUDView hideLoadingView];
    } fail:^(NSError *error) {
        [LoadingHUDView hideLoadingView];
        IntnetPrompt *intnet = [IntnetPrompt showIntnetPromptWithMessage:INTNET_PROMPT_STRING inView:self.view];
        intnet.delegate = self;
        [self.view.window showHUDWithText:@"链接错误，请稍后尝试" Enabled:YES];
    }];
}

-(void)clickButtonOperation:(IntnetPrompt *)intnetView{
    [self sendReqClass];
}

//初始化分类视图
-(void)initClassViewWithDataSource{
    _classData = [NSMutableArray array];

    
    _classTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) style:UITableViewStylePlain];
    _classTableView.delegate = self;
    _classTableView.dataSource = self;
    
    [self.view addSubview:_classTableView];
}


#pragma mark 每当有一个cell进入视野范围内就会调用，返回当前这行显示的cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //0.用static修饰局部变量，只会初始化一次
    static NSString *ID = @"ClassCell";
    
    //1.拿到一个标识先去缓冲池中查找对应的cell
    ClassTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    //2.如果缓冲池中没有，才需要传入一个标识创新的cell
    if (cell == nil) {
        cell = [[ClassTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    MyLog(@"%f",self.view.frame.size.height);
    QuanKongClass *class = _classData[indexPath.row];
    NSLog(@"%i",class.Id);
    //3.覆盖数据
    switch (class.Id) {
        case 5:
            cell.imageV.image = [UIImage imageNamed:@"food"];
            break;
        case 6:
            cell.imageV.image = [UIImage imageNamed:@"shop"];
            break;
        case 7:
            cell.imageV.image = [UIImage imageNamed:@"play"];
            break;
        case 8:
            cell.imageV.image = [UIImage imageNamed:@"grogshop"];
            break;
        case 9:
            cell.imageV.image = [UIImage imageNamed:@"travel"];
            break;
        case 10:
            cell.imageV.image = [UIImage imageNamed:@"serve"];
            break;
        default:
            break;
    }
    
    cell.la.text = class.name;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


/**
 *  有多少行数据
 *
 *  @param tableView
 *  @param section
 *
 *  @return
 */
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _classData.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}


/**
 *  组
 *
 *  @param tableView
 *
 *  @return
 */
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


/**
 *  当选择某一行数据的时候调用
 *
 *  @param tableView
 *  @param indexPath
 */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    QuanKongClass *class = _classData[indexPath.row];
    QuanKongCategoryViewController *category = [[QuanKongCategoryViewController alloc] init];
    category.cla = class;
    category.hidesBottomBarWhenPushed = YES;
    
    
    [self.navigationController pushViewController:category animated:YES];
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UITableView setExtraCellLineHidden:_classTableView];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
