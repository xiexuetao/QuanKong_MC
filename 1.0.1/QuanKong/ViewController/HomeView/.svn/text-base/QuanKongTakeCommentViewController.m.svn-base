//
//  QuanKongTakeCommentViewController.m
//  QuanKong
//
//  Created by POWER on 14/11/5.
//  Copyright (c) 2014年 Rockcent. All rights reserved.
//

#import "QuanKongTakeCommentViewController.h"

@interface QuanKongTakeCommentViewController ()

@end

@implementation QuanKongTakeCommentViewController
{
    int ratingValue;
}

@synthesize couponId = _couponId;

@synthesize ratingView;
@synthesize ratingLabel;
@synthesize commentTextView;
@synthesize placeholderLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.view.backgroundColor = LIGHT_GRAY;
        
        #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        {
            self.edgesForExtendedLayout = UIRectEdgeNone;
            self.extendedLayoutIncludesOpaqueBars = NO;
            self.modalPresentationCapturesStatusBarAppearance = NO;
        }
        
        #endif
        
        UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 22)];
        [backButton setBackgroundImage:[UIImage imageNamed:@"back_btn.png"] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(pushBack:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *backItemButton = [[UIBarButtonItem alloc]initWithCustomView:backButton];
        
        [self.navigationItem setLeftBarButtonItem:backItemButton];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 140, 30)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont systemFontOfSize:18.0];
        titleLabel.text = @"评论";
        
        self.navigationItem.titleView = titleLabel;
        
    }
    return self;
}

/**
 *  创建券信息视图
 */
- (void)initTopView
{
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(5, 5, WIDTH-10, 50)];
    topView.backgroundColor = [UIColor whiteColor];
    topView.layer.cornerRadius = 4.0f;
    
    [self.view addSubview:topView];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 40, 30)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [UIFont systemFontOfSize:15.0f];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.text = @"打分";
    
    [topView addSubview:titleLabel];
    
    ratingView = [[RatingView alloc]initWithFrame:CGRectMake(50, 17, 160, 20)];
    [ratingView setImagesDeselected:@"star_empty"
                     partlySelected:@"star_half"
                       fullSelected:@"star_select"
                        andDelegate:self];
    
    [topView addSubview:ratingView];
    
    [ratingView displayRating:0];
    
    ratingLabel = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH-80, 10, 60, 30)];
    ratingLabel.backgroundColor = [UIColor clearColor];
    ratingLabel.textAlignment = NSTextAlignmentRight;
    ratingLabel.textColor = [UIColor orangeColor];
    ratingLabel.font = [UIFont systemFontOfSize:16.0f];
    ratingLabel.text = [NSString stringWithFormat:@"0.0"];
    
    [topView addSubview:ratingLabel];
}

/**
 *  创建评价框视图
 */
- (void)initMainView
{
    UIView *mainView = [[UIView alloc]initWithFrame:CGRectMake(5, 60, WIDTH-10, 150)];
    mainView.backgroundColor = [UIColor whiteColor];
    mainView.layer.cornerRadius = 4.0f;
    mainView.layer.masksToBounds = YES;
    
    UIView *linView = [[UIView alloc]initWithFrame:CGRectMake(0, 40, WIDTH-10, 1)];
    linView.backgroundColor = LIGHT_GRAY;
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 200, 30)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [UIFont systemFontOfSize:15.0f];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.text = @"消费者评价";
    
    commentTextView = [[UITextView alloc]initWithFrame:CGRectMake(5, 45, WIDTH-20, 100)];
    commentTextView.backgroundColor = [UIColor clearColor];
    commentTextView.contentSize = CGSizeMake(WIDTH-18, 150);
    commentTextView.delegate = self;
    commentTextView.font = [UIFont systemFontOfSize:15.0f];
    commentTextView.textColor = [UIColor blackColor];
    
    commentTextView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    placeholderLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, WIDTH-25, 30)];
    placeholderLabel.backgroundColor = [UIColor clearColor];
    placeholderLabel.textAlignment = NSTextAlignmentLeft;
    placeholderLabel.font = [UIFont systemFontOfSize:15.0f];
    placeholderLabel.textColor = [UIColor lightGrayColor];
    placeholderLabel.text = @"请输入4-140字评论内容";
    placeholderLabel.hidden = NO;
    
    [mainView addSubview:linView];
    [mainView addSubview:titleLabel];
    
    [commentTextView addSubview:placeholderLabel];
    [mainView addSubview:commentTextView];
    
    [self.view addSubview:mainView];
}

/**
 *  创建评价按钮
 */
- (void)initSendButton
{
    UIButton *sendButton = [[UIButton alloc]initWithFrame:CGRectMake(5, 215, WIDTH-10, 40)];
    sendButton.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:124.0/255.0 blue:0.0/255.0 alpha:1.0];
    [sendButton setTitle:@"确认" forState:UIControlStateNormal];
    [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sendButton.titleLabel.font = [UIFont systemFontOfSize:17.0f];
    
    sendButton.layer.cornerRadius = 4.0f;
    
    [sendButton addTarget:self action:@selector(sendButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:sendButton];
}

/**
 *  返回按钮操作
 *
 *  @param sender nil
 */
- (void)pushBack:(UIButton *)sender
{
    [self.delegate popViewControllerGetData:self];
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  确定评价操作
 *
 *  @param sender nil
 */
- (void)sendButtonClick:(UIButton *)sender
{
    NSString *rating = [NSString stringWithFormat:@"%d",ratingValue];
    NSString *comment = commentTextView.text;
    
    /**
     *  判断打分和评价是否符合标准
     */
    if (rating.integerValue == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您还没有打分" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }else if(comment.length < 4){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入4-140字的评论内容" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        
        /**
         *  新方法
         */
        
        NSString *addCommentUrlStr = [NSString stringWithFormat:@"%@%@",NEW_HEAD_LINK,ADD_COMMENT];
        
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc]initWithCapacity:0];
        [parameters setValue:[UserInfo shareUserInfo].userName forKey:@"loginName"];
        [parameters setValue:_couponId forKey:@"couponModelId"];
        [parameters setValue:[NSString stringWithFormat:@"%d",ratingValue] forKey:@"score"];
        [parameters setValue:commentTextView.text forKey:@"content"];
        [parameters setValue:@"0" forKey:@"isHidden"];
        [parameters setValue:APP_KEY forKey:@"appKey"];
        [parameters setValue:self.verificationId forKey:@"verificationId"];
        
        NSLog(@"%@",parameters);
        
        [HTTPTool postWithPath:addCommentUrlStr params:parameters success:^(id success) {
            
            NSString *msg = [success objectForKey:@"msg"];
            
            if ([msg isEqualToString:@"success"]) {
                
                [self.view.window showHUDWithText:@"评论成功" Enabled:YES];
                [self performSelector:@selector(pushBack:) withObject:nil afterDelay:1.5];
            } else {
                
                [self.view.window showHUDWithText:[NSString stringWithFormat:@"评论失败,%@",msg] Enabled:YES];
            }

            
        } fail:^(NSError *error) {
            
             NSLog(@"Fail");
            
        }];
        
        /**
         *  发生评价请求（含中文字，需要post方法）
         */
        
        /*NSString *addCommentUrlStr = [NSString stringWithFormat:@"%@%@",NEW_HEAD_LINK,ADD_COMMENT];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        [manager.requestSerializer setValue:@"application/x-www-form-urlencoded"forHTTPHeaderField:@"Content-Type"];
        
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc]initWithCapacity:0];
        [parameters setValue:[UserInfo shareUserInfo].userName forKey:@"loginName"];
        [parameters setValue:_couponId forKey:@"couponModelId"];
        [parameters setValue:[NSString stringWithFormat:@"%d",ratingValue] forKey:@"score"];
        [parameters setValue:commentTextView.text forKey:@"content"];
        [parameters setValue:@"0" forKey:@"isHidden"];
        [parameters setValue:APP_KEY forKey:@"appKey"];
        
        NSLog(@"%@",parameters);
        
        [manager POST:addCommentUrlStr parameters:parameters
              success:^(AFHTTPRequestOperation *operation,id responseObject) {
                  
                  NSLog(@"Success: %@", responseObject);
                  
                  NSString *msg = [responseObject objectForKey:@"msg"];
                  
                  if ([msg isEqualToString:@"success"]) {
                      
                      [self.view.window showHUDWithText:@"评论成功" Enabled:YES];
                      [self performSelector:@selector(pushBack:) withObject:nil afterDelay:1.5];
                  } else {
                      
                      [self.view.window showHUDWithText:[NSString stringWithFormat:@"评论失败,%@",msg] Enabled:YES];
                  }
                  
                  
              }failure:^(AFHTTPRequestOperation *operation,NSError *error) {
                  
                  NSLog(@"Fail");
              }];*/
    }
}

#pragma mark - textView delegate

/**
 *  键盘方法 - > 根据点击监听隐藏键盘和改变textView内容
 */
- (void)setUpForDismissKeyboard
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    UITapGestureRecognizer *singleTapGR =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(tapAnywhereToDismissKeyboard:)];
    NSOperationQueue *mainQuene =[NSOperationQueue mainQueue];
    
    [nc addObserverForName:UIKeyboardWillShowNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [self.view addGestureRecognizer:singleTapGR];
                }];
    
    [nc addObserverForName:UIKeyboardWillHideNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [self.view removeGestureRecognizer:singleTapGR];
                }];
    
    [nc addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:commentTextView];
}

- (void)textFieldChanged:(id)sender
{
    NSLog(@"%@",commentTextView.text);
}

/**
 *  点击屏幕位置隐藏键盘
 *
 *  @param gestureRecognizer <#gestureRecognizer description#>
 */
- (void)tapAnywhereToDismissKeyboard:(UIGestureRecognizer *)gestureRecognizer
{
    //此method会将self.view里所有的subview的first responder都resign掉
    
    [self.view endEditing:YES];
}

/**
 *  监听textView，改变自建placeholderLabel的内容
 *
 *  @param textView nil
 */
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    placeholderLabel.hidden = YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length == 0) {
        
        placeholderLabel.hidden = NO;
        
    } else {
        
        placeholderLabel.hidden = YES;
        
    }
}

#pragma mark - rating delegate

-(void)ratingChanged:(float)newRating
{
    ratingLabel.text = [NSString stringWithFormat:@"%.1f",newRating];
    
    ratingValue = [ratingLabel.text intValue];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initTopView];
    
    [self initMainView];
    
    [self initSendButton];
    
    [self setUpForDismissKeyboard];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

@end
