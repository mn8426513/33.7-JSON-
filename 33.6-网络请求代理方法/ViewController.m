//
//  ViewController.m
//  33.6-网络请求代理方法
//
//  Created by Mac on 14-10-28.
//  Copyright (c) 2014年 MN. All rights reserved.
//

#import "ViewController.h"
#import "NSString+Password.h"

@interface ViewController ()<NSURLConnectionDataDelegate>
@property (weak, nonatomic) IBOutlet UITextField *loginFiled;

@property (weak, nonatomic) IBOutlet UITextField *PwdFiled;
- (IBAction)loginBtn;
@property (weak, nonatomic) IBOutlet UILabel *returnLabel;

@property (nonatomic,strong) NSMutableData *data;

@property (nonatomic,strong) NSMutableData
*da;

@property (nonatomic,strong) NSMutableData *d1;


@end

@implementation ViewController
            
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}



-(NSString*)name {

     return  @"hello  name ";

}
- (void)getLogin{
    
    if(self.loginFiled.text==nil|self.PwdFiled.text==nil) return ;
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://localhost/login.php?username=%@&password=%@",self.loginFiled.text,[self.PwdFiled.text myMD5]]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:0 timeoutInterval:3];
  
    
    // 这个是一个很古老的方法 有十多岁了
    
    NSURLConnection  *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    
    dispatch_async(dispatch_queue_create("Myqueue", DISPATCH_QUEUE_CONCURRENT), ^{
        [connection start];
    });
    
}

#pragma  mark  NSURLConnectionDataDelegate 的代理方法
#pragma  mark  接受到响应

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // 准备工作
    // 按钮点击就会有网络请求,为了避免重复开辟空间
    if (!self.data) {
        self.data = [NSMutableData data];
    } else {
        [self.data setData:nil];
    }
}

#pragma mark 接收到数据,如果数据量大,例如视频,会被多次调用
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // 拼接数据,二进制流的体现位置
    [self.data appendData:data];
}

#pragma mark 接收完成,做最终的处理工作
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // 最终处理
    NSString *str = [[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding];
    
    self.returnLabel.text = str;
    NSLog(@"%@ %@ ",  self.returnLabel.text , [NSThread currentThread]);
}

#pragma mark 出错处理,网络的出错可能性非常高
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"%@", error.localizedDescription);
}

- (IBAction)loginBtn {
    
    [self getLogin];
}
@end
