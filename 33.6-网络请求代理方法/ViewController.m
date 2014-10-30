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
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://localhost/login.php?username=%@&password=%@",self.loginFiled.text,[self.PwdFiled.text myMD5]]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:0 timeoutInterval:3];
  
    
    // 这个是一个很古老的方法 有十多岁了
    
   [NSURLConnection sendAsynchronousRequest: request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
       if(connectionError == nil){
        //  反序列化
           UserInfo *user = [[UserInfo alloc] init];
           //  就一句话
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
