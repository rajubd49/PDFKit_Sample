//
//  OutlineTableViewCell.h
//  PDFKit_Sample
//
//  Created by rajubd49 on 12/5/17.
//  Copyright © 2017 rajubd49. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OutlineTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *openButton;
@property (weak, nonatomic) IBOutlet UILabel *outlineTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *pageNumberLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftOffset;

@end
