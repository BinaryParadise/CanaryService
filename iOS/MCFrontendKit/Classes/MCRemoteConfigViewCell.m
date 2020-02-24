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
        self.detailTextLabel.font = [UIFont fontWithName:@"DINCondensed" size:16];
        self.detailTextLabel.textColor = [UIColor systemOrangeColor];
        
        self.extraLabel = [UILabel new];
        self.extraLabel.lineBreakMode = NSLineBreakByCharWrapping;
        self.extraLabel.numberOfLines = 0;
        self.extraLabel.font = [UIFont fontWithName:@"Baskerville-Italic" size:14];
        self.extraLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:self.extraLabel];
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
    self.textLabel.mcTop = 12;
    self.detailTextLabel.mcTop = self.textLabel.mcBottom+6;
    
    self.extraLabel.hidden = self.extraLabel.text.length == 0;
    [self.extraLabel sizeToFit];
    self.extraLabel.mcLeft = self.detailTextLabel.mcLeft;
    self.extraLabel.mcTop = self.detailTextLabel.mcBottom + 6;
    self.extraLabel.mcWidth = self.mcWidth-self.extraLabel.mcLeft*2;
    self.extraLabel.mcHeight = self.mcHeight - self.extraLabel.mcTop - 5;
}

+ (CGFloat)heightForObject:(NSString *)obj {
    CGFloat cellH = 58;
    NSMutableParagraphStyle *p = [[NSMutableParagraphStyle alloc] init];
    p.lineBreakMode = NSLineBreakByCharWrapping;
    CGSize size = [obj boundingRectWithSize:CGSizeMake(UIScreen.mainScreen.bounds.size.width-40, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Baskerville-Italic" size:14], NSParagraphStyleAttributeName:p} context:nil].size;
    if (size.height > 0) {
        cellH+=6+size.height;
    }
    cellH+=16;
    return cellH;
}

@end
