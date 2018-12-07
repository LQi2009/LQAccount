//
//  LZTouchIDViewController.m
//  LZAccount
//
//  Created by Artron_LQQ on 2016/10/19.
//  Copyright © 2016年 Artup. All rights reserved.
//

#import "LZTouchIDViewController.h"
#import "TouchIdUnlock.h"

@interface LZTouchIDViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
}
@end

@implementation LZTouchIDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupUI];
    [self setupNaviBar];
}

- (void)setupNaviBar {
    [self lzSetNavigationTitle:@"设置 TouchID"];
    [self lzSetLeftButtonWithTitle:nil selectedImage:@"houtui" normalImage:@"houtui" actionBlock:^(UIButton *button) {
        
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)setupUI {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.separatorColor = [UIColor clearColor];
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"touchIDCell"];
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    [self.view addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view).offset(LZNavigationHeight);
    }];
}

#pragma mark - <UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"touchIDCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:identifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.textLabel.font = [UIFont systemFontOfSize:16];
    }
    
    
    UISwitch * sw = [[UISwitch alloc] init];
    
    [sw addTarget:self action:@selector(sw:) forControlEvents:UIControlEventValueChanged];
    
    cell.textLabel.text = @"开启TouchID";
    cell.accessoryView = sw;
    
    sw.on = [[TouchIdUnlock sharedInstance] isTouchIdEnabledOrNotByUser];
    
    
    return cell;
}

- (void)sw:(UISwitch *)sw {
    
    if (sw.on == NO) {
        sw.on = YES;
        if ([[TouchIdUnlock sharedInstance] canVerifyTouchID]) {
            
            [[TouchIdUnlock sharedInstance] startVerifyTouchID:^{
                
                [[TouchIdUnlock sharedInstance] save_TouchIdEnabledOrNotByUser_InUserDefaults:NO];
                sw.on = NO;
            }];
        }
    } else {
        
        [[TouchIdUnlock sharedInstance] save_TouchIdEnabledOrNotByUser_InUserDefaults:YES];
//        if ([[TouchIdUnlock sharedInstance] isTouchIdEnabledOrNotBySystem]) {
//            
//            
//        } else {
//            
//            [SVProgressHUD showErrorWithStatus:@"Touch ID 不可用"];
//            [self performSelector:@selector(switchOff:) withObject:sw afterDelay:1];
//        }
    }
}

- (void)switchOff:(UISwitch *)sw {
    
    sw.on = NO;
}

- (void)dealloc {
    
    NSLog(@"dealloc");
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
