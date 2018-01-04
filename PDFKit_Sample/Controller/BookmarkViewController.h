//
//  BookmarkViewController.h
//  PDFKit_Sample
//
//  Created by rajubd49 on 1/3/18.
//  Copyright © 2018 rajubd49. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PDFKit/PDFKit.h>

#define NORMAL_MODE 0
#define EDITING_MODE 1
#define PDF_ID(pdf_id) [NSString stringWithFormat:@"pdf_%@",(pdf_id)]
#define PDF_NAME(pdf_id) [NSString stringWithFormat:@"pdf_name_%@",(pdf_id)]

@protocol BookmarkViewControllerDelegate;

@interface BookmarkViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

-(IBAction)editingToogleActon:(id)sender;
-(IBAction)addBookmarkAction:(id)sender;
-(IBAction)cancelAction:(id)sender;

@property (strong, nonatomic) NSString *documentName;
@property (strong, nonatomic) PDFView *pdfView;

@property (nonatomic, retain) IBOutlet UIBarButtonItem *editButton;
@property (nonatomic, retain) IBOutlet UITableView *tableView;

@property (nonatomic, assign) NSUInteger status;
@property (nonatomic, retain) NSMutableArray *bookmarks;
@property (nonatomic, retain) NSMutableArray *bookmarkNames;
@property (nonatomic, weak) id <BookmarkViewControllerDelegate> delegate;

@end

@protocol BookmarkViewControllerDelegate

-(void)dismissBookmarkViewController:(BookmarkViewController *)bookmarVC;
-(void)bookmarkViewController:(BookmarkViewController *)bookmarVC didRequestPageAtIndex:(NSUInteger)pageNumber;

@end
