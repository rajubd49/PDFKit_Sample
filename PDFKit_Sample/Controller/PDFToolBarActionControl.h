//
//  PDFToolBarActionControl.h
//  PDFKit_Sample
//
//  Created by rajubd49 on 12/5/17.
//  Copyright © 2017 rajubd49. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PDFKit/PDFKit.h>
#import "PDFReaderViewController.h"
#import "OutlineTableViewController.h"
#import "SearchTableViewController.h"
#import "BookmarkViewController.h"

@interface PDFToolBarActionControl : NSObject <OutlineTableViewControllerDelegate, SearchTableViewControllerDelegate, BookmarkViewControllerDelegate>

@property (nonatomic, weak) PDFReaderViewController *pdfViewController;

- (void)showOutlineTableForPDFDocument:(PDFDocument *)pdfDocument fromSender:(id)sender;
- (void)pageModeToggle:(BOOL)twoPageMode;
- (void)showBookmarkTableFromSender:(id)sender;
- (void)showSearchTableForPDFDocument:(PDFDocument *)pdfDocument fromSender:(id)sender;



@end
