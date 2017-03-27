//
//  LZGroupViewController.m
//  LZAccount
//
//  Created by Artron_LQQ on 16/6/4.
//  Copyright © 2016年 Artup. All rights reserved.
//

#import "LZGroupViewController.h"
#import "LZSqliteTool.h"
#import "LZColorTool.h"
#import "LZDataModel.h"

@interface LZGroupViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    BOOL addNewGroup;
    BOOL deleteGroup;
    
    UIButton *_addNewGroupButton;
    UIButton *_deleteGroupButton;
}
@property (strong, nonatomic)UITableView *tableView;
@property (strong, nonatomic)NSMutableArray *dataArray;
@end

@implementation LZGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupNaviBar];
    NSArray *array = [LZSqliteTool LZSelectAllGroupsFromTable:LZSqliteGroupTableName];
    [self.dataArray addObjectsFromArray:array];
    
    [self tableView];
    
//    [self setupBottomView];
}

- (void)setupBottomView {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.backgroundColor = LZColorFromRGB(0, 112, 50);
    
    UIImage *image = [LZColorTool imageFromColor:[UIColor grayColor]];
    UIImage *normalImg = [LZColorTool imageFromColor:LZColorFromRGB(0, 112, 50)];
    
    [button setBackgroundImage:normalImg forState:UIControlStateNormal];
    [button setBackgroundImage:image forState:UIControlStateDisabled];
    [button setTitle:@"新建分组" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(addGroupButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    _addNewGroupButton = button;
    
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    deleteBtn.backgroundColor = [UIColor redColor];
    
    UIImage *delImage = [LZColorTool imageFromColor:[UIColor redColor]];
    [deleteBtn setBackgroundImage:delImage forState:UIControlStateNormal];
    [deleteBtn setBackgroundImage:image forState:UIControlStateDisabled];
    [deleteBtn setTitle:@"删除分组" forState:UIControlStateNormal];
    [deleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:deleteBtn];
    [deleteBtn addTarget:self action:@selector(deleteGroupButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    _deleteGroupButton = deleteBtn;
    
    LZWeakSelf(ws)
    [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.mas_equalTo(ws.view);
        make.height.mas_equalTo(@50);
        make.width.mas_equalTo(button);
        make.right.mas_equalTo(button.mas_left);
    }];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.mas_equalTo(ws.view);
        make.height.with.mas_equalTo(deleteBtn);
        make.left.mas_equalTo(deleteBtn.mas_right);
    }];
}
- (void)deleteGroupButtonClick:(UIButton *)button {
    
    deleteGroup = YES;
    [self changeButtonState:YES];
}

- (void)addGroupButtonClick:(UIButton*)button {
    
    addNewGroup = YES;
    [self changeButtonState:YES];
}

- (void)changeButtonState:(BOOL)state {
    
    self.rightButton.hidden = !state;
    _addNewGroupButton.enabled = !state;
    _deleteGroupButton.enabled = !state;
    self.tableView.editing = state;
}

- (void)setupNaviBar {
    if ([self.flog isEqualToString:@"setting"]) {
        
        [self lzSetNavigationTitle:@"分组管理"];
    } else {
        
        [self lzSetNavigationTitle:@"选择分组"];
    }
    
    LZWeakSelf(ws)
    [self lzSetLeftButtonWithTitle:nil selectedImage:@"houtui" normalImage:@"houtui" actionBlock:^(UIButton *button) {
        
        if (ws.navigationController) {
            
            [ws.navigationController popViewControllerAnimated:YES];
        } else {
            
            [ws dismissViewControllerAnimated:YES completion:nil];
        }
        
    }];
    
    [self lzSetRightButtonWithTitle:nil selectedImage:@"add_new" normalImage:@"add_new" actionBlock:^(UIButton *button) {
        
        [ws insertNewGroup];
    }];
    
//    self.rightButton.hidden = YES;
}

- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _dataArray;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
        
        LZWeakSelf(ws)
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.and.mas_equalTo(ws.view);
            make.top.mas_equalTo(ws.view).offset(LZNavigationHeight);
            make.bottom.mas_equalTo(ws.view);
        }];
    }
    
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellID"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = [UIColor grayColor];
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressAction:)];
        [cell addGestureRecognizer:longPress];
    }
    
    LZGroupModel *model = [self.dataArray objectAtIndex:indexPath.row];
    cell.textLabel.text = model.groupName;
    return cell;
}
/// 2016.11.30 新增
/// by: LQQ
- (void)longPressAction:(UILongPressGestureRecognizer *)gesture {
    
    UITableViewCell *cell = (UITableViewCell*)gesture.view;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"修改名称" message:@"您可以输入新的分组名称" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
       
        textField.text = cell.textLabel.text;
    }];
    
    LZWeakSelf(ws)
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UITextField *tf = [[alert textFields] firstObject];
        LZGroupModel *model = [ws.dataArray objectAtIndex:indexPath.row];
        model.groupName = tf.text;
        
        [LZSqliteTool LZUpdateGroupTable:LZSqliteGroupTableName model:model];
        cell.textLabel.text = tf.text;
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:ok];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}
//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    if (addNewGroup) {
//        return UITableViewCellEditingStyleInsert;
//    } else if (deleteGroup){
//        return UITableViewCellEditingStyleDelete;
//    } else {
//        return UITableViewCellEditingStyleNone;
//    }
//}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        return;
    }
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"删除分组及分组下的信息,无法恢复,是否继续?" preferredStyle:UIAlertControllerStyleAlert];
        
        LZWeakSelf(ws)
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"继续" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            LZGroupModel *group = [ws.dataArray objectAtIndex:indexPath.row];
            
            
            [LZSqliteTool LZDeleteFromGroupTable:LZSqliteGroupTableName element:group];
            [ws.dataArray removeObject:group];
            
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            
            dispatch_async(queue, ^{
                
                NSArray *arr = [LZSqliteTool LZSelectGroupElementsFromTable:LZSqliteGroupTableName groupID:group.identifier];
                
                if (arr.count > 0) {
                    
                    for (LZDataModel *model in arr) {
                        [LZSqliteTool LZDeleteFromTable:LZSqliteDataTableName element:model];
                    }
                }
            });
        }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        
        [alert addAction:ok];
        [alert addAction:cancel];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }
}

- (void)insertNewGroup {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"新建分组" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    LZWeakSelf(ws)
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSArray *arr = alert.textFields;
        UITextField *text = arr[0];
        LZGroupModel *group = [[LZGroupModel alloc]init];
        group.groupName = text.text;
        [LZSqliteTool LZInsertToGroupTable:LZSqliteGroupTableName model:group];
        
        [ws.dataArray addObject:group];
//        
        [ws.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.dataArray.count - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入组名";
    }];
    
    [alert addAction:ok];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        return nil;
    }
    
    return @"删除";
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.flog isEqualToString:@"setting"]) {
        
        return;
    }
    
    if (self.callBack) {
        
        LZGroupModel *model = [self.dataArray objectAtIndex:indexPath.row];
        self.callBack(model);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 1;
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
