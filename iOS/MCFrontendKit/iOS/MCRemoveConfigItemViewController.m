//
//  MCRemoveConfigItemViewController.m
//  MCFrontendKit
//
//  Created by Rake Yang on 2020/2/23.
//

#import "MCRemoveConfigItemViewController.h"
#import "MCRemoteConfigViewCell.h"
#import "MCFrontendKit.h"

@interface MCRemoveConfigItemViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSDictionary *item;

@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *applyButton;
@property (nonatomic, strong) UILabel *tipLabel;


@end

@implementation MCRemoveConfigItemViewController

- (instancetype)initWithConfigItem:(NSDictionary *)item {
    if (self = [super initWithNibName:nil bundle:nil]) {
        self.item = item;
        self.items = item[@"subItems"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithRed:0xF6/255.0 green:0xF6/255.0 blue:0xF6/255.0 alpha:1.0];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    [self.view addSubview:self.tableView];
    
    [self.tableView registerClass:MCRemoteConfigViewCell.class forCellReuseIdentifier:@"ConfigCell"];
    
    self.applyButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.applyButton.layer.cornerRadius = 8;
    self.applyButton.layer.masksToBounds = YES;
    self.applyButton.backgroundColor = [UIColor cyanColor];
    [self.applyButton setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
    [self.applyButton setTitle:@"应用" forState:UIControlStateNormal];
    [self.view addSubview:self.applyButton];
    [self.applyButton addTarget:self action:@selector(applyConfig:) forControlEvents:UIControlEventTouchUpInside];
    
    self.tipLabel = [UILabel new];
    self.tipLabel.text = @"应用后建议重启App";
    self.tipLabel.textColor = [UIColor grayColor];
    self.tipLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:self.tipLabel];
    [self.tipLabel sizeToFit];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    CGFloat safeBottomInset = 0;
    if (@available(iOS 11.0, *)) {
        safeBottomInset = [UIApplication sharedApplication].keyWindow.safeAreaInsets.bottom;
    }
    self.tableView.mcHeight = self.view.mcHeight - (80+safeBottomInset);
    
    self.applyButton.frame = CGRectMake((self.tableView.mcWidth-180)/2, self.tableView.mcBottom+5, 180, 40);
    
    self.tipLabel.mcLeft = (self.view.mcWidth-self.tipLabel.mcWidth)/2;
    self.tipLabel.mcTop = self.applyButton.mcBottom+5;
}

- (IBAction)applyConfig:(id)sender {
    MCFrontendKit.manager.currentName = self.item[@"name"];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MCRemoteConfigViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ConfigCell" forIndexPath:indexPath];
    
    NSDictionary *item = self.items[indexPath.row];
    cell.textLabel.text = item[@"name"];
    cell.detailTextLabel.text = item[@"value"];
    cell.extraLabel.text = item[@"comment"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *item = self.items[indexPath.row];
    return [MCRemoteConfigViewCell heightForObject:item[@"comment"]];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
