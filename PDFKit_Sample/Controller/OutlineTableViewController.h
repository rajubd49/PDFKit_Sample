//
//  OutlineTableViewController.h
//  PDFKit_Sample
//
//  Created by rajubd49 on 12/5/17.
//  Copyright © 2017 rajubd49. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PDFKit/PDFKit.h>

@protocol OutlineTableViewControllerDelegate;

@interface OutlineTableViewController : UITableViewController

@property (strong, nonatomic) PDFOutline *pdfOutlineRoot;
@property (strong, nonatomic) NSMutableArray<PDFOutline*> *outlineArray;
@property (strong, nonatomic) NSMutableArray<PDFOutline*> *childOutlineArray;

@property (nonatomic, weak) id <OutlineTableViewControllerDelegate> delegate;

- (IBAction)cancelAction:(id)sender;

@end

@protocol OutlineTableViewControllerDelegate <NSObject>

-(void)outlineTableViewControllerDidSelectPdfOutline:(PDFOutline *)pdfOutline;

@end
