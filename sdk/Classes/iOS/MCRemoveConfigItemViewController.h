//
//  MCRemoveConfigItemViewController.h
//  MCFrontendKit
//
//  Created by Rake Yang on 2020/2/23.
//
#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#else
#import <AppKit/AppKit.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@interface MCRemoveConfigItemViewController : UIViewController

- (instancetype)initWithConfigItem:(NSDictionary *)item;

@end

NS_ASSUME_NONNULL_END
