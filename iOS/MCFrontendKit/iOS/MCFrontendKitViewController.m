//
//  MCFrontendKitViewController.m
//  MCFrontendKit
//
//  Created by Rake Yang on 2020/2/22.
//  Copyright © 2020 BinaryParadise. All rights reserved.
//

#import "MCFrontendKitViewController.h"
#import "MCFrontendKit.h"
#import "MCRemoveConfigItemViewController.h"
#import "MCRemoteConfigViewCell.h"

@interface MCFrontendKitViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray *remoteConfig;

@end

@implementation MCFrontendKitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"远程配置";
    self.remoteConfig = MCFrontendKit.manager.remoteConfig;
    
    self.view.backgroundColor = [UIColor colorWithRed:0xF6/255.0 green:0xF6/255.0 blue:0xF6/255.0 alpha:1.0];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    [self.view addSubview:self.tableView];
    
    [self.tableView registerClass:MCRemoteConfigViewCell.class forCellReuseIdentifier:@"ConfigCell"];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(closeView:)];
    
    __weak typeof(self) self_weak = self;
    [[MCFrontendKit manager] fetchRemoteConfig:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            self_weak.remoteConfig = MCFrontendKit.manager.remoteConfig;
            [self_weak.tableView reloadData];
        });
    }];
}

- (IBAction)closeView:(id)sender {
    [MCFrontendKit.manager hide];
    [self dismissViewControllerAnimated:YES completion:^{
        [MCFrontendKit.manager hide];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.remoteConfig.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDictionary *group = [self.remoteConfig objectAtIndex:section];
    NSArray *items = group[@"items"];
    return items.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSDictionary *group = [self.remoteConfig objectAtIndex:section];
    return group[@"name"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MCRemoteConfigViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ConfigCell" forIndexPath:indexPath];
    
    NSDictionary *group = [self.remoteConfig objectAtIndex:indexPath.section];
    NSDictionary *item = group[@"items"][indexPath.row];
    cell.textLabel.text = item[@"name"];
    cell.detailTextLabel.text = item[@"comment"];
    cell.checked = [item[@"name"] isEqual:MCFrontendKit.manager.currentName];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *group = [self.remoteConfig objectAtIndex:indexPath.section];
    NSDictionary *item = group[@"items"][indexPath.row];
    UIViewController *vc = [[MCRemoveConfigItemViewController alloc] initWithConfigItem:item];
    vc.title = item[@"name"];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem.title = @"";
    [self.navigationController pushViewController:vc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
