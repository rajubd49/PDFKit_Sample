//
//  PDFReaderViewController.m
//  PDFKit_Sample
//
//  Created by rajubd49 on 1/2/18.
//  Copyright © 2018 rajubd49. All rights reserved.
//

#import "PDFReaderViewController.h"
#import "ThumbnailCollectionCell.h"
#import "PDFToolBarActionControl.h"

#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONE_X (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 812.0f)

@interface PDFReaderViewController ()

@property (strong, nonatomic) PDFToolBarActionControl *toolbarActionControl;
@property (strong, nonatomic) NSIndexPath *selectedIndexPath;

@end

@implementation PDFReaderViewController

#pragma mark - ViewController LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.documentName = @"sample.pdf";
    if (!self.toolbarActionControl) {
        self.toolbarActionControl = [[PDFToolBarActionControl alloc] init];
        self.toolbarActionControl.pdfViewController = self;
    }
    self.topToolbarHeightConstraint.constant = IS_IPHONE_X ? 100: 80;
    self.bottomThumbnailViewHeightConstraint.constant = IS_IPHONE_X ? 100: 80;
    
    self.twoPageMode = NO;
    [self preparePDFViewWithPageMode:kPDFDisplaySinglePage];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleTopBottomView)];
    [self.pdfContainerView addGestureRecognizer:tap];
    
    self.topToolbar.hidden = YES;
    self.bottomThumbnailView.hidden = YES;
    
    self.pdfThumbnailCollectionView.dataSource = self;
    self.pdfThumbnailCollectionView.delegate = self;
    [self.pdfThumbnailCollectionView registerNib:[UINib nibWithNibName:@"ThumbnailCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"ThumbnailCollectionCell"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PDFViewPageChangedNotification:) name:PDFViewPageChangedNotification object:self.pdfView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PDFViewAnnotationHitNotification:) name:PDFViewAnnotationHitNotification object:self.pdfView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self updateThumbnailCollectionForSelectedIndex];
}

- (void)viewDidDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PDFViewPageChangedNotification object:self.pdfView];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PDFViewAnnotationHitNotification object:self.pdfView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITraitCollection Change

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection
{
    [super traitCollectionDidChange:previousTraitCollection];
    [self.pdfThumbnailCollectionView reloadData];
    [self.pdfThumbnailCollectionView scrollToItemAtIndexPath:self.selectedIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
}

#pragma mark - Prepare PDF View

- (void)preparePDFViewWithPageMode:(PDFDisplayMode) displayMode {
    
    self.pdfContainerView.frame = self.view.frame;
    self.pdfView = [[PDFView alloc] initWithFrame: self.pdfContainerView.bounds];
    self.pdfView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
    self.pdfView.autoScales = YES;
    self.pdfView.maxScaleFactor = 4.0;
    self.pdfView.minScaleFactor = self.pdfView.scaleFactorForSizeToFit;
    self.pdfView.displayMode = displayMode;
    self.pdfView.displayDirection = kPDFDisplayDirectionHorizontal;
    [self.pdfView zoomIn:self];
    [self.pdfContainerView addSubview:self.pdfView];
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"sample" withExtension:@"pdf"];
    self.pdfDocument = [[PDFDocument alloc] initWithURL:url];
    
    self.pdfView.document = self.pdfDocument;
    [self.pdfView usePageViewController:(displayMode == kPDFDisplaySinglePage) ? YES :NO withViewOptions:nil];
    
}

#pragma mark - Update Top Bottom View

- (void)updatePdfTitleAndPageNumber {
    
    self.pdfTitleLabel.text = self.documentName;
    self.pageNumberLabel.text = [NSString stringWithFormat:@"Page %@ of %lu", self.pdfView.currentPage.label, (unsigned long)self.pdfDocument.pageCount];
}

- (void)updateThumbnailCollectionForSelectedIndex {
    NSUInteger row = [self.pdfDocument indexForPage:self.pdfView.currentPage];
    if(self.selectedIndexPath){
        [self.pdfThumbnailCollectionView reloadItemsAtIndexPaths:[NSArray arrayWithObject:self.selectedIndexPath]];
    }
    self.selectedIndexPath = [NSIndexPath indexPathForRow:row inSection:0];
    [self.pdfThumbnailCollectionView reloadItemsAtIndexPaths:[NSArray arrayWithObject:self.selectedIndexPath]];
    if (![self.pdfThumbnailCollectionView.indexPathsForVisibleItems containsObject:self.selectedIndexPath]) {
        [self.pdfThumbnailCollectionView scrollToItemAtIndexPath:self.selectedIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
}

#pragma mark - Toggle Top/Bottom View

-(void)toggleTopBottomView {
    
    [UIView transitionWithView:self.bottomThumbnailView
                      duration:0.3
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        self.bottomThumbnailView.hidden = !self.bottomThumbnailView.hidden;
                    }
                    completion:NULL];
    [UIView transitionWithView:self.topToolbar
                      duration:0.3
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        self.topToolbar.hidden = !self.topToolbar.hidden;
                    }
                    completion:NULL];
}

#pragma mark - UICollectionView DataSource and Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.pdfDocument.pageCount > 0 ? self.pdfDocument.pageCount : 0;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    ThumbnailCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ThumbnailCollectionCell" forIndexPath:indexPath];
    
    PDFPage *pdfPage = [self.pdfDocument pageAtIndex:indexPath.item];
    if (pdfPage != nil ) {
        UIImage *thumbnail = [pdfPage thumbnailOfSize:cell.bounds.size forBox:kPDFDisplayBoxCropBox];
        cell.thumbnailImageView.image = thumbnail;
        cell.pageNumberLabel.text = [NSString stringWithFormat:@"%ld", indexPath.item +1];
    }
    
    if ([self.pdfView.currentPage isEqual:pdfPage]) {
        cell.highlighted = YES;
        [self updatePdfTitleAndPageNumber];
    }else{
        cell.highlighted = NO;
    }
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PDFPage *pdfPage = [self.pdfDocument pageAtIndex:indexPath.item];
    [self.pdfView goToPage:pdfPage];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(52, 76);
}

#pragma mark - PDFViewPageChangedNotification

-(void)PDFViewPageChangedNotification:(NSNotification*)notification{
    [self updateThumbnailCollectionForSelectedIndex];
}

#pragma mark - PDFViewAnnotationHitNotification

-(void)PDFViewAnnotationHitNotification:(NSNotification*)notification {
    PDFAnnotation *annotation = (PDFAnnotation*)notification.userInfo[@"PDFAnnotationHit"];
    NSUInteger pageNumber = [self.pdfDocument indexForPage:annotation.destination.page];
    NSLog(@"Page: %lu", (unsigned long)pageNumber);
}

#pragma mark - Delegate Helper Method

-(void)didSelectPdfOutline:(PDFOutline *)pdfOutline {
    
    [self.pdfView goToPage:pdfOutline.destination.page];
}

-(void)didSelectPdfSelection:(PDFSelection *)pdfSelection {
    
    pdfSelection.color = [UIColor yellowColor];
    self.pdfView.currentSelection  = pdfSelection;
    [self.pdfView goToSelection:pdfSelection];
}

-(void)didSelectPdfPageFromBookmark:(PDFPage *)pdfPage {
    [self.pdfView goToPage:pdfPage];
}

#pragma mark - Toolbar Button Actions

- (IBAction)outlineAction:(id)sender {
    [self.toolbarActionControl showOutlineTableForPDFDocument:self.pdfDocument fromSender:sender];
}

- (IBAction)pageModeAction:(id)sender {
    self.twoPageMode = !self.twoPageMode;
    [self.toolbarActionControl pageModeToggle:self.twoPageMode];
}

- (IBAction)bookmarkAction:(id)sender {
    [self.toolbarActionControl showBookmarkTableFromSender:sender];
}

- (IBAction)searchAction:(id)sender {
    [self.toolbarActionControl showSearchTableForPDFDocument:self.pdfDocument fromSender:sender];
}

@end
