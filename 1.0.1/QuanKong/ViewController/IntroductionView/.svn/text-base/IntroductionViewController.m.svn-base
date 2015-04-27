//
//  IntroductionViewController.m
//  Kaiquan
//
//  Created by rockcent on 14-8-1.
//  Copyright (c) 2014年 rockcent. All rights reserved.
//

#import "IntroductionViewController.h"

@interface IntroductionViewController ()

@end

@implementation IntroductionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self buildIntroductionPage];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//构建介绍页面
//Authou:mark
//自定义方法
-(void)buildIntroductionPage
{
    // 加载图片
    UIImageView *panel1=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"introduction.jpg"] ];
    UIImageView *panel2=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"introduction.jpg"] ];
    NSArray *panels = @[panel1, panel2];
    //定义介绍页面frame
    MYBlurIntroductionView *introductionView = [[MYBlurIntroductionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    //管理委托
    introductionView.delegate = self;
    //将图片放入介绍控件
    [introductionView buildIntroductionWithPanels:panels];
    //加入视图
    [self.view addSubview:introductionView];
}

#pragma mark - MYIntroduction Delegate

//介绍页面跳转时调用的函数，没有使用预留接口
//Author：mark
//第三方控件委托方法
-(void)introduction:(MYBlurIntroductionView *)introductionView didChangeToPanel:(UIImageView *)panel withIndex:(NSInteger)panelIndex{
    
    
}

//skip或者跳转到最后一页的时候调用的方法，采用动态方法回调application中设置导航viewcontrll
//Author: mark
//第三方控件委托方法
-(void)introduction:(MYBlurIntroductionView *)introductionView didFinishWithType:(MYFinishType)finishType {
    
    [[UIApplication sharedApplication].delegate performSelector:@selector(setTabbarController)];
    
}
@end
