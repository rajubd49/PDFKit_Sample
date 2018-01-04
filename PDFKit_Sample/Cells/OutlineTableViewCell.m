//
//  OutlineTableViewCell.m
//  PDFKit_Sample
//
//  Created by rajubd49 on 12/5/17.
//  Copyright © 2017 rajubd49. All rights reserved.
//

#import "OutlineTableViewCell.h"

@implementation OutlineTableViewCell

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.indentationLevel == 0) {
        self.outlineTextLabel.font = [UIFont systemFontOfSize:15.0];
    } else {
        self.outlineTextLabel.font = [UIFont systemFontOfSize:14.0];
    }
    self.leftOffset.constant = self.indentationWidth * self.indentationLevel;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


@end
