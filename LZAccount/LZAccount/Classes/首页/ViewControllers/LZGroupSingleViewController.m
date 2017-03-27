//
//  LZGroupSingleViewController.m
//  LZAccount
//
//  Created by Artron_LQQ on 2016/10/24.
//  Copyright © 2016年 Artup. All rights reserved.
//

#import "LZGroupSingleViewController.h"
#import "LZDataModel.h"
#import "LZSqliteTool.h"
#import "LZDetailViewController.h"
#import "LZEditViewController.h"

@interface LZGroupSingleViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation LZGroupSingleViewController
- (void)dealloc {
    
    LZLog(@"%@--dealloc",NSStringFromClass([self class]));
}

- (void)loadData {
    
    NSArray* array = [LZSqliteTool LZSelectGroupElementsFromTable:LZSqliteDataTableName groupID:self.groupModel.identifier];
    
    if (self.dataArray.count > 0) {
        
        [self.dataArray removeAllObjects];
    }
    
    [self.dataArray addObjectsFromArray:array];
    
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self loadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupNaviBar];
    [self tableView];
}


- (void)setupNaviBar {
    
    [self lzSetNavigationTitle:self.groupModel.groupName];
    LZWeakSelf(ws)
    [self lzSetLeftButtonWithTitle:nil selectedImage:@"houtui" normalImage:@"houtui" actionBlock:^(UIButton *button) {
        
        if (ws.navigationController) {
            
            [ws.navigationController popViewControllerAnimated:YES];
        } else {
            
            [ws dismissViewControllerAnimated:YES completion:nil];
        }
    }];
    
    [self lzSetRightButtonWithTitle:nil selectedImage:@"add_new" normalImage:@"add_new" actionBlock:^(UIButton *button) {
        
        LZEditViewController *edit = [[LZEditViewController alloc]init];
        edit.defaultGroup = ws.groupModel;
        [ws.navigationController pushViewController:edit animated:YES];
    }];
}

- (NSMutableArray *)dataArray {
    
    if (_dataArray == nil) {
        
        _dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _dataArray;
}

- (UITableView *)tableView {
    
    if (_tableView == nil) {
        
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.tableFooterView = [UIView new];
        [self.view addSubview:_tableView];
        
        LZWeakSelf(ws)
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(ws.view).offset(LZNavigationHeight);
            make.left.right.and.mas_equalTo(ws.view);
            make.bottom.mas_equalTo(ws.view);
        }];

    }
    
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LZGroupSingleViewController"];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"LZGroupSingleViewController"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        cell.detailTextLabel.textColor = [UIColor grayColor];
        cell.textLabel.textColor = LZColorGray;
        cell.textLabel.font = LZFontDefaulte;
    }
    
    LZDataModel *model = self.dataArray[indexPath.row];
    cell.textLabel.text = model.nickName;
    cell.detailTextLabel.text = model.dsc;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LZDetailViewController *detail = [[LZDetailViewController alloc]init];
    
    LZDataModel *model = [self.dataArray objectAtIndex:indexPath.row];
    
    detail.identifier = model.identifier;
    detail.defaultGroup = self.groupModel;
    
    [self.navigationController pushViewController:detail animated:YES];

}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"数据删除后,不可恢复,是否确定删除?" preferredStyle:UIAlertControllerStyleAlert];
    
    LZWeakSelf(ws)
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [LZSqliteTool LZDeleteFromTable:LZSqliteDataTableName element:[ws.dataArray objectAtIndex:indexPath.row]];
        [ws.dataArray removeObjectAtIndex:indexPath.row];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];

        // 当为0时 删除分组?
//        if (self.dataArray == 0) {
//            
//            [LZSqliteTool LZDeleteFromGroupTable:LZSqliteGroupTableName element:self.groupModel];
//        }
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:ok];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return @"删除";
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
