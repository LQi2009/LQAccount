//
//  LZAllViewController.m
//  LZAccount
//
//  Created by Artron_LQQ on 2016/12/16.
//  Copyright © 2016年 Artup. All rights reserved.
//

#import "LZAllViewController.h"
#import "LZSqliteTool.h"
#import "LZDataModel.h"
#import "LZSortTool.h"

#import "LZResultViewController.h"
#import "LZDetailViewController.h"

@interface LZHeaderView : UITableViewHeaderFooterView

@property (nonatomic,strong)UILabel *titleLabel;
@end

@interface LZAllViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *datas;
@property (nonatomic, strong)UISearchController *searchController;
@property (nonatomic, strong)NSMutableArray *indexTitles;
@end

@implementation LZAllViewController
- (NSMutableArray *)datas {
    if (_datas == nil) {
        _datas = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _datas;
}

- (NSMutableArray *)indexTitles {
    if (_indexTitles == nil) {
        _indexTitles = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _indexTitles;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.tableFooterView = [UIView new];
        [self.view addSubview:_tableView];
        
        LZWeakSelf(ws)
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(ws.view).offset(LZNavigationHeight);
            make.left.right.and.mas_equalTo(ws.view);
            make.bottom.mas_equalTo(ws.view).offset(-LZTabBarHeight);
        }];
    }
    
    return _tableView;
}

- (void)loadData {
    
    NSArray* array = [LZSqliteTool LZSelectAllElementsFromTable:LZSqliteDataTableName];
    
    if (self.datas.count > 0) {
        
        [self.datas removeAllObjects];
    }
    
    NSArray *sortedArr = [LZSortTool sortObjcs:array byKey:@"nickName" withSortType:LZSortResultTypeDoubleValues];
    
    [self.datas addObjectsFromArray:sortedArr];
    
    
    
    if (self.indexTitles.count > 0) {
        
        [self.indexTitles removeAllObjects];
    }
    
    for (NSDictionary *dic in sortedArr) {
        
        [self.indexTitles addObject:[dic objectForKey:LZSortToolKey]];
    }
    
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
//    [self tableView];
    [self setupSearchBar];
    
    // 使索引条悬浮在table上
    // 索引条文字颜色
    self.tableView.sectionIndexColor = [UIColor whiteColor];
    
//    self.tableView.sectionIndexMinimumDisplayRowCount
    // 索引条未点击状态下的背景色
    self.tableView.sectionIndexBackgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    // 索引条点击状态下的背景色
    self.tableView.sectionIndexTrackingBackgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];;
    
    [self.tableView registerClass:[LZHeaderView class] forHeaderFooterViewReuseIdentifier:@"LZHeaderView"];
}
- (void)setupSearchBar {
    
    LZResultViewController *result = [[LZResultViewController alloc]init];
    
    UISearchController *search = [[UISearchController alloc]initWithSearchResultsController:result];
    
    result.selectResult = ^(LZDataModel *model) {
        
        LZDetailViewController *detail = [[LZDetailViewController alloc]init];
        detail.identifier = model.identifier;
        
        [self.navigationController pushViewController:detail animated:YES];
        
        search.searchBar.text = @"";
    };
    
    search.searchResultsUpdater = result;
    search.searchBar.delegate = self;
    self.tableView.tableHeaderView = search.searchBar;
    
    //是否添加半透明覆盖层
    search.dimsBackgroundDuringPresentation = YES;
    //是否隐藏导航栏
    search.hidesNavigationBarDuringPresentation = YES;
    
    self.definesPresentationContext = YES;
    
    self.searchController = search;
    
}
- (void)setupNaviBar {
    
    [self lzSetNavigationTitle:@"搜索"];
    LZWeakSelf(ws)
//    [self lzSetLeftButtonWithTitle:nil selectedImage:@"houtui" normalImage:@"houtui" actionBlock:^(UIButton *button) {
//        
//        if (ws.navigationController) {
//            
//            [ws.navigationController popViewControllerAnimated:YES];
//        } else {
//            
//            [ws dismissViewControllerAnimated:YES completion:nil];
//        }
//    }];
    
//    [self lzSetRightButtonWithTitle:@"新建" selectedImage:nil normalImage:nil actionBlock:^(UIButton *button) {
//        
//        LZEditViewController *edit = [[LZEditViewController alloc]init];
//        edit.defaultGroup = ws.groupModel;
//        [ws.navigationController pushViewController:edit animated:YES];
//    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.datas.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSDictionary *dic = [self.datas objectAtIndex:section];
    NSArray *data = [dic objectForKey:LZSortToolValueKey];
    return data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([self class])];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        cell.detailTextLabel.textColor = [UIColor grayColor];
        cell.textLabel.textColor = LZColorGray;
        cell.textLabel.font = LZFontDefaulte;
    }
    
    NSDictionary *dic = [self.datas objectAtIndex:indexPath.section];
    NSArray *data = [dic objectForKey:LZSortToolValueKey];
    
    LZDataModel *model = data[indexPath.row];
    cell.textLabel.text = model.nickName;
    cell.detailTextLabel.text = model.dsc;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    LZHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"LZHeaderView"];
    
    NSDictionary *dic = [self.datas objectAtIndex:section];
    NSString *title = [dic objectForKey:LZSortToolKey];
    
    header.titleLabel.text = title;
    return header;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dic = [self.datas objectAtIndex:indexPath.section];
    NSArray *data = [dic objectForKey:LZSortToolValueKey];
    LZDataModel *model = [data objectAtIndex:indexPath.row];
    
    LZDetailViewController *detail = [[LZDetailViewController alloc]init];
    detail.identifier = model.identifier;
    
    [self.navigationController pushViewController:detail animated:YES];
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    
    
    return self.indexTitles;
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    
    return YES;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.view).offset(20);
    }];
    [UIView animateWithDuration:0.2 animations:^{
        
        [self.tableView layoutIfNeeded];
        
    }];
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    
    
    return YES;
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.view).offset(LZNavigationHeight);
    }];
    [UIView animateWithDuration:0.7 animations:^{
        
        [self.tableView layoutIfNeeded];
    }];
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



@implementation LZHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self setMainView];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setMainView];
    }
    
    return self;
}

- (void)setMainView {
    UILabel *label = [[UILabel alloc]init];
    label.textColor = LZColorFromRGB(142, 142, 142);
    label.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:label];
    self.titleLabel = label;
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(10);
        make.top.mas_equalTo(self.contentView).offset(4);
        make.bottom.mas_equalTo(self.contentView).offset(-4);
        make.right.mas_equalTo(self.contentView).offset(-10);
    }];
}

@end
