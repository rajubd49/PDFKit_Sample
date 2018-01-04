//
//  SearchTableViewController.m
//  PDFKit_Sample
//
//  Created by rajubd49 on 12/6/17.
//  Copyright © 2017 rajubd49. All rights reserved.
//

#import "SearchTableViewController.h"
#import "SearchTableViewCell.h"

@interface SearchTableViewController ()

@end

@implementation SearchTableViewController

#pragma mark - ViewController LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.searchResultArray = [[NSMutableArray alloc] init];
    self.searchBar = [[UISearchBar alloc] init];
    self.searchBar.delegate = self;
    [self.searchBar sizeToFit];
    self.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    self.navigationItem.titleView = self.searchBar;
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"SearchTableViewCell" bundle:nil] forCellReuseIdentifier:@"SearchTableViewCell"];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.searchBar becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableView DataSource / Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchResultArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchTableViewCell" forIndexPath:indexPath];
    
    PDFSelection *pdfSelection = self.searchResultArray[indexPath.row];
    PDFOutline *pdfOutline = [self.pdfDocument outlineItemForSelection:pdfSelection];
    if (pdfOutline != nil) {
        cell.outlineLabel.text = pdfOutline.label;
    }
    
    PDFPage *pdfPage = pdfSelection.pages.firstObject;
    cell.pageNumberLabel.text = [NSString stringWithFormat:@"Page: %@",pdfPage.label];
    
    PDFSelection *extendSelection = [pdfSelection copy];
    [extendSelection extendSelectionAtStart:10];
    [extendSelection extendSelectionAtEnd:90];
    [extendSelection extendSelectionForLineBoundaries];
    NSRange range = [extendSelection.string rangeOfString:pdfSelection.string options:NSCaseInsensitiveSearch];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:extendSelection.string];
    [attributedString addAttribute:NSBackgroundColorAttributeName value:[UIColor yellowColor] range:range];
    cell.searchResultTextLabel.attributedText = attributedString;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PDFSelection *pdfSelection = self.searchResultArray[indexPath.row];
    [self.delegate searchTableViewControllerDidSelectPdfSelection:pdfSelection];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 82;
}

#pragma mark - PDFSelection Delegate

- (void)didMatchString:(PDFSelection *)instance {
    [self.searchResultArray addObject:instance];
    [self.tableView reloadData];
}

#pragma mark - UIScrollView Delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.searchBar resignFirstResponder];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.pdfDocument cancelFindString];
    [self.navigationItem setRightBarButtonItem:nil animated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length <2 ) {
        return;
    }
    [self.searchResultArray removeAllObjects];
    [self.tableView reloadData];
    [self.pdfDocument cancelFindString];
    self.pdfDocument.delegate = self;
    [self.pdfDocument beginFindString:searchText withOptions:NSCaseInsensitiveSearch];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    
    UIBarButtonItem *cancelBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelBarButtonItemClicked)];
    [self.navigationItem setRightBarButtonItem:cancelBarButtonItem animated:YES];
    return true;
}

- (void)cancelBarButtonItemClicked {
    [self searchBarCancelButtonClicked:self.searchBar];
}

@end
