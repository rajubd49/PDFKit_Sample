//
//  OutlineTableViewController.m
//  PDFKit_Sample
//
//  Created by rajubd49 on 12/5/17.
//  Copyright © 2017 rajubd49. All rights reserved.
//

#import "OutlineTableViewController.h"
#import "OutlineTableViewCell.h"

@interface OutlineTableViewController ()

@end

@implementation OutlineTableViewController

#pragma mark - ViewController LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.outlineArray = [[NSMutableArray alloc] init];
    self.childOutlineArray = [[NSMutableArray alloc] init];

    [self.outlineArray removeAllObjects];
    for (NSUInteger index = 0; index < (self.pdfOutlineRoot.numberOfChildren); index++)  {
        PDFOutline *pdfOutline = [self.pdfOutlineRoot childAtIndex:index];
        pdfOutline.isOpen = NO;
        if (pdfOutline!=nil) {
            [self.outlineArray addObject:pdfOutline];
        }
    }
    
    [self.tableView registerNib:[UINib nibWithNibName:@"OutlineTableViewCell" bundle:nil] forCellReuseIdentifier:@"OutlineTableViewCell"];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableView DataSource and Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.outlineArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OutlineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OutlineTableViewCell" forIndexPath:indexPath];
    
    PDFOutline *pdfOutline = self.outlineArray[indexPath.row];
    cell.outlineTextLabel.text = pdfOutline.label;
    cell.pageNumberLabel.text = pdfOutline.destination.page.label;
    
    if (pdfOutline.numberOfChildren > 0) {
        [cell.openButton setImage: pdfOutline.isOpen ? [UIImage imageNamed:@"arrow_down"] : [UIImage imageNamed:@"arrow_right"] forState:UIControlStateNormal];
        cell.openButton.enabled = YES;
    } else {
        [cell.openButton setImage:nil forState:UIControlStateNormal];
        cell.openButton.enabled = NO;
    }
    
    cell.openButton.tag = indexPath.row;
    [cell.openButton addTarget:self action:@selector(openButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PDFOutline *pdfOutline = self.outlineArray[indexPath.row];
    int depth = [self findDepth:pdfOutline];
    return depth;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PDFOutline *pdfOutline = self.outlineArray[indexPath.row];
    [self.delegate outlineTableViewControllerDidSelectPdfOutline:pdfOutline];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

#pragma mark - Button Actions

-(void)openButtonAction:(UIButton*)sender {
    
    UIButton *button = (UIButton*)sender;
    button.selected = !button.selected;
    NSInteger rowNumber = sender.tag;
    PDFOutline *pdfOutline = self.outlineArray[rowNumber];

    if (pdfOutline.numberOfChildren > 0) {
        if ([button isSelected]) {
            pdfOutline.isOpen = YES;
            [self insertChildFrom:pdfOutline];
        } else {
            pdfOutline.isOpen = NO;
            [self removeChildFrom:pdfOutline];
        }
        [self.tableView reloadData];
    }
}

- (IBAction)cancelAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Find Indentation Depth

- (int)findDepth:(PDFOutline *) pdfOutline {
    int depth = -1;
    PDFOutline *tempOutline = pdfOutline;
    while (tempOutline.parent != nil) {
        depth = depth + 1;
        tempOutline = tempOutline.parent;
    }
    return depth;
}

#pragma mark - Insert/Remove Child

- (void)insertChildFrom:(PDFOutline *) parentOutline {
    [self.childOutlineArray removeAllObjects];
    NSUInteger baseIndex = [self.outlineArray indexOfObject:parentOutline];
    for (NSUInteger index = 0; index < parentOutline.numberOfChildren; index++) {
        PDFOutline *pdfOutline = [parentOutline childAtIndex:index];
        pdfOutline.isOpen = NO;
        [self.childOutlineArray addObject:pdfOutline];
    }
    NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:
                           NSMakeRange(baseIndex +1,[self.childOutlineArray count])];
    [self.outlineArray insertObjects:self.childOutlineArray atIndexes:indexes];
}

- (void)removeChildFrom:(PDFOutline *) parentOutline {
    
    if (parentOutline.numberOfChildren <= 0) {
        return;
    }
    for (NSUInteger index = 0; index < parentOutline.numberOfChildren; index++) {
        PDFOutline *node = [parentOutline childAtIndex:index];
        if (node.numberOfChildren >0) {
            [self removeChildFrom:node];
            if ([self.outlineArray containsObject:node]) {
                NSUInteger index = [self.outlineArray indexOfObject:node];
                [self.outlineArray removeObjectAtIndex:index];
            }
            
        } else {
            if ([self.outlineArray containsObject:node]) {
                NSUInteger index = [self.outlineArray indexOfObject:node];
                [self.outlineArray removeObjectAtIndex:index];
            }
        }
    }
}

@end
