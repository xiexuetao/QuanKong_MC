//
//  QuanKongShareView.m
//  QuanKong
//
//  Created by Rick on 14/11/4.
//  Copyright (c) 2014年 Rockcent. All rights reserved.
//

#import "QuanKongShareView.h"

@interface QuanKongShareView(){
    UIView *_showView;
}

@end

@implementation QuanKongShareView


-(UIView *)initShareWithFrame:(CGRect)frame and:(UIViewController *)vc{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.sub = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT/3*2, WIDTH, HEIGHT/3-47)];
        self.sub.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:self.sub];
        [self addButton];
        
        _showView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
        _showView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];

        [_showView addSubview:self];
        
        UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(offShowView)];
        singleRecognizer.numberOfTapsRequired = 1; // 单击
        [_showView addGestureRecognizer:singleRecognizer];
        
        [UIView animateWithDuration:0.35 animations:^{
            self.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
            
            _showView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
            
        }];
        [vc.view.window addSubview:_showView];
    }
    return self;
}

-(void)addButton{
//    UIButton *sina = [UIButton buttonWithType:UIButtonTypeCustom];
//    sina.bounds = CGRectMake(0, 0, 60, 80);
//    sina.center = CGPointMake(WIDTH/4, self.sub.frame.size.height/2);
//    [self setButtonTitle:@"新浪微博" imageName:@"sina_icon" andButton:sina];
    
    
    UIButton *wechat = [UIButton buttonWithType:UIButtonTypeCustom];
    wechat.bounds = CGRectMake(0, 0, 60, 80);
//    wechat.center = CGPointMake(WIDTH/4*2, self.sub.frame.size.height/2);
    wechat.center = CGPointMake(WIDTH/4, self.sub.frame.size.height/2);
    [self setButtonTitle:@"微信会话" imageName:@"weixin_iconh" andButton:wechat];
    
    
    UIButton *wechatt = [UIButton buttonWithType:UIButtonTypeCustom];
    wechatt.bounds = CGRectMake(0, 0, 60, 80);
//    wechatt.center = CGPointMake(WIDTH/4*3, self.sub.frame.size.height/2);
     wechatt.center = CGPointMake(WIDTH/4*2, self.sub.frame.size.height/2);
    [self setButtonTitle:@"微信友圈" imageName:@"weixinp_icon" andButton:wechatt];
    
//    [self addButtonToShareView:@[sina,wechat,wechatt]];
    [self addButtonToShareView:@[wechat,wechatt]];

}


-(void)offShowView{
    [UIView animateWithDuration:0.35 animations:^{
        self.frame = CGRectMake(0, HEIGHT, WIDTH, HEIGHT);
        _showView.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL finished) {
        [_showView removeFromSuperview];
    }];
}


-(void)addButtonToShareView:(NSArray *)arr{

    for (int x=0; x<arr.count; x++) {
        UIButton *but = arr[x];
        but.tag = x;
        [but addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [self.sub addSubview:but];
    }
    
    
    self.but = [[UIButton alloc]initWithFrame:CGRectMake(0, HEIGHT-45, WIDTH, 45)];
    [self.but setTitle:@"取消" forState:UIControlStateNormal];
    [self.but setBackgroundColor:[UIColor whiteColor]];
    [self.but setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//    self.but.frame = CGRectMake(0, HEIGHT-45, WIDTH, 45);
    self.but.tag = 111;
    [self.but addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.but];
}


-(void)click:(UIButton *)but{
    [self offShowView];
    [self.delegate clickShareButton:but.tag];
}


-(void)setButtonTitle:(NSString *)title imageName:(NSString *)imageName andButton:(UIButton *) but{
    UILabel *wtt = [[UILabel alloc] init];
    wtt.bounds = CGRectMake(0, 0, 60, 20);
    wtt.textColor = [UIColor darkGrayColor];
    wtt.font = [UIFont systemFontOfSize:13.f];
    wtt.center = CGPointMake(35,70);
    wtt.text = title;
    [but addSubview:wtt];
    
    UIImageView *wechattImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    wechattImage.image = [UIImage imageNamed:imageName];
    [but addSubview:wechattImage];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
