//
//  SearchTableViewController.h
//  PDFKit_Sample
//
//  Created by rajubd49on 12/6/17.
//  Copyright © 2017 rajubd49. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PDFKit/PDFKit.h>

@protocol SearchTableViewControllerDelegate;

@interface SearchTableViewController : UITableViewController <UISearchBarDelegate, PDFDocumentDelegate>

@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) PDFDocument *pdfDocument;
@property (strong, nonatomic) NSMutableArray<PDFSelection *> *searchResultArray;

@property (nonatomic, weak) id <SearchTableViewControllerDelegate> delegate;

@end

@protocol SearchTableViewControllerDelegate <NSObject>

-(void)searchTableViewControllerDidSelectPdfSelection:(PDFSelection *)pdfSelection;

@end
