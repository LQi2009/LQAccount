//
//  LZMainViewController.m
//  LZAccount
//
//  Created by Artron_LQQ on 16/5/30.
//  Copyright © 2016年 Artup. All rights reserved.
//

#import "LZMainViewController.h"
#import "AppDelegate.h"
#import "LZMainHeaderView.h"
#import "LZEditViewController.h"

#import "LZSqliteTool.h"

#import "LZGroupSingleViewController.h"

@interface LZMainViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger _currentSection;
}
@property (strong, nonatomic)UITableView *myTableView;
@property (strong, nonatomic)NSMutableArray *groupArray;
@end

@implementation LZMainViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self loadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _currentSection = -1;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(sqliteValuesChangedNotification:) name:LZSqliteValuesChangedKey object:nil];
    
    [self setupNaviBar];
    [self myTableView];
    
    if (self.flog!=nil)
    {
        [self addAccountNumberAnimated:NO];
    }
}

#pragma mark -- 添加账号
-(void)addAccountNumberAnimated:(BOOL)isAnimation
{
    LZEditViewController *edit = [[LZEditViewController alloc]init];
    edit.defaultGroup = [self.groupArray firstObject];
    [self.navigationController pushViewController:edit animated:isAnimation];
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)loadData {
    NSArray *arr = [LZSqliteTool LZSelectAllGroupsFromTable:LZSqliteGroupTableName];
    
    if (self.groupArray.count > 0) {
        
        [self.groupArray removeAllObjects];
    }
    
    [self.groupArray addObjectsFromArray:arr];
    
    [self.myTableView reloadData];
}

- (NSMutableArray *)groupArray {
    if (_groupArray == nil) {
        _groupArray = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _groupArray;
}

- (void)setupNaviBar {
    [self lzSetNavigationTitle:@"分组列表"];
    
    LZWeakSelf(ws)
    [self lzSetRightButtonWithTitle:nil selectedImage:@"add_new" normalImage:@"add_new" actionBlock:^(UIButton *button) {

        
        [ws addAccountNumberAnimated:YES];
    }];
}

- (UITableView *)myTableView {
    if (_myTableView == nil) {
        UITableView *table = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        table.delegate = self;
        table.dataSource = self;
        table.tableFooterView = [UIView new];
        
        [self.view addSubview:table];
        _myTableView = table;
        
        LZWeakSelf(ws)
        [table mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(ws.view).offset(LZNavigationHeight);
            make.left.right.and.mas_equalTo(ws.view);
            make.bottom.mas_equalTo(ws.view).offset(-LZTabBarHeight);
        }];
        
        [table registerClass:[LZMainHeaderView class] forHeaderFooterViewReuseIdentifier:@"LZMainHeaderView"];
    }
    
    
    return _myTableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.groupArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableViewCellID"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tableViewCellID"];
        cell.textLabel.textColor = LZColorGray;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    LZGroupModel *model = [self.groupArray objectAtIndex:indexPath.row];
    cell.textLabel.text = model.groupName;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    LZGroupSingleViewController *single = [[LZGroupSingleViewController alloc]init];
    single.groupModel = [self.groupArray objectAtIndex:indexPath.row];
    
    [self.navigationController pushViewController:single animated:YES];
    return;
}

- (void)sqliteValuesChangedNotification:(NSNotification*)noti {
    
//    for (NSMutableArray *array in self.dataArray) {
//        
////        [array removeAllObjects];
//    }
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
