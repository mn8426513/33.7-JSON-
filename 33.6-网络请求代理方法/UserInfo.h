//
//  UserInfo.h
//  33.6-网络请求代理方法
//
//  Created by Mac on 14-10-30.
//  Copyright (c) 2014年 MN. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface UserInfo : NSObject

//NSInteger 在拼接字符串的时候会出现麻烦
//  1> 在拼接字符串的时候最好不要用 NSInteger
//  2> 在kvc中如果从服务器传下来的数据是数字，model最好使用NSNumber

@property (nonatomic,copy) NSString *userName;
@property (nonatomic,strong) NSNumber *userId;
@property (nonatomic,copy) NSString *userPwd;

@end
