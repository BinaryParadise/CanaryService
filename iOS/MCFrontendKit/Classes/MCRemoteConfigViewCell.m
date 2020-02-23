//
//  MCRemoteConfigViewCell.m
//  MCFrontendKit
//
//  Created by Rake Yang on 2020/2/23.
//

#import "MCRemoteConfigViewCell.h"

@interface MCRemoteConfigViewCell ()

@end

@implementation MCRemoteConfigViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier]) {
        self.textLabel.font = [UIFont fontWithName:@"DINAlternate-Bold" size:18];
        self.detailTextLabel.font = [UIFont fontWithName:@"DINCondensed-Bold" size:15];
        self.detailTextLabel.textColor = [UIColor lightGrayColor];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.accessoryType = self.checked ? UITableViewCellAccessoryCheckmark:UITableViewCellAccessoryNone;
    
    self.detailTextLabel.mcTop = self.textLabel.mcBottom+6;
}

@end
