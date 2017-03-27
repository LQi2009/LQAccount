//
//  LZEditViewController.m
//  LZAccount
//
//  Created by Artron_LQQ on 16/6/1.
//  Copyright © 2016年 Artup. All rights reserved.
//

#import "LZEditViewController.h"
#import "LZPasswordCell.h"
#import "LZDetailTableViewCell.h"
#import "LZRemarkTableViewCell.h"
#import "LZGroupTableViewCell.h"
#import "LZFoldButton.h"
#import "LZSqliteTool.h"
#import "LZGroupViewController.h"

#import "LZGestureViewController.h"
#import "LZGestureTool.h"

@interface LZEditViewController ()
<UITableViewDelegate,UITableViewDataSource,LZGestureViewDelegate>
{
    LZGroupModel *_groupModel;
    
    UITextView *_textView;
}
@property (strong, nonatomic)UITableView *myTableView;
@property (strong, nonatomic)NSArray *titleArray;
@property (strong, nonatomic)NSMutableArray *dataArray;
@end

@implementation LZEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupNaviBar];
    
    if ([self.flog isEqualToString:@"edit"]) {
        [self createData];
    }else {
        for (int i = 0; i < self.titleArray.count; i++) {
            
            if (i == 5 && self.defaultGroup) {
                
                [self.dataArray addObject:self.defaultGroup.groupName];
            } else {
                
                [self.dataArray addObject:@""];
            }
        }
    }
    
    [self myTableView];
    
}

- (void)createData {
    
    [self.dataArray addObject:self.model.userName];
    [self.dataArray addObject:self.model.nickName];
    [self.dataArray addObject:self.model.password];
    [self.dataArray addObject:self.model.urlString];
    [self.dataArray addObject:self.model.email];
    [self.dataArray addObject:self.model.groupName];
    [self.dataArray addObject:self.model.dsc];
}

- (NSArray *)titleArray {
    if (_titleArray == nil) {
        _titleArray = [NSArray arrayWithObjects:@"用户名:", @"昵   称:", @"密   码:", @"网   址:", @"邮   箱:", @"分   类:", @"备   注:", nil];
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
    [self lzSetNavigationTitle:@"编辑"];
    
    LZWeakSelf(ws)
    [self lzSetLeftButtonWithTitle:nil selectedImage:@"houtui" normalImage:@"houtui" actionBlock:^(UIButton *button) {
        LZLog(@"leftButton");
        
        [ws.navigationController popViewControllerAnimated:YES];
    }];
    
    [self lzSetRightButtonWithTitle:nil selectedImage:@"save" normalImage:@"save" actionBlock:^(UIButton *button) {
        LZLog(@"rightButton");
        
        [ws doneButtonClick];
    }];

}

- (void)doneButtonClick {
    LZWeakSelf(ws)
    LZDataModel *model = nil;
    if (self.model != nil) {
        model = self.model;
    } else {
        model = [[LZDataModel alloc]init];
    }
    
    LZDetailTableViewCell *cell0 = [self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    model.userName = cell0.detailField.text;
    
    LZDetailTableViewCell *cell1 = [self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    model.nickName = cell1.detailField.text;
    
    if (model.nickName.length <= 0) {
        
        [SVProgressHUD showErrorWithStatus:@"昵称不能为空!"];
        return;
    }
    
    LZPasswordCell *cell2 = [self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    model.password = cell2.detailField.text;
    
    LZDetailTableViewCell *cell3 = [self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    model.urlString = cell3.detailField.text;
    
    LZDetailTableViewCell *cell4 = [self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
    model.email = cell4.detailField.text;
    
    LZDetailTableViewCell *cell5 = [self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
    model.groupName = cell5.detailField.text;

    if (_groupModel) {
        model.groupID = _groupModel.identifier;
    } else {
        
        model.groupName = self.defaultGroup.groupName;
    }
    
    if (model.groupID == nil || model.groupID.length <= 0) {
        model.groupID = self.defaultGroup.identifier;
    }
    
    LZRemarkTableViewCell *cell6 = [self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:0]];
    model.dsc = cell6.textView.text;
    
    NSString *message = nil;
    if ([self.flog isEqualToString:@"edit"]) {
        message = @"恭喜,修改成功,是否保存?";
    } else {
        message = @"恭喜,添加成功,是否保存?";
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"保存" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([ws.flog isEqualToString:@"edit"]) {
            [LZSqliteTool LZUpdateTable:LZSqliteDataTableName model:model];
        } else {
            [LZSqliteTool LZInsertToTable:LZSqliteDataTableName model:model];
            LZLog(@"添加了数据:%@",model.groupID);
        }
        
        [ws.navigationController popViewControllerAnimated:YES];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:LZSqliteValuesChangedKey object:nil];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:ok];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];

}

- (UITableView *)myTableView {
    if (_myTableView == nil) {
        UITableView *table = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        table.delegate = self;
        table.dataSource = self;
        
        [table setKeyboardDismissMode:UIScrollViewKeyboardDismissModeOnDrag];
        
        [self.view addSubview:table];
        _myTableView = table;
        
        LZWeakSelf(ws)
        [table mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.and.bottom.mas_equalTo(ws.view);
            make.top.mas_equalTo(ws.view).offset(LZNavigationHeight);
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
            cell.editEnabled = YES;
        }
        
        cell.showBlock = ^(BOOL show){
            
            //使用通知的方式发送结果
            [[NSNotificationCenter defaultCenter]postNotificationName:passwordShowNotificationKey object:[NSNumber numberWithBool:!show]];
        };

        cell.title = self.titleArray[indexPath.row];
        cell.detailTitle = self.dataArray[indexPath.row];
        return cell;
    } else if (indexPath.row == 6) {
        LZRemarkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"remarkCell"];
        if (cell == nil) {
            cell = [[LZRemarkTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"remarkCell"];
            cell.editEnabled = YES;
        }
        
        cell.title = self.titleArray[indexPath.row];
        cell.detailTitle = self.dataArray[indexPath.row];
        _textView = cell.textView;
        return cell;
    } else if (indexPath.row == 5){
        LZDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"groupCell"];
        if (cell == nil) {
            cell = [[LZDetailTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"groupCell"];
            cell.editEnabled = NO;
        }
        
        cell.title = self.titleArray[indexPath.row];
        cell.detailTitle = self.dataArray[indexPath.row];
        return cell;
    } else {
        LZDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailCell"];
        if (cell == nil) {
            cell = [[LZDetailTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"detailCell"];
            cell.editEnabled = YES;
        }
        
        if (indexPath.row == 3) {
            cell.detailField.keyboardType = UIKeyboardTypeURL;
        }
        
        cell.title = self.titleArray[indexPath.row];
        cell.detailTitle = self.dataArray[indexPath.row];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 5) {
        LZGroupViewController *group = [[LZGroupViewController alloc]init];
        
        group.callBack = ^(id model) {
            
            LZGroupModel *group = (LZGroupModel*)model;
            LZDetailTableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
            cell.detailTitle = group.groupName;
            
            _groupModel = group;
            LZLog(@"选择了分组:%@",group.identifier);
        };
        [self.navigationController pushViewController:group animated:YES];
    } else if (indexPath.row == 6) {
        
        [_textView becomeFirstResponder];
    }
}

- (void)gestureViewVerifiedSuccess:(LZGestureViewController *)vc {
    
    //使用通知的方式发送结果,接受者在LZPasswordCell.h
    [[NSNotificationCenter defaultCenter]postNotificationName:passwordShowNotificationKey object:[NSNumber numberWithBool:YES]];
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
