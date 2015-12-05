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

@property (strong, nonatomic)NSMutableArray *arrayOfContinent;
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

    
    NSError* error;
    
    NSUInteger count = [[self managedObjectContext] countForFetchRequest:fetchRequest
                                                            error:&error];
    if (!count) {
        [self getContinentFromServer];
    }
    else {
//        NSString * storyboardName = @"Main";
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
//        UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"mapViewController"];
//        [self presentViewController:vc animated:YES completion:nil];
    }

    self.arrayOfContinent = [[NSMutableArray alloc] init];
    self.arrayOfPlaces = [[NSMutableArray alloc] init];
    
    // Do any additional setup after loading the view.
}
- (void)getContinentFromServer {

    [[HMServerManager sharedManager]
     
     getCountriesWithonSuccess:^(NSArray *continents) {
         
         [[HMCoreDataManager sharedManager] saveCountriesToCoreDataWithNSArray:continents];
     }
     onFailure:^(NSError *error, NSInteger statusCode) {
         NSLog(@"error = %@, code = %ld", [error localizedDescription], statusCode);
     }];
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

    //static NSString* identifier = @"downloadContinent";
    
    //HMDownloadCellTableViewCell* cell1 = [self.tableView dequeueReusableCellWithIdentifier:identifier];
    
    [self.arrayOfContinent addObject:countries];
    
    cell.continentsImage = nil;
    cell.continentLable.text = countries.name;
    cell.countLable.text = [NSString stringWithFormat:@"%@", countries.places];

    //cell.downloadProgress.hidden = YES;
    
    if ([countries.place count] != 0) {
        [cell.downloadSwitch setOn:YES];
    }
}

- (IBAction)actionDwnloadSwitch:(id)sender {
    
    HMDownloadCellTableViewCell* cell = [sender superCell];
    
    NSLog(@"name = %@, count = %@\n", cell.continentLable.text, cell.countLable.text);
    
    //[HMMapViewController addNameContinent:cell.continentLable.text];
    
    
//    for (NSInteger i=0; i<[self.arrayOfContinent count]; i++) {
//        Continents* continent = [self.arrayOfContinent objectAtIndex:i];
//        NSLog(@"%@",continent);
//    }
    
#warning коментувати коли скачали
    for (Countries* countries in self.arrayOfContinent ) {
        if ([cell.continentLable.text isEqualToString:countries.name]) {
            //getPlacesByContinentName
            
            [[HMServerManager sharedManager] getPlacesByCountryWithISO:countries.iso onSuccess:^(NSDictionary *places)  {
                NSLog(@"%@/n", places);
                
                for (NSDictionary* dict in places) {
                    
                    //NSLog(@"%@", [dict objectForKey:@"id"]);
                    
                    [self.arrayOfPlaces addObject:[dict objectForKey:@"id"]];
                }
                [self downloadPlaces:countries];
#warning СПИТАТИ ЯК ПРАВИЛЬНО ВИКЛИКАТИ!
                        //Write to CoreData Place
                        //[[HMCoreDataManager sharedManager] savePlaceToCoreDataWithNSArray:places];
                        
                    } onFailure:^(NSError *error, NSInteger statusCode) {
                        
                    }];
            return;
        }
    }
}

- (void) downloadPlaces:(Countries*)countries {
    
    static int i = 0;
    
    for (NSString* idPlaces in self.arrayOfPlaces) {
        
        dispatch_after(DISPATCH_TIME_NOW+1, dispatch_get_global_queue(0, DISPATCH_QUEUE_PRIORITY_DEFAULT), ^{
            [[HMServerManager sharedManager] getPlaceWithID:idPlaces onSuccess:^(NSDictionary *places) {
                NSLog(@"\n\ni = %d\tPLACE%@\n",i++, places);
                
                [[HMCoreDataManager sharedManager] savePlaceToCoreDataWithNSArray:places continent:countries];
                
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
