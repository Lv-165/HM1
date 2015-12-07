//
//  HMCountriesViewController.m
//  lv-165IOS
//
//  Created by AG on 11/28/15.
//  Copyright © 2015 SS. All rights reserved.
//

#import "HMCountriesViewController.h"
#import "HMCoreDataManager.h"
#import "HMServerManager.h"
#import "HMDownloadCellTableViewCell.h"
#import "UIView+HMUItableViewCell.h"
#import "Countries.h"
#import "HMMapViewController.h"

@interface HMCountriesViewController ()

@property (strong, nonatomic)NSMutableArray *arrayOfContries;
@property (strong, nonatomic)NSMutableArray *arrayOfPlaces;
@property (strong, nonatomic)NSMutableArray *arrayOfDownloadedContinents;

@end

@implementation HMCountriesViewController
@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize managedObjectModel = _managedObjectModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Countries";
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Countries"
                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];

    NSLog(@"%@",fetchRequest);
    NSError* error;
    
    NSUInteger count = [[self managedObjectContext] countForFetchRequest:fetchRequest
                                                            error:&error];

    if (!count) {
 
            [self getContinentFromServer];
    }

    self.arrayOfContries = [[NSMutableArray alloc] init];
    self.arrayOfPlaces = [[NSMutableArray alloc] init];
    
    // Do any additional setup after loading the view.
}
- (void)getContinentFromServer {

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[HMServerManager sharedManager]getCountriesWithonSuccess:^(NSArray *continents) {
            
#warning MAIN QUEUE            //we need save only in main queue? c асинхронной вроде быстрей
            
            dispatch_async(dispatch_get_main_queue(), ^{
                 [[HMCoreDataManager sharedManager] saveCountriesToCoreDataWithNSArray:continents];
            });
            
        }
                                                        onFailure:^(NSError *error, NSInteger statusCode) {
                                                            NSLog(@"error = %@, code = %ld", [error localizedDescription], statusCode);
                                                        }];
    });

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Countries"
                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *nameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    
    [fetchRequest setSortDescriptors:@[nameDescriptor]];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:self.managedObjectContext
                                          sectionNameKeyPath:nil
                                                   cacheName:@"Master"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _fetchedResultsController;
}

- (void)configureCell:(HMDownloadCellTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    Countries *countries = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    [self.arrayOfContries addObject:countries];
    
    cell.continentsImage = nil;
    cell.continentLable.text = countries.name;
    cell.countLable.text = [NSString stringWithFormat:@"%@", countries.places];

    //cell.downloadProgress.hidden = YES;
    
    if ([countries.place count] != 0) {
        [cell.downloadSwitch setOn:YES];
    }
    else {
        [cell.downloadSwitch setOn:NO];
    }
}


#pragma mark Switcher

- (IBAction)actionDwnloadSwitch:(id)sender {
    
    HMDownloadCellTableViewCell* cell = [sender superCell];
    
    NSLog(@"name = %@, count = %@\n", cell.continentLable.text, cell.countLable.text);
    
    for (Countries* countries in self.arrayOfContries ) {
        if ([cell.continentLable.text isEqualToString:countries.name]) {
            //getPlacesByContinentName
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [[HMServerManager sharedManager] getPlacesByCountryWithISO:countries.iso onSuccess:^(NSDictionary *places)  {
//                NSLog(@"%@/n", places);
                
                [self.arrayOfPlaces removeAllObjects];
                for (NSDictionary* dict in places) {
                    
                    [self.arrayOfPlaces addObject:[dict objectForKey:@"id"]];
                }
                [self downloadPlaces:countries];
                
                        
                    } onFailure:^(NSError *error, NSInteger statusCode) {
                        
                    }];
            return;});
            
        }
//        [[HMCoreDataManager sharedManager]printCountryA];//не выводит
    }

}

- (void) downloadPlaces:(Countries*)countries {
    
    static int i = 0;
    
    for (NSString* idPlaces in self.arrayOfPlaces) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [[HMServerManager sharedManager] getPlaceWithID:idPlaces onSuccess:^(NSDictionary *places) {
                NSLog(@"\n\ni = %d\tPLACE%@\n",i++, places);
                
                [[HMCoreDataManager sharedManager] savePlaceToCoreDataWithNSArray:places contries:countries];
                
            } onFailure:^(NSError *error, NSInteger statusCode) {
                    NSLog(@"err");
            }];
        });
    }
}

#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
    [searchBar setShowsCancelButton:YES animated:YES];
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
    
}

@end
