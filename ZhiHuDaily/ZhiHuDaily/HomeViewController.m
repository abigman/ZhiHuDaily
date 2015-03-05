//
//  HomeViewController.m
//  ZhiHuDaily
//
//  Created by 任龙宇 on 15/1/17.
//  Copyright (c) 2015年 renlongyu. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeTableViewCell.h"
#import "BannerView.h"
#import "AppMacro.h"
#import "DataManager.h"
#import "Model.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface HomeViewController ()

@property (strong, nonatomic) BannerView *bannerView;
@property (strong, nonatomic) NSMutableArray *dataArray;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableHeaderView = self.bannerView;
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    
    NSLog(@"%@", NSHomeDirectory());
    
    [[DataManager manager] requestDataFromServer:^(BOOL success) {
        if (success) {
            NSLog(@"SUCCESS");
            self.dataArray = [[DataManager manager] selectData:15 andOffset:0];

            [self.tableView reloadData];
        } else {
            NSLog(@"ERROR");
        }
    }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Accessor

- (BannerView *)bannerView {
    if (!_bannerView) {
        _bannerView = [[BannerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200) pageCount:5];
        [_bannerView loadImage:nil placeholder:nil];
        _bannerView.timeInterval = 5;
        [self.view addSubview:_bannerView];
    }
    
    return _bannerView;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeTableViewCell" forIndexPath:indexPath];
//    cell.imgView.backgroundColor = RANDOM_COLOR;
    
    Model *model = _dataArray[indexPath.row];
    cell.titleLabel.text = model.title;
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:model.image]];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}



@end
