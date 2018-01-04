//
//  BookmarkViewController.m
//  PDFKit_Sample
//
//  Created by rajubd49 on 1/3/18.
//  Copyright © 2018 rajubd49. All rights reserved.
//

#import "BookmarkViewController.h"
#import "BookmarkTableViewCell.h"

@interface BookmarkViewController ()

@end

@implementation BookmarkViewController

#pragma mark - ViewController LifeCycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        self.status = NORMAL_MODE;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.bookmarks = [[NSMutableArray alloc] init];
    self.bookmarkNames = [[NSMutableArray alloc] init];
    
    NSMutableArray *aBookmarksArray = [self loadBookmarks];
    [self setBookmarks:aBookmarksArray];
    
    NSMutableArray *aBookmarksNamesArray = [self loadBookmarkNames];
    [self setBookmarkNames:aBookmarksNamesArray];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma Save and Load Bookmarks

- (void)saveBookmarks {
    [[NSUserDefaults standardUserDefaults]setObject:self.bookmarks forKey:PDF_ID(self.documentName)];
    [[NSUserDefaults standardUserDefaults]setObject:self.bookmarkNames forKey:PDF_NAME(self.documentName)];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSMutableArray *)loadBookmarks {
    NSMutableArray * bookmarksArray = nil;
    NSArray * storedBookmarks = [[NSUserDefaults standardUserDefaults]objectForKey:PDF_ID(self.documentName)];
    if(storedBookmarks) {
        bookmarksArray = [storedBookmarks mutableCopy];
    } else {
        bookmarksArray = [NSMutableArray array];
    }
    return bookmarksArray;
}

- (NSMutableArray *)loadBookmarkNames {
    NSMutableArray * bookmarksNameArray = nil;
    NSArray * storedBookmarksNames = [[NSUserDefaults standardUserDefaults]objectForKey:PDF_NAME(self.documentName)];
    if(storedBookmarksNames) {
        bookmarksNameArray = [storedBookmarksNames mutableCopy];
    } else {
        bookmarksNameArray = [NSMutableArray array];
        for (NSNumber *number in self.bookmarks) {
            [bookmarksNameArray addObject:[NSString stringWithFormat:@"Page %@",number]];
        }
    }
    return bookmarksNameArray;
}

#pragma mark - UIButton Actions

-(IBAction)cancelAction:(id)sender {
    
    if(self.status == EDITING_MODE)
        [self disableEditing];
    [self saveBookmarks];
    [[self delegate] dismissBookmarkViewController:self];
}

-(IBAction)editingToogleActon:(id)sender {
    
    if(self.status == NORMAL_MODE) {
        [self enableEditing];
    } else if (self.status == EDITING_MODE) {
        [self disableEditing];
    }
}

-(IBAction)addBookmarkAction:(id)sender {
    
    NSString *pageNumberText = self.pdfView.currentPage.label;
    [self.bookmarks addObject:pageNumberText];
    [self.bookmarkNames addObject:[NSString stringWithFormat:@"Page %@",pageNumberText]];
    [self saveBookmarks];
    [self.tableView reloadData];
}

-(void)enableEditing {
    
    [self.editButton setTitle:@"Done"];
    [self.tableView setEditing:YES];
    self.status = EDITING_MODE;
}

-(void)disableEditing {
    
    [self.editButton setTitle:@"Edit"];
    [self.tableView setEditing:NO];
    self.status = NORMAL_MODE;
}

#pragma mark - UITableView DataSource and Delegate

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger) tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
    if (self.bookmarks.count == 0) {
        [self disableEditing];
    }
    self.editButton.enabled = self.bookmarks.count > 0;
    return self.bookmarks.count;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        
    NSString *bookmark = [NSString stringWithFormat:@"%@",[self.bookmarkNames objectAtIndex:indexPath.row]];
    BookmarkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BookmarkTableViewCell"];
    cell.bookmarkTextField.text = bookmark;
    cell.bookmarkTextField.tag = indexPath.row;
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    NSUInteger index = indexPath.row;
    NSNumber *pageNumber = [self.bookmarks objectAtIndex:index];
    [self.delegate bookmarkViewController:self didRequestPageAtIndex:pageNumber.integerValue];
}

-(void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(editingStyle == UITableViewCellEditingStyleDelete) {
        NSUInteger index = indexPath.row;
        [self.bookmarks removeObjectAtIndex:index];
        [self.bookmarkNames removeObjectAtIndex:index];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
}

-(BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

#pragma mark - UITextField Delegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if(!self.tableView.editing){
        NSUInteger index = textField.tag;
        NSNumber *pageNumber = [self.bookmarks objectAtIndex:index];
        
        [self.delegate bookmarkViewController:self didRequestPageAtIndex:pageNumber.integerValue];
    }
    return self.tableView.editing;
}

- (IBAction)textFieldEditingChanged:(UITextField *)textField {
    NSInteger tag = textField.tag;
    [self.bookmarkNames replaceObjectAtIndex:tag withObject:textField.text];
    
}

@end
