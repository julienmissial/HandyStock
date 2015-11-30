//
//  JSCustomCell.m
//  HandyStock
//
//  Created by ayatollah7 on 11/27/15.
//  Copyright © 2015 Julien Missial. All rights reserved.
//

#import "CustomCell.h"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@implementation CustomCell

@synthesize descriptionLabel = _descriptionLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 50)];
        self.descriptionLabel.textColor = [UIColor whiteColor];
        self.descriptionLabel.font = [UIFont fontWithName:@"Futura-CondensedMedium" size:28.0f];
        self.descriptionLabel.backgroundColor = UIColorFromRGB(0x252525);
        [self addSubview:self.descriptionLabel];
    }
    return self;
}

@end
