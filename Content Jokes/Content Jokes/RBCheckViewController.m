//
//  RBCheckViewController.m
//  Content Jokes
//
//  Created by qianfeng on 15-1-23.
//  Copyright (c) 2015年 Riber. All rights reserved.
//

#import "RBCheckViewController.h"
//#import "UMSocial.h"

@interface RBCheckViewController ()

@end

@implementation RBCheckViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"登录";
}

//- (IBAction)weChatLogin:(id)sender {
//    
//}
//
//- (IBAction)qqLogin:(id)sender {
//
//}
//
//- (IBAction)sinaLogin:(id)sender {
//    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
//    [self login:snsPlatform];
//}
//
//- (IBAction)tencentWeiboLogin:(id)sender {
//    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToTencent];
//    [self login:snsPlatform];
//}
//
//- (IBAction)renrenLogin:(id)sender {
//    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToRenren];
//    [self login:snsPlatform];
//}
//
//- (IBAction)kaixinNetLogin:(id)sender {
//    
//}
//
- (IBAction)checkboxClick:(UIButton *)button {
    button.selected = !button.selected;
}
//
//- (void)login:(UMSocialSnsPlatform *)snsPlatform {
//    //获取微博用户名、uid、token等
//    snsPlatform.loginClickHandler(self, [UMSocialControllerService defaultControllerService], YES, ^(UMSocialResponseEntity *response) {
//        if (response.responseCode == UMSResponseCodeSuccess) {
//            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToSina];//UMSocialResponseEntity 错误
//            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
//            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:snsAccount.iconURL]];
//            [self.leftBtn setImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
//        }
//    });
//}

@end
