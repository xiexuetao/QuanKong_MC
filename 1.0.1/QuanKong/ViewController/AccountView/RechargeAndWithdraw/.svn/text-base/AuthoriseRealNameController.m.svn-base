//
//  AuthoriseRealNameViewController.m
//  QuanKong
//
//  Created by POWER on 1/20/15.
//  Copyright (c) 2015 Rockcent. All rights reserved.
//

#import "AuthoriseRealNameController.h"

#import "WithdrawViewController.h"
#import "AddUserBankController.h"


@interface AuthoriseRealNameController ()

@end

@implementation AuthoriseRealNameController

@synthesize realNameTextField;
@synthesize buttonTitleLabel;
@synthesize resultView;

- (void)viewDidLoad {
    
    [self initMainView];
    
    [self setInfoWithRealNameWarning];
    
    [self setUpForDismissKeyboard];
    
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

}

- (void)initMainView
{
    
    #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    self.view.backgroundColor = [UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
    
    #endif
    
    //加入返回
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 46, 22)];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back_btn.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(pushBack:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItemButton = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    
    [self.navigationItem setLeftBarButtonItem:backItemButton];
    
    //UINavigationItem标题
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 140, 30)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:18.0];
    titleLabel.text = @"补充真实姓名";
    
    self.navigationItem.titleView = titleLabel;
    
    resultView = [[ResultView alloc]init];
    
}

- (void)setInfoWithRealNameWarning
{
    self.tableView.frame = CGRectMake(0, 30, WIDTH, self.view.frame.size.height-30);
    
    UILabel *warningLabel_1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, WIDTH-20, 35)];
    warningLabel_1.backgroundColor = [UIColor clearColor];
    warningLabel_1.textAlignment = NSTextAlignmentLeft;
    warningLabel_1.textColor = [UIColor darkGrayColor];
    warningLabel_1.font = [UIFont systemFontOfSize:13.0f];
    warningLabel_1.text = @"为保障您的账户资金安全，请填写您的真实姓名！";
    
    [self.view addSubview:warningLabel_1];
    
    UILabel *warningLabel_2 = [[UILabel alloc]initWithFrame:CGRectMake(10, HEIGHT-50-64, WIDTH-20, 50)];
    warningLabel_2.backgroundColor = [UIColor clearColor];
    warningLabel_2.textAlignment = NSTextAlignmentLeft;
    warningLabel_2.textColor = [UIColor grayColor];
    warningLabel_2.numberOfLines = 0;
    warningLabel_2.font = [UIFont systemFontOfSize:13.0f];
    warningLabel_2.text = @"说明：真实姓名填写后不可更改，请填写真实的姓　　　　名，错误信息会导致绑定银行卡失败。";
    
    [self.view addSubview:warningLabel_2];
}

- (void)pushBack:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 2;
}

//方法类型：系统方法
//编   写：peter
//方法功能：定义tableViewCell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 35;
        
    } else {
        
        return 30;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                                                  reuseIdentifier:CellIdentifier];
    
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    switch (indexPath.section) {
        case 0:
        {
            UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 80, 30)];
            titleLabel.backgroundColor = [UIColor clearColor];
            titleLabel.textAlignment = NSTextAlignmentLeft;
            titleLabel.font = [UIFont systemFontOfSize:16.0f];
            titleLabel.textColor = [UIColor blackColor];
            titleLabel.text = @"姓名";
            
            /*UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(10, 39.75, WIDTH-10, 0.5)];
            lineView.backgroundColor = [UIColor colorWithRed:210.0/255.0 green:210.0/255.0 blue:210.0/255.0 alpha:1.0];
            
            [cell.contentView addSubview:lineView];*/
            
            realNameTextField = [[UITextField alloc]initWithFrame:CGRectMake(55, 5, WIDTH-65, 30)];
            realNameTextField.delegate = self;
            realNameTextField.backgroundColor = [UIColor clearColor];
            realNameTextField.textAlignment = NSTextAlignmentLeft;
            realNameTextField.textColor = [UIColor blackColor];
            realNameTextField.font = [UIFont systemFontOfSize:16.0f];
            realNameTextField.tag = indexPath.row;
            realNameTextField.placeholder = @"请输入你的真实姓名";
            
            [cell.contentView addSubview:realNameTextField];
            [cell.contentView addSubview:titleLabel];

        }
            break;
        case 1:
        {
            buttonTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 40)];
            buttonTitleLabel.textColor = [UIColor lightGrayColor];
            buttonTitleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
            buttonTitleLabel.textAlignment = NSTextAlignmentCenter;
            buttonTitleLabel.text = @"确定";
            
            [cell.contentView addSubview:buttonTitleLabel];
        }
            break;
            
    }
    // Configure the cell...
    
    return cell;
}

/**
 *  键盘收起监听
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
    
    [nc addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:realNameTextField];
}

/**
 *  键盘手势监听操作
 *
 *  @param gestureRecognizer 手势
 */
- (void)tapAnywhereToDismissKeyboard:(UIGestureRecognizer *)gestureRecognizer
{
    //此method会将self.view里所有的subview的first responder都resign掉
    
    [self.view endEditing:YES];
}

/**
 *  textFilld
 *
 *  @param sender textField检测
 */
- (void)textFieldChanged:(id)sender
{
    if([realNameTextField.text isEqualToString:@""])
    {
        buttonTitleLabel.textColor = [UIColor whiteColor];
        buttonTitleLabel.backgroundColor = [UIColor lightGrayColor];
        
    } else {
        
        buttonTitleLabel.textColor = [UIColor whiteColor];
        buttonTitleLabel.backgroundColor = [UIColor orangeColor];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1)
    {
        if(realNameTextField.text.length > 0)
        {
            NSString *authoriseRealNameUrlStr = [[NSString stringWithFormat:@"%@%@&loginName=%@&realname=%@&appKey=%@",NEW_HEAD_LINK,SET_UP_CUSTOMER,[UserInfo shareUserInfo].userName,realNameTextField.text,APP_KEY]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            [HTTPTool getWithPath:authoriseRealNameUrlStr success:^(id success) {
                
                NSString *msg = [success objectForKey:@"msg"];
                
                NSLog(@"%@",success);
                
                if([msg isEqualToString:@"success"]) {
                    
                    [UserInfo shareUserInfo].realName = realNameTextField.text;
                    [[UserInfo shareUserInfo]initWithDictionary:success];
                    
                    [resultView showResultViewWihtTitle:@"补充成功" AndMessage:@"你已补充真实姓名，可以绑定银行卡了!" AndButtonTitle:@"绑定银行卡" AndDelegate:self ByResult:YES InView:self.view.window];
                    
                } else {
                    
                    [resultView showResultViewWihtTitle:@"补充失败" AndMessage:[NSString stringWithFormat:@"出现问题了，%@",msg] AndButtonTitle:@"重新输入" AndDelegate:self ByResult:NO InView:self.view.window];
                }
                
            } fail:^(NSError *error) {
                
                NSLog(@"NetWork Fail");
                
            }];
        }
    }
}

#pragma mark - resultView

- (void)resultButtonClick:(UIButton *)sender
{
    /**
     *  根据button.tag做相应操作
     */
    switch (sender.tag) {
        case 0:
        {
            [resultView dismiss];
        }
            break;
        case 1:
        {
            [resultView dismiss];
            
            BOOL bankSelect = [[UserInfo shareUserInfo] getBankSelect];
            
            if(bankSelect)
            {
                [self.navigationController pushViewController:[[WithdrawViewController alloc]init] animated:YES];
                
            } else {
                
                [self.navigationController pushViewController:[[AddUserBankController alloc]init] animated:YES];
            }
           
        }
            break;
        default:
            break;
    }
}


@end
