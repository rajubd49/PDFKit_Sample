//
//  PDFToolBarActionControl.m
//  PDFKit_Sample
//
//  Created by rajubd49on 12/5/17.
//  Copyright © 2017 rajubd49. All rights reserved.
//

#import "PDFToolBarActionControl.h"

@implementation PDFToolBarActionControl

#pragma mark - Toolbar Button Action Methods

- (void)showOutlineTableForPDFDocument:(PDFDocument *)pdfDocument fromSender:(id)sender {
    
    PDFOutline *pdfOutlineRoot = pdfDocument.outlineRoot;
    if (pdfOutlineRoot != nil) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        OutlineTableViewController *outlineTableVC = [storyboard instantiateViewControllerWithIdentifier:@"OutlineTableVC"];
        outlineTableVC.delegate = self;
        outlineTableVC.pdfOutlineRoot = pdfOutlineRoot;
        UINavigationController *navigaionController = [[UINavigationController alloc] initWithRootViewController:outlineTableVC];
        NSInteger horizontalClass = self.pdfViewController.traitCollection.horizontalSizeClass;
        if (horizontalClass == UIUserInterfaceSizeClassRegular) {
            navigaionController.modalPresentationStyle = UIModalPresentationPopover;
            navigaionController.popoverPresentationController.barButtonItem = sender;
            [self.pdfViewController presentViewController:navigaionController animated:NO completion:nil];
            UIPopoverPresentationController *popController = [navigaionController popoverPresentationController];
            popController.permittedArrowDirections = UIPopoverArrowDirectionAny;
        } else {
            [self.pdfViewController presentViewController:navigaionController animated:YES completion:nil];
        }
    }
}

- (void)pageModeToggle:(BOOL)twoPageMode {
    [self.pdfViewController.pageModeButton setImage: twoPageMode ? [UIImage imageNamed:@"pagesingle"] : [UIImage imageNamed:@"pagedouble"]];
    [self.pdfViewController.pdfView removeFromSuperview];
    [self.pdfViewController preparePDFViewWithPageMode:twoPageMode ? kPDFDisplayTwoUpContinuous : kPDFDisplaySinglePage];
    self.pdfViewController.pdfView.scaleFactor = self.pdfViewController.pdfView.scaleFactorForSizeToFit;
    [self.pdfViewController.pdfView goToPage:[self.pdfViewController.pdfDocument pageAtIndex:self.pdfViewController.pdfView.currentPage.label.intValue]];
}

- (void)showBookmarkTableFromSender:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    BookmarkViewController *bookmarksVC = [storyboard instantiateViewControllerWithIdentifier:@"BookmarkViewController"];
    bookmarksVC.delegate = self;
    bookmarksVC.pdfView = self.pdfViewController.pdfView;
    bookmarksVC.documentName = self.pdfViewController.documentName;
    UINavigationController *navigaionController = [[UINavigationController alloc] initWithRootViewController:bookmarksVC];
    NSInteger horizontalClass = self.pdfViewController.traitCollection.horizontalSizeClass;
    if (horizontalClass == UIUserInterfaceSizeClassRegular) {
        navigaionController.modalPresentationStyle = UIModalPresentationPopover;
        navigaionController.popoverPresentationController.barButtonItem = sender;
        [self.pdfViewController presentViewController:navigaionController animated:NO completion:nil];
        UIPopoverPresentationController *popController = [navigaionController popoverPresentationController];
        popController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    } else {
        [self.pdfViewController presentViewController:navigaionController animated:YES completion:nil];
    }
}

- (void)showSearchTableForPDFDocument:(PDFDocument *)pdfDocument fromSender:(id)sender {
    if (pdfDocument != nil) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        SearchTableViewController *searchTableVC = [storyboard instantiateViewControllerWithIdentifier:@"SearchTableVC"];
        searchTableVC.delegate = self;
        searchTableVC.pdfDocument = pdfDocument;
        UINavigationController *navigaionController = [[UINavigationController alloc] initWithRootViewController:searchTableVC];

        NSInteger horizontalClass = self.pdfViewController.traitCollection.horizontalSizeClass;
        if (horizontalClass == UIUserInterfaceSizeClassRegular) {
            navigaionController.modalPresentationStyle = UIModalPresentationPopover;
            navigaionController.popoverPresentationController.barButtonItem = sender;
            [self.pdfViewController presentViewController:navigaionController animated:NO completion:nil];
            UIPopoverPresentationController *popController = [navigaionController popoverPresentationController];
            popController.permittedArrowDirections = UIPopoverArrowDirectionAny;
        } else {
            [self.pdfViewController presentViewController:navigaionController animated:YES completion:nil];
        }
    }
}

#pragma mark - Utils

- (void)outlineTableViewControllerDidSelectPdfOutline:(PDFOutline *)pdfOutline {
    [self.pdfViewController didSelectPdfOutline:pdfOutline];
}

-(void)dismissBookmarkViewController:(BookmarkViewController *)bvc {
    [self.pdfViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void)bookmarkViewController:(BookmarkViewController *)bvc didRequestPageAtIndex:(NSUInteger)pageNumber {
    
    PDFPage *pdfPage = [self.pdfViewController.pdfDocument pageAtIndex:pageNumber -1];
    
    [self.pdfViewController didSelectPdfPageFromBookmark:pdfPage];
    [self.pdfViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)searchTableViewControllerDidSelectPdfSelection:(PDFSelection *)pdfSelection {
    [self.pdfViewController didSelectPdfSelection:pdfSelection];
}

@end
