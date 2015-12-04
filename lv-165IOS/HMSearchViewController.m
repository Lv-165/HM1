//
//  HMSearchViewController.m
//  lv-165IOS
//
//  Created by Ihor Zabrotsky on 11/30/15.
//  Copyright © 2015 SS. All rights reserved.
//

#import "HMSearchViewController.h"

@interface HMSearchViewController ()

@property (strong, nonatomic) NSMutableArray *arrayForPlacesMarks;

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
    self.arrayForPlacesMarks = [NSArray array];
    [ geocodeAddressString:searchBar.text completionHandler:^(NSArray *placemarks, NSError *error) {
        if (!error) {
            self.arrayForPlacesMarks = placemarks;
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
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* identifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"UITableViewCell" bundle:nil] forCellReuseIdentifier:identifier];
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    MKPlacemark *object = self.arrayForPlacesMarks[indexPath.row];
    
    NSArray *levelOfLocality = [NSArray arrayWithObjects:
                                object.country,
                                object.locality,
                                object.administrativeArea,
                                object.subAdministrativeArea,
                                object.thoroughfare,
                                nil];
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
    cell.textLabel.text = [NSString stringWithString:str];
    return cell;
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.arrayForPlacesMarks count];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
