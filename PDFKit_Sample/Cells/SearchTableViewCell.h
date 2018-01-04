//
//  SearchTableViewCell.h
//  PDFKit_Sample
//
//  Created by rajubd49 on 12/6/17.
//  Copyright © 2017 rajubd49. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *outlineLabel;
@property (weak, nonatomic) IBOutlet UILabel *pageNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *searchResultTextLabel;

@end
