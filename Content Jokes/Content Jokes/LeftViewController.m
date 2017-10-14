//
//  LeftViewController.m
//  Content Jokes
//
//  Created by riber on 15/12/7.
//  Copyright © 2015年 Riber. All rights reserved.
//

#import "LeftViewController.h"
#import "RBContentViewController.h"
#import "RBAppDelegate.h"
#import "RBDBManager.h"
#import "RBCommonSave.h"

#define DBNAME @"ContentJokes.db"
#define DBNAME_COPY @"ContentJokesBak.db"

@interface LeftViewController () <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datasource;

@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"设置";
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat navBarHeight = self.navigationController.navigationBar.frame.size.height;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WINDOW_SIZE.width, WINDOW_SIZE.height-statusBarHeight-navBarHeight) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    _tableView.tableFooterView = [[UIView alloc] init];
    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *path = [paths[0] stringByAppendingPathComponent:DBNAME];
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    unsigned long long fileSize = [fileManager attributesOfItemAtPath:path error:nil].fileSize;
//    NSString *size = [NSString stringWithFormat:@"清除缓存(%.2fM)", fileSize/(1024.0*1024)];
    
    NSArray *array = @[@"关于我们", @"帮助", @"用户使用协议", @"版本信息", @"意见反馈", @"清除缓存"];
    _datasource = [NSMutableArray arrayWithArray:array];
}

- (void)createNavBarItem {
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LeftCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"LeftCell"];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.textLabel.text = _datasource[indexPath.row];
    
    if (indexPath.row == 3) {
        NSDictionary *appInfoDic = [[NSBundle mainBundle] infoDictionary];
        NSString *appVersion = [appInfoDic objectForKey:@"CFBundleShortVersionString"];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"v%@", appVersion];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RBAppDelegate *delegate = [UIApplication sharedApplication].delegate;
    [delegate.drawer toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];

    switch (indexPath.row) {
        case 0:
        {

        }
            break;
        case 1:
        {
            
        }
            break;
        case 2:
        {
            
        }
            break;
        case 3:
        {
            
        }
            break;
        case 4:
        {
            
        }
            break;
        case 5:
        {
            double systemVersion = [[UIDevice currentDevice].systemVersion doubleValue];

            if (systemVersion >= 8.0)
            {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确认清除缓存" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
                UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"清除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                
                    RBDBManager *manager = [RBDBManager defalutDBManager];
                    [manager recoveryDBTables];
                }];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];

                [alertController addAction:doneAction];
                [alertController addAction:cancelAction];
                [self presentViewController:alertController animated:YES completion:nil];
                
            }
            else
            {
                UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"确认清除缓存" delegate: self cancelButtonTitle:@"取消" destructiveButtonTitle:@"清除" otherButtonTitles: nil];
                [sheet showInView:[UIApplication sharedApplication].keyWindow];
            }
        }
            break;
        default:
            break;
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        RBDBManager *manager = [RBDBManager defalutDBManager];
        [manager recoveryDBTables];
        
        [[RBCommonSave defaultCommonSave] deleteMessageWithFile];
    }
}

@end
