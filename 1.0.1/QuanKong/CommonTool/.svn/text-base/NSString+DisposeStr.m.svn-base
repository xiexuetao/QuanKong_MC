//
//  NSString+DisposeStr.m
//  QuanKong
//
//  Created by Rick on 14/12/11.
//  Copyright (c) 2014年 Rockcent. All rights reserved.
//

#import "NSString+DisposeStr.h"

@implementation NSString (DisposeStr)


#pragma mark 手机号码验证
+(BOOL)verificationPhone:(NSString *) phonennumber{
    NSString *phone = @"^1(\\d{10})$";
    NSPredicate *regexphone = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phone];
    BOOL boole = [regexphone evaluateWithObject:phonennumber];
    //    MyLog(@"---------->>%i",boole);
    return boole;
}

#pragma mark 密码验证
+(BOOL)verificationPassword:(NSString *)password{
    NSString *pw = @"^\\w{6,15}$";
    NSPredicate *regexps = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pw];
    BOOL boole = [regexps evaluateWithObject:password];
    //    MyLog(@"---------->>%i",boole);
    return boole;
}

#pragma mark 密码确认
+(BOOL)verificationPassword:(NSString *)password affirmPs:(NSString *)affirmPw{
    BOOL boole = NO;
    if ([password isEqualToString:affirmPw]) {
        boole = YES;
    }
    return boole;
}

/**
 *  生成字符串的MD5
 *
 *  @param str 字符串
 *
 *  @return 对应的MD5
 */

+ (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}


+(NSString *)md5_MC:(NSString *)str
{
    NSMutableString *ms = [NSMutableString stringWithFormat:@"%@.mc_wxy_password",str];
    return [self md5:ms];
}


// 十六进制转换为普通字符串的。
+(NSString *)stringFromHexString:(NSString *)hexString { //
    
    char *myBuffer = (char *)malloc((int)[hexString length] / 2 + 1);
    bzero(myBuffer, [hexString length] / 2 + 1);
    for (int i = 0; i < [hexString length] - 1; i += 2) {
        unsigned int anInt;
        NSString * hexCharStr = [hexString substringWithRange:NSMakeRange(i, 2)];
        NSScanner * scanner = [[NSScanner alloc] initWithString:hexCharStr];
        [scanner scanHexInt:&anInt];
        myBuffer[i / 2] = (char)anInt;
    }
    NSString *unicodeString = [NSString stringWithCString:myBuffer encoding:4];
    NSLog(@"------字符串=======%@",unicodeString);
    return unicodeString;
}

//普通字符串转换为十六进制的。

+(NSString *)hexStringFromString:(NSString *)string{
    NSData *myD = [string dataUsingEncoding:NSUTF8StringEncoding];
    Byte *bytes = (Byte *)[myD bytes];
    //下面是Byte 转换为16进制。
    NSString *hexStr=@"";
    for(int i=0;i<[myD length];i++)
        
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        
        if([newHexStr length]==1)
            
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        
        else
            
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr]; 
    } 
    return hexStr; 
}


/**
 *  根据字符串获取实际显示长度
 *
 *  @param string 传入字符串
 *  @param font   字符号
 *
 *  @return 实际显示长度
 */
+ (CGFloat)widthOfString:(NSString *)string withFont:(UIFont *)font {
    
    if (string) {
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
        return [[[NSAttributedString alloc] initWithString:string attributes:attributes] size].width;
    }
    return 0;
}


/**
 *  URL encode 转码
 *
 *  @param input 输入原String
 *
 *  @return 输出编码后String
 */
+ (NSString *)encodeToPercentEscapeString: (NSString *) input
{
    // Encode all the reserved characters, per RFC 3986
    // (<http://www.ietf.org/rfc/rfc3986.txt>)
    NSString *outputStr = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)input,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    return outputStr;
}

/**
 *  URL encode 解码
 *
 *  @param input 需要解码String
 *
 *  @return 解码后的原String
 */
+ (NSString *)decodeFromPercentEscapeString: (NSString *) input
{
    NSMutableString *outputStr = [NSMutableString stringWithString:input];
    [outputStr replaceOccurrencesOfString:@"+"
                               withString:@" "
                                  options:NSLiteralSearch
                                    range:NSMakeRange(0, [outputStr length])];
    
    return [outputStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

/**
 *  sha1加密
 *
 *  @return
 */
- (NSString*) sha1
{
    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:self.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}

@end
