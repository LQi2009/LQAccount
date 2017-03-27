//
//  LZDetailViewController.m
//  LZAccount
//
//  Created by Artron_LQQ on 16/6/1.
//  Copyright © 2016年 Artup. All rights reserved.
//

#import "LZDetailViewController.h"
#import "LZEditViewController.h"
#import "LZPasswordCell.h"
#import "LZDetailTableViewCell.h"
#import "LZRemarkTableViewCell.h"
#import "LZSqliteTool.h"
//#import "LZPasswordTool.h"
#import "LZWebViewController.h"
#import "LZGestureViewController.h"
#import "LZGestureTool.h"

#import "TouchIdUnlock.h"

@interface LZDetailViewController ()<UITableViewDelegate,UITableViewDataSource,LZGestureViewDelegate>

@property (strong, nonatomic)UITableView *myTableView;
@property (strong, nonatomic)NSArray *titleArray;
@property (strong, nonatomic)NSMutableArray *dataArray;
@end

@implementation LZDetailViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self createData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
//    [self createData];
    [self setupNaviBar];
    [self myTableView];
}
- (void)createData {
    
    self.model = [LZSqliteTool LZSelectElementFromTable:LZSqliteDataTableName identifier:self.identifier];
    
    if (self.dataArray.count > 0) {
        
        [self.dataArray removeAllObjects];
    }
    
    [self.dataArray addObject:self.model.userName];
    [self.dataArray addObject:self.model.nickName];
    [self.dataArray addObject:self.model.password];
    [self.dataArray addObject:self.model.urlString];
    [self.dataArray addObject:self.model.email];
    [self.dataArray addObject:self.model.groupName];
    [self.dataArray addObject:self.model.dsc];
    
    [self.myTableView reloadData];
}
- (NSArray *)titleArray {
    if (_titleArray == nil) {
        _titleArray = [NSArray arrayWithObjects:@"用户名:",@"昵   称:",@"密   码:",@"网   址:",@"邮   箱:",@"分   类:",@"备   注:", nil];
    }
    
    return _titleArray;
}

- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _dataArray;
}

- (void)setupNaviBar {
    [self lzSetNavigationTitle:@"详情"];
    
    LZWeakSelf(ws)
    [self lzSetLeftButtonWithTitle:nil selectedImage:@"houtui" normalImage:@"houtui" actionBlock:^(UIButton *button) {
        LZLog(@"leftButton");
        
        [ws.navigationController popViewControllerAnimated:YES];
    }];
    
    [self lzSetRightButtonWithTitle:nil selectedImage:nil normalImage:@"home_" actionBlock:^(UIButton *button) {
            
            // 进入编辑页的时候需要验证身份
            if ([LZGestureTool isGestureEnable]) {
                
                LZGestureViewController *gesture = [[LZGestureViewController alloc]init];
                
                gesture.delegate = ws;
                [gesture showInViewController:ws type:LZGestureTypeVerifying];
                
                if ([[TouchIdUnlock sharedInstance]isTouchIdEnabledOrNotBySystem]) {
                    
                    [[TouchIdUnlock sharedInstance] startVerifyTouchID:^{
                        
                        [ws pushToEditWithAnimate:NO];
                        [gesture dismiss];
                    }];
                }
            } else {
                
                static BOOL isShowWarn = YES;
                
                if (isShowWarn) {
                    isShowWarn = NO;
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您还没有设置手势密码,您可以在设置中启用手势密码,这样在进行编辑时需要验证,可以更好的保护您的信息安全!" preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                        [ws pushToEditWithAnimate:YES];
                    }];
                    
                    [alert addAction:ok];
                    [ws presentViewController:alert animated:YES completion:nil];
                } else {
                    
                    [ws pushToEditWithAnimate:YES];
                }
            }
        }];
}

- (void)pushToEditWithAnimate:(BOOL)animate {
    
    LZEditViewController *edit = [[LZEditViewController alloc]init];
    edit.model = self.model;
    edit.flog = @"edit";
    edit.defaultGroup = self.defaultGroup;
    [self.navigationController pushViewController:edit animated:animate];
}
- (UITableView *)myTableView {
    if (_myTableView == nil) {
        UITableView *table = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        table.delegate = self;
        table.dataSource = self;
        
        [self.view addSubview:table];
        _myTableView = table;
        
//        LZWeakSelf(ws)
        LZWeak(ws, self.view)
        [table mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.and.bottom.mas_equalTo(ws);
            make.top.mas_equalTo(ws).offset(LZNavigationHeight);
        }];
    }
    
    
    return _myTableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 6) {
        return 120.0;
    } else {
        return 44.0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 1.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1.0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 2) {
        LZPasswordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"passwordCell"];
        if (cell== nil) {
            cell = [[LZPasswordCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"passwordCell"];
            cell.editEnabled = NO;
        }
        
        LZWeakSelf(ws)
        cell.longPressBlock = ^(NSString *string) {
            
            [ws showDetailAlert:string];
        };
        
        cell.showBlock = ^(BOOL show){
            
            if ([LZGestureTool isGestureEnable]) {
                
                if (cell.showPSW == NO) {
                    
                    LZGestureViewController *gesture = [[LZGestureViewController alloc]init];
                    
                    gesture.delegate = ws;
                    gesture.view.tag = 1000;
                    [gesture showInViewController:ws type:LZGestureTypeVerifying];
                    
                    if ([[TouchIdUnlock sharedInstance]isTouchIdEnabledOrNotBySystem]) {
                        
                        [[TouchIdUnlock sharedInstance] startVerifyTouchID:^{
                            
                            //使用通知的方式发送结果,接受者在LZPasswordCell.h
                            [[NSNotificationCenter defaultCenter]postNotificationName:passwordShowNotificationKey object:[NSNumber numberWithBool:YES]];
                            [gesture dismiss];
                        }];
                    }
                } else {
                    
                    //使用通知的方式发送结果,接受者在LZPasswordCell.h
                    [[NSNotificationCenter defaultCenter]postNotificationName:passwordShowNotificationKey object:[NSNumber numberWithBool:NO]];
                }
            } else {
                
                static BOOL isShowWarn = YES;
                
                if (isShowWarn) {
                    isShowWarn = NO;
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您还没有设置手势密码,您可以在设置中启用手势密码,这样在查看密码详情时需要验证,可以更好的保护您的信息安全!" preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                        //使用通知的方式发送结果,接受者在LZPasswordCell.h
                        [[NSNotificationCenter defaultCenter]postNotificationName:passwordShowNotificationKey object:[NSNumber numberWithBool:YES]];
                    }];
                    
                    [alert addAction:ok];
                    [ws presentViewController:alert animated:YES completion:nil];
                } else {
                    
                    //使用通知的方式发送结果,接受者在LZPasswordCell.h
                    [[NSNotificationCenter defaultCenter]postNotificationName:passwordShowNotificationKey object:[NSNumber numberWithBool:!show]];
                }
            }
        };
        
        cell.title = self.titleArray[indexPath.row];
        cell.detailTitle = self.dataArray[indexPath.row];
        return cell;
    } else if (indexPath.row == 6) {
        LZRemarkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"remarkCell"];
        if (cell == nil) {
            cell = [[LZRemarkTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"remarkCell"];
            cell.editEnabled = NO;
        }
        
        cell.title = self.titleArray[indexPath.row];
        cell.detailTitle = self.dataArray[indexPath.row];
        return cell;
    } else {
        LZDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailCell"];
        if (cell == nil) {
            cell = [[LZDetailTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"detailCell"];
            cell.editEnabled = NO;
        }
        
        cell.title = self.titleArray[indexPath.row];
        cell.detailTitle = self.dataArray[indexPath.row];
        return cell;
    }
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detail"];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"detail"];
//    }
//    
//    cell.textLabel.text = @"账号";
//    cell.detailTextLabel.text = @"302934443";
//    return cell;
}

- (void)showDetailAlert:(NSString *)message {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"详情" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:ok];
    
        [self presentViewController:alert animated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 3) {
        
        NSString *str = self.dataArray[indexPath.row];
        if ([str hasPrefix:@"http"]) {
            
            LZWebViewController *web = [[LZWebViewController alloc]init];
            web.urlString = str;
            
            [self.navigationController pushViewController:web animated:YES];
        } else {
            
            [self showDetailAlert:@"网址无效!"];
        }
    }
}


- (void)gestureViewVerifiedSuccess:(LZGestureViewController *)vc {
    
    // 显示密码明文
    if (vc.view.tag == 1000) {
        
        //使用通知的方式发送结果,接受者在LZPasswordCell.h
        [[NSNotificationCenter defaultCenter]postNotificationName:passwordShowNotificationKey object:[NSNumber numberWithBool:YES]];
    } else {
        
        [self pushToEditWithAnimate:NO];
    }
}
- (void)gestureViewCanceled:(LZGestureViewController *)vc {
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
