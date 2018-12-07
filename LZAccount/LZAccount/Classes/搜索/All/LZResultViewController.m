//
//  LZResultViewController.m
//  LZAccount
//
//  Created by Artron_LQQ on 2016/12/17.
//  Copyright © 2016年 Artup. All rights reserved.
//

#import "LZResultViewController.h"
#import "ChineseToPinyin.h"
#import "LZDataModel.h"
#import "LZSqliteTool.h"


@interface LZResultViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *results;
@property (nonatomic, strong) NSMutableArray *datas;
@end

@implementation LZResultViewController
- (NSMutableArray *)results {
    if (_results == nil) {
        _results = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _results;
}

- (NSMutableArray *)datas {
    if (_datas == nil) {
        _datas = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _datas;
}
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
        
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view).offset(LZNavigationHeight);
            make.left.right.and.bottom.mas_equalTo(self.view).offset(-LZTabBarHeight);
        }];
    }
    
    return _tableView;
}

- (void)loadData {
    
    NSArray* array = [LZSqliteTool LZSelectAllElementsFromTable:LZSqliteDataTableName];
    
    if (self.datas.count > 0) {
        
        [self.datas removeAllObjects];
    }
    
    [self.datas addObjectsFromArray:array];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UILabel *label = [[UILabel alloc]init];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:14];
    label.text = @"无结果";
    label.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 44);
    self.tableView.tableFooterView = label;
    [self loadData];
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.results.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchCell"];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"searchCell"];
    }
    
    LZDataModel *model = [self.results objectAtIndex:indexPath.row];
    
    cell.textLabel.text = model.nickName;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LZDataModel *model = [self.results objectAtIndex:indexPath.row];
    
    
    if (self.selectResult) {
        self.selectResult(model);
    }
    
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    NSString *result = searchController.searchBar.text;
    
    if (self.results.count > 0) {
        [self.results removeAllObjects];
    }
    
    for (LZDataModel *model in self.datas) {
        
        NSString *pinyin = [ChineseToPinyin pinyinFromChiniseString:model.nickName];
        
        if ([[pinyin lowercaseString] rangeOfString:[result lowercaseString]].location != NSNotFound ) {
            
            [self.results addObject:model];
        }
    }
    
    
    
    if (self.results.count > 0) {
        
        [self.tableView reloadData];
        
        UILabel *label = (UILabel*)self.tableView.tableFooterView;
        
        label.text = [NSString stringWithFormat:@"匹配到 %lu 个结果", (unsigned long)self.results.count];
    }
    
}

//- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
//    
////    self.
//    
//    NSLog(@"%@", NSStringFromCGRect(searchBar.frame));
//    
//    return YES;
//}
//- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
//    
//}
//- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
//    
//    return YES;
//}
//- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
//    
//}
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

@interface LZSearchFooterView : UIView

@end

@implementation LZSearchFooterView



@end
