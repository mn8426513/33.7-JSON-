//
//  UserInfo.m
//  33.6-网络请求代理方法
//
//  Created by Mac on 14-10-30.
//  Copyright (c) 2014年 MN. All rights reserved.
//

#import "UserInfo.h"
@implementation UserInfo
// 一般Model开发时decription是需要写的，便于打印，看实际参数，注意写法

-(NSString*)description {
// 考虑到子类继承要用 [self class];
   return [NSString stringWithFormat: @"<%@: %p>  {userName: %@ ,userPwd: %@  userId: %@",[self class],self,self.userName,self.userPwd,self.userId];
}

@end
