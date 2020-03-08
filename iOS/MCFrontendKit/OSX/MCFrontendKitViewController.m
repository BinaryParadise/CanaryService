//
//  MCFrontendKitViewController.m
//  MCFrontendKit
//
//  Created by Rake Yang on 2020/3/8.
//

#import "MCFrontendKitViewController.h"

@interface MCFrontendKitViewController () <NSTableViewDataSource, NSTableViewDelegate>

@end

@implementation MCFrontendKitViewController

- (instancetype)initWithNibName:(NSNibName)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return 5;
}

@end
