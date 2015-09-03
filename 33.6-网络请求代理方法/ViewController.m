//
//  ViewController.m
//  33.6-网络请求代理方法
//
//  Created by Mac on 14-10-28.
//  Copyright (c) 2014年 MN. All rights reserved.
//

#import "ViewController.h"
#import "NSString+Password.h"
#import "UserInfo.h"

@interface ViewController ()<NSURLConnectionDataDelegate>
@property (weak, nonatomic) IBOutlet UITextField *loginFiled;

@property (weak, nonatomic) IBOutlet UITextField *PwdFiled;
- (IBAction)loginBtn;
@property (weak, nonatomic) IBOutlet UILabel *returnLabel;




@end

@implementation ViewController
            
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}



- (void)getLogin{
    
    if(self.loginFiled.text==nil|self.PwdFiled.text==nil) return ;
    
    NSString *str =[NSString stringWithFormat:@"http://localhost/login.php?username=%@&password=%@",self.loginFiled.text,[self.PwdFiled.text myMD5]];
    
    
    // 如果URL中含有中文字符或者特殊字符的话，例如空格键 ，登录自己服务器会出错，需要转义
    NSString *urlStr = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    // 如果有了百分转义，怎么还原到原来的中文字符，也是通过一个方法
    
    NSString *removePercent = [urlStr stringByRemovingPercentEncoding];
    
    NSLog(@"%@",removePercent);
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:0 timeoutInterval:3];
  
    
    // 这个是一个很古老的方法 有十多岁了
    [NSURLConnection sendAsynchronousRequest: request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
       
       
       if(connectionError){
           NSLog(@"%@",connectionError.localizedDescription);
          
          //在网络开发中，最容易出错的是忘记在主线程中更新UI
           /**
            也可以使用
             [[NSOperationQueue mainQueue] addOperationWithBlock:^{
             UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"连接失败" message:@"网络非常地不给力" delegate:nil cancelButtonTitle:@"好吧" otherButtonTitles: @"再加载一次", nil];
                         [view show];
                    }];
            */
          
           
           dispatch_async(dispatch_get_main_queue(), ^{
               UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"连接失败" message:@"网络非常地不给力" delegate:nil cancelButtonTitle:@"好吧" otherButtonTitles: @"再加载一次", nil];
               [view show];
            });
 
           
        }else {
              //  反序列化就一句话
              UserInfo *user = [[UserInfo alloc] init];
              /**
               对于公司的日常开发，数据都是公司后台服务器人员提供的，因此能够清楚的知道等到的数据类型。
               
               如果看到枚举的第一个选项值不为0，意味着0代表什么特殊功能都不做，性能最好
               
               typedef NS_OPTIONS(NSUInteger, NSJSONReadingOptions)       {
               NSJSONReadingMutableContainers = (1UL << 0), 根节点可变
               NSJSONReadingMutableLeaves = (1UL << 1),     叶子可变
               NSJSONReadingAllowFragments = (1UL << 2)     允许碎片  默认情况下是NSArray和NSDictionary  可以用这个设置其他类型
               } NS_ENUM_AVAILABLE(10_7, 5_0);
               */
              NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
              [user setValuesForKeysWithDictionary:dict];
              
              [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                  
                  self.returnLabel.text = user.userName;
              }];
          }
       }];
    
}

- (IBAction)loginBtn {
    
    [self getLogin];
}
@end
