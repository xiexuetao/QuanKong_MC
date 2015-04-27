//
//  OrderOperation.m
//  QuanKong
//
//  Created by POWER on 14/11/19.
//  Copyright (c) 2014年 Rockcent. All rights reserved.
//

#import "OrderOperation.h"

@implementation OrderOperation

#pragma mark - cart button select operation

/**
*  根据tagArray及count获得现实购物车内选择商品数
*
*  @param array       订单选择数组
*  @param row         当前选择商品Row
*  @param selectCount 当前选择商品数量
*
*  @return 购物车商品选择的数量
*/

- (int)setCountWithOrderArray:(NSArray *)array AndRow:(int)row AndSelectCount:(int)selectCount
{
    int select = selectCount;
    
    NSString *object = [array objectAtIndex:row];
    
    if ([object isEqualToString:@"1"]) {
        
        select++;
        
    } else {
        
        select--;
    }
    
    return select;
}

/**
 *  根据tagArray获取当前购物车内选择商品数
 *
 *  @param array 订单选择标识数组
 *
 *  @return 购物车商品选择的数量
 */
- (int)getCountWithTagArray:(NSArray *)array
{
    int select = 0;
    
    for (int i = 0; i < array.count; i++) {
        
        NSString *tag = [array objectAtIndex:i];
        
        if ([tag isEqualToString:@"1"]) {
            
            select++;
            
        } else {
            
            select<=0?select=0:select--;
            
        }
        
    }
    
    return select;
}

/**
 *  根据tagArray获得现实购物车内总价
 *
 *  @param array       订单选择标识数组
 *  @param count       当前选择商品Row
 *  @param totalCount  当时选择商品的总价
 *  @param countArray  购物车商品价钱数组
 *  @param amountArray 购物车商品价钱数组
 *
 *  @return 购物车内总价
 */
- (CGFloat)setTotalWtihOrderArray:(NSArray *)array AndRow:(int)Row AndTotalCount:(float)totalCount AndCountArray:(NSArray *)countArray andEstimateAmountArray:(NSArray *)amountArray
{
    
    float total = totalCount;
    
    NSString *object = [array objectAtIndex:Row];
    
    int couponCount = [[countArray objectAtIndex:Row]intValue];
    float value = [[amountArray objectAtIndex:Row]floatValue];
    
    if ([object isEqualToString:@"1"]) {
        
        total = total + (value * couponCount);
        
    } else {
        
        total = total - (value * couponCount);
    }
    
    return total;
}


/**
 *  根据tagArray获取当前购物车内选择商品的总价
 *
 *  @param array       订单选择标识数组
 *  @param countArray  购物车商品数量数组
 *  @param amountArray 购物车商品价钱数组
 *
 *  @return 购物车商品选择的商品的总价
 */
- (CGFloat)getTotalWithTagArray:(NSArray *)array AndCountArray:(NSArray *)countArray andEstimateAmountArray:(NSArray *)amountArray
{
    float total = 0.0f;
    
    for (int i = 0; i < array.count; i++) {
        
        NSString *tag = [array objectAtIndex:i];
        
        int couponCount = [[countArray objectAtIndex:i]intValue];
        float value = [[amountArray objectAtIndex:i]floatValue];
        
        if ([tag isEqualToString:@"1"]) {
            
            total = total + (value * couponCount);
            
        } else {
            
            total<0?total=0:total - (value * couponCount);
            
        }
    }
    
    return total;
}

#pragma mark - cartCountOperation

/**
 *  购物车内券修改操作，加->+(1)，减->+(-1)
 *
 *  @param couponId 券ID
 *  @param Count    数目
 *  @param result   结果的结构block（由于block嵌套block，不能简单使用返回值)
 */
- (void)addCountWithId:(NSString *)couponId AndCount:(int)Count ByTag:(void (^)(bool result))result
{
    __block BOOL RETURN_BOOL;
    
    NSString *addToCartUrlStr = [NSString stringWithFormat:@"%@%@&loginName=%@&couponModelId=%@&count=%d&appKey=%@",NEW_HEAD_LINK,ADD_TO_MY_CART,[UserInfo shareUserInfo].userName,couponId,Count,APP_KEY];
    
    [HTTPTool getWithPath:addToCartUrlStr success:^(id success) {
        
        NSString *msg = [success objectForKey:@"msg"];
        
        if ([msg isEqualToString:@"success"]) {
            
            RETURN_BOOL = YES;
            
            result(RETURN_BOOL);
            
        } else {
            
            RETURN_BOOL = NO;
            
            result(RETURN_BOOL);
        }
        
    } fail:^(NSError *error) {
        
        NSLog(@"Fail");
        
    }];
    
}


@end
