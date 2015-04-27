//
//  QuanKongWebViewController.m
//  QuanKong
//
//  Created by POWER on 14/11/18.
//  Copyright (c) 2014年 Rockcent. All rights reserved.
//

#import "QuanKongWebViewController.h"

@interface QuanKongWebViewController ()

@end

@implementation QuanKongWebViewController

@synthesize detailWebView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        {
            self.edgesForExtendedLayout = UIRectEdgeNone;
            self.extendedLayoutIncludesOpaqueBars = NO;
            self.modalPresentationCapturesStatusBarAppearance = NO;
        }
        
        #endif
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 140, 30)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont systemFontOfSize:18.0];
        titleLabel.text = @"券详情";
        
        self.navigationItem.titleView = titleLabel;
        
        UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 22)];
        [backButton setBackgroundImage:[UIImage imageNamed:@"back_btn"] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *backItemButton = [[UIBarButtonItem alloc]initWithCustomView:backButton];
        
        [self.navigationItem setLeftBarButtonItem:backItemButton];
        
    }
    return self;
}

- (void)backButtonClick:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initWebViewWithHtml:(NSString *)html
{
    NSString *css =[NSString stringWithFormat:@"<html> \n"
                    "<head> \n"
                    "<style type=\"text/css\"> \n"
                    "img{max-width:100%%;\n}"
                    "</style> \n"
                    "</head> \n"
                    "<body>%@</body> \n"
                    "</html>",html];
    
    detailWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64)];
    detailWebView.delegate = self;
    [detailWebView loadHTMLString:css baseURL:nil];
 
    [self.view insertSubview:detailWebView atIndex:1];
}

-(id)initWebViewWithRequestUrl:(NSString *)url
{
    
    detailWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64)];
    detailWebView.delegate = self;
    detailWebView.scalesPageToFit = YES;
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [detailWebView loadRequest:request];
    [self.view insertSubview:detailWebView atIndex:1];
    
    return self;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"Finish");
    NSLog(@"%f",detailWebView.scrollView.contentSize.height);
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
