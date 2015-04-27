//
//  ClassTableViewCell.m
//  QuanKong
//
//  Created by Rick on 14/11/26.
//  Copyright (c) 2014年 Rockcent. All rights reserved.
//

#import "ClassTableViewCell.h"

@implementation ClassTableViewCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        // Initialization code
        [self initCellDetail];
    }
    return self;
}

-(void)initCellDetail{
    
    self.imageV = [[UIImageView alloc] init];
    self.imageV.bounds = CGRectMake(0, 0, 72, 60);
    self.imageV.center = CGPointMake(66, 90/2);
    [self addSubview:self.imageV];
    
    UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(0, 90-0.5f, WIDTH, 0.5f)];
    line.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:line];
    
    self.la = [[UILabel alloc] init];
    self.la.bounds = CGRectMake(0, 0, 100, 30);
    self.la.center = CGPointMake(180, 90/2);
    self.la.textColor = [UIColor darkGrayColor];
    [self addSubview:self.la];

}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
