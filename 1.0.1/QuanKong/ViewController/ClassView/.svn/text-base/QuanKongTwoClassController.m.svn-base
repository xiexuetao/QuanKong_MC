//
//  QuanKongTwoClassController.m
//  QuanKong
//
//  Created by 谢雪滔 on 14/10/27.
//  Copyright (c) 2014年 Rockcent. All rights reserved.
//

#import "QuanKongTwoClassController.h"
#import "QuanKongClass.h"
#import "HTTPTool.h"
#import "UIWindow+AlertHud.h"
@interface QuanKongTwoClassController ()
@end

@implementation QuanKongTwoClassController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initClassViewWithDataSource];
        [self sendReqClass];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    CGRect cr = self.classTableView.frame;
    CGRect tr = self.twoClassTableView.frame;
    cr.origin.x = 0;
    tr.origin.x = WIDTH/2+2;
    self.classTableView.frame = cr;
    self.twoClassTableView.frame = tr;
    [UIView commitAnimations];
}

-(void)sendReqClass{
    
//    NSString *str = [NSString stringWithFormat:@"%@method=admin.queryIndustryDetail&groupId=%i&appKey=%@",VERIFICATION_URL,self.indext,APP_KEY];
//    [self requestDataWithUrl:str];
}



/**
 *  请求数据
 *
 *  @param str 请求路径
 *  @param i   请求数据类型 yes为一级分类，no为二级分类
 */
-(void)requestDataWithUrl:(NSString *)str{
    
    [HTTPTool getWithPath:str success:^(id success) {
        NSDictionary *dic = (NSDictionary *)success;
        NSString *msg = [dic objectForKey:@"msg"];
        if ([msg isEqualToString:@"success"]) {
            NSArray *arr = [dic objectForKey:@"objList"];
            for (NSDictionary *dictionary in arr) {
                QuanKongClass *class = [QuanKongClass initWihtData:dictionary];
                [self.twoClassData addObject:class];
            }
            [self.twoClassTableView reloadData];
        }else{
            [self.view.window showHUDWithText:@"链接错误，请稍后尝试" Enabled:YES];
        }
    } fail:^(NSError *error) {
        [self.view.window showHUDWithText:@"链接错误，请稍后尝试" Enabled:YES];
    }];
    
}


//初始化分类视图
-(void)initClassViewWithDataSource{
    self.twoClassData = [NSMutableArray array];
    
    self.classTableView = [[UITableView alloc] initWithFrame:CGRectMake(WIDTH+1, 0, WIDTH/2-2, HEIGHT) style:UITableViewStylePlain];
    self.classTableView.delegate = self;
    self.classTableView.dataSource = self;
    self.classTableView.bounces = NO;
    self.classTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    self.twoClassTableView = [[UITableView alloc] initWithFrame:CGRectMake(WIDTH+1, 0, WIDTH/2+2, HEIGHT) style:UITableViewStylePlain];
    self.twoClassTableView.delegate = self;
    self.twoClassTableView.dataSource = self;

    [self.view addSubview:self.classTableView];
    [self.view addSubview:self.twoClassTableView];
}


#pragma mark 每当有一个cell进入视野范围内就会调用，返回当前这行显示的cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //0.用static修饰局部变量，只会初始化一次
    static NSString *ID = @"Cell";
    
    //1.拿到一个标识先去缓冲池中查找对应的cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    //2.如果缓冲池中没有，才需要传入一个标识创新的cell
    UIImageView *imageView;
    UILabel *lab;
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        imageView = [[UIImageView alloc] init];
        imageView.bounds = CGRectMake(0, 0, 60, 50);
        imageView.center = CGPointMake(40, (HEIGHT-110)/6/2);
        [cell addSubview:imageView];
        lab = [[UILabel alloc] init];
        lab.bounds = CGRectMake(0, 0, 100, 30);
        lab.center = CGPointMake(130,(HEIGHT-110)/6/2);
        [cell addSubview:lab];
    }
    
    //3.覆盖数据
    if (tableView.frame.size.width == WIDTH/2+2) {
        QuanKongClass *class = self.twoClassData[indexPath.row];
        cell.textLabel.text = class.name1;
    }else{
        switch (indexPath.row) {
            case 0:
                imageView.image = [UIImage imageNamed:@"food"];
                break;
            case 1:
                imageView.image = [UIImage imageNamed:@"shop"];
                break;
            case 2:
                imageView.image = [UIImage imageNamed:@"play"];
                break;
            case 3:
                imageView.image = [UIImage imageNamed:@"sport"];
                break;
            case 4:
                imageView.image = [UIImage imageNamed:@"travel"];
                break;
            case 5:
                imageView.image = [UIImage imageNamed:@"serve"];
                break;
            default:
                break;
        }
        QuanKongClass *class = self.classData[indexPath.row];
        lab.text = class.name;
    }
    
    
    cell.backgroundColor = [UIColor clearColor];
    
    if (self.indext == indexPath.row) {
        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"selectbackgroundh"]];
        lab.textColor = [UIColor clearColor];
        lab.textColor = [UIColor orangeColor];
    }else{
        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"selectbackground"]];
        lab.textColor = [UIColor blackColor];
    }
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"selectbackgroundh"]];
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
    if (tableView.frame.size.width == WIDTH/2+2) {
        return self.twoClassData.count;
    }else{
        return self.classData.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.frame.size.width == WIDTH/2+2) {
        return 50;
    }else{
        return (HEIGHT-110)/6;
    }

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
    self.indext = indexPath.row;
    [self.classTableView reloadData];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
