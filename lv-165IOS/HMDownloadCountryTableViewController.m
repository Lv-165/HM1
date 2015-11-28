//
//  HMDownloadCountryTableViewController.m
//  lv-165IOS
//
//  Created by Yurii Huber on 27.11.15.
//  Copyright © 2015 SS. All rights reserved.
//

#import "HMDownloadCountryTableViewController.h"
#import "HMDownloadTableViewCell.h"

@interface HMDownloadCountryTableViewController ()

@end

@implementation HMDownloadCountryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* identifier = @"downloadCell";
    
    HMDownloadTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    
    
    return cell;
}

@end
