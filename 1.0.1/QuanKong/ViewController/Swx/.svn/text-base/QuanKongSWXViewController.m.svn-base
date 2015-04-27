//
//  QuanKongSWXViewController.m
//  QuanKong
//
//  Created by Rick on 15/1/22.
//  Copyright (c) 2015年 Rockcent. All rights reserved.
//
#define BUT_HEIGHT 45

#import "QuanKongSWXViewController.h"

@interface QuanKongSWXViewController (){
    int _selectBut;
    
    UITableView *mTavleView;
}
@end

@implementation QuanKongSWXViewController


-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.title = @"券市交易";
        [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
         self.edgesForExtendedLayout = UIRectEdgeNone;
        [self topButton];
        [self createTableView];
        self.view.backgroundColor = [UIColor lightTextColor];
    }
    return self;
}
- (void)viewDidLoad {
    _selectBut = 1;
    [super viewDidLoad];
}

/**
 *  创建列表
 */
-(void)createTableView{
    mTavleView = [[UITableView alloc] initWithFrame:CGRectMake(0, BUT_HEIGHT, WIDTH, HEIGHT-BUT_HEIGHT) style:UITableViewStylePlain];
    [self.view addSubview:mTavleView];
}

/**
 *  创建顶部3个button
 */ -(void)topButton{
    UIButton *all = [self createrButton:@"委买中" tag:1];
    UIButton *cash = [self createrButton:@"委卖中" tag:2];
    UIButton *preferential = [self createrButton:@"已成功" tag:3];
    [self.view addSubview:all];
    [self.view addSubview:cash];
    [self.view addSubview:preferential];
}

/**
 *  创建button
 *
 *  @param str 按钮标题
 *  @param i   tag
 *
 *  @return button
 */
-(UIButton *)createrButton:(NSString *) str tag:(NSInteger) i{
    
    UIButton *but = [UIButton buttonWithType:UIButtonTypeSystem];
    but.frame = CGRectMake((i-1)*(WIDTH/3), 0, WIDTH/3, BUT_HEIGHT);
    [but setTitle:str forState:UIControlStateNormal];
    but.tag = i;
    [but addTarget:self action:@selector(clickTopButton:) forControlEvents:UIControlEventTouchUpInside];
    if (i == 1) {
        [but setBackgroundImage:[UIImage imageNamed:@"topbut_h"] forState:UIControlStateNormal];
        [but setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    }else{
        [but setBackgroundImage:[UIImage imageNamed:@"topbut_b"] forState:UIControlStateNormal];
        [but setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    }
    return but;
}

/**
 *  top button click
 *
 *  @param but 点击的按钮
 */
-(void)clickTopButton:(UIButton *)but{
    
    UIButton *button = (UIButton *)[self.view viewWithTag:_selectBut];
    [button setBackgroundImage:[UIImage imageNamed:@"topbut_b"] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    _selectBut = but.tag;
    [but setBackgroundImage:[UIImage imageNamed:@"topbut_h"] forState:UIControlStateNormal];
    [but setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
