//
//  HMSearchViewController.m
//  lv-165IOS
//
//  Created by Ihor Zabrotsky on 11/30/15.
//  Copyright © 2015 SS. All rights reserved.
//

#import "HMSearchViewController.h"
#import "SVGeocoder.h"
#import "UICellForInfo.h"

@interface HMSearchViewController ()

@property (strong, nonatomic)NSArray *arrayForPlacesMarks;

@end

@implementation HMSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
#pragma mark - UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    return YES;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:NO animated:YES];
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    self.tableView.backgroundView = nil;
    self.arrayForPlacesMarks = [NSArray array];
    [SVGeocoder geocode:searchBar.text
             completion:^(NSArray *placemarks, NSHTTPURLResponse *urlResponse, NSError *error) {
                 if ([placemarks count]) {
                      self.arrayForPlacesMarks = placemarks;
                 } else {
                     self.tableView.backgroundView = nil;
                     [self.tableView setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search"]]];
                 }
                 [self.tableView reloadData];
             }];
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    return YES;
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = @"";
    [searchBar resignFirstResponder];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.arrayForPlacesMarks count];
}

- (UICellForInfo *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* identifier = @"Cell";
    
    UICellForInfo *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"UITableViewCell" bundle:nil] forCellReuseIdentifier:identifier];
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    SVPlacemark *object = self.arrayForPlacesMarks[indexPath.row];
    
    NSMutableArray *levelOfLocality = [NSMutableArray array];
    if (object.formattedAddress) {
        [levelOfLocality addObject:object.formattedAddress];
    }
    if (object.administrativeArea) {
        [levelOfLocality addObject:object.administrativeArea];
    }
    if (object.subAdministrativeArea) {
        [levelOfLocality addObject:object.subAdministrativeArea];
    }
    if (object.thoroughfare) {
        [levelOfLocality addObject:object.thoroughfare];
    }
    NSInteger count = 0;
    NSMutableString *str = [NSMutableString stringWithFormat:@""];
    for (id dataOfLocality in levelOfLocality) {
        if (count >= 3) {
            break;
        }
        
        if (dataOfLocality) {
            [str appendFormat:@", %@",dataOfLocality];
            count ++;
        }
        
    }
    [str deleteCharactersInRange:NSMakeRange(0, 1)];
    cell.infoLabel.text = [NSString stringWithString:str];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
