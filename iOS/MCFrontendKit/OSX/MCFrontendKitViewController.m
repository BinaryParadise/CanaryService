//
//  MCFrontendKitViewController.m
//  MCFrontendKit
//
//  Created by Rake Yang on 2020/3/8.
//

#import "MCFrontendKitViewController.h"
#import "MCFrontendKit.h"
#import "MCRemoteConfigItemView.h"

#define kIdentifier @"MCRemoteConfigItemView"

@interface MCFrontendKitViewController () <NSCollectionViewDataSource, NSCollectionViewDelegate>
@property (weak) IBOutlet NSCollectionView *collectionView;
@property (nonatomic, strong) NSArray *remoteConfig;

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
    
//    [self.collectionView registerClass:MCRemoteConfigItemView.class forItemWithIdentifier:kIdentifier];
    
    __weak typeof(self) self_weak = self;
    [[MCFrontendKit manager] fetchRemoteConfig:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self_weak reloadData];
        });
    }];
}

- (void)awakeFromNib {
    NSNib *nib = [[NSNib alloc] initWithNibNamed:@"MCRemoteConfigItemView" bundle:[NSBundle bundleForClass:self.class]];
    [self.collectionView registerNib:nib forItemWithIdentifier:kIdentifier];
}

- (void)reloadData {
//    NSMutableArray *marr = [NSMutableArray array];
//    [MCFrontendKit.manager.remoteConfig enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        [marr addObject:@{@"name":obj[@"name"]}];
//        [marr addObjectsFromArray:obj[@"items"]];
//    }];
    self.remoteConfig = MCFrontendKit.manager.remoteConfig;
    [self.collectionView reloadData];
}

- (NSInteger)numberOfSectionsInCollectionView:(NSCollectionView *)collectionView {
    return self.remoteConfig.count;
}

- (NSInteger)collectionView:(NSCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSArray *items = self.remoteConfig[section][@"items"];
    return items.count;
}

- (NSCollectionViewItem *)collectionView:(NSCollectionView *)collectionView itemForRepresentedObjectAtIndexPath:(NSIndexPath *)indexPath {
    MCRemoteConfigItemView *itemView = [collectionView makeItemWithIdentifier:kIdentifier forIndexPath:indexPath];
    NSDictionary *group = [self.remoteConfig objectAtIndex:indexPath.section];
    NSDictionary *item = group[@"items"][indexPath.item];
    //    cell.checked = [item[@"name"] isEqual:MCFrontendKit.manager.currentName];
    itemView.textField.stringValue = item[@"name"];
    return itemView;
}

@end
