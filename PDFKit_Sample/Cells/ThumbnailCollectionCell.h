//
//  ThumbnailCollectionCell.h
//  PDFKit_Sample
//
//  Created by rajubd49on 12/4/17.
//  Copyright © 2017 rajubd49. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PDFKit/PDFKit.h>

@interface ThumbnailCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImageView;
@property (weak, nonatomic) IBOutlet UILabel *pageNumberLabel;

@end
