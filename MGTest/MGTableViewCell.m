//
//  MGImageTableCell.m
//  MGTest
//
//  Created by Ben on 24/02/2013.
//  Copyright (c) 2013 Esteban. All rights reserved.
//

#import "MGTableViewCell.h"

@implementation MGTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_MGImage release];
    [super dealloc];
}
@end
