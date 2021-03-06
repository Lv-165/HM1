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
#import "Continents.h"

@interface HMCountriesViewController ()

@property (strong, nonatomic)NSMutableArray *arrayOfContinent;

@end

@implementation HMCountriesViewController
@synthesize fetchedResultsController = _fetchedResultsController;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Continents";
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Continents" inManagedObjectContext:self.managedObjectContext];
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
    
//    [self getContinentFromServer];
    //[self getCountryFromServer:@"ua"];
    // [self getPlaceFromServerByID:@"355"];

    self.arrayOfContinent = [[NSMutableArray alloc] init];
    
    // Do any additional setup after loading the view.
}
- (void)getContinentFromServer {

    [[HMServerManager sharedManager]
     
     getContinentsWithonSuccess:^(NSArray *continents) {
         [[HMCoreDataManager sharedManager] saveContinentsToCoreDataWithNSArray:continents];
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
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Continents" inManagedObjectContext:self.managedObjectContext];
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
    
    Continents *continent = [self.fetchedResultsController objectAtIndexPath:indexPath];

    //static NSString* identifier = @"downloadContinent";
    
    //HMDownloadCellTableViewCell* cell1 = [self.tableView dequeueReusableCellWithIdentifier:identifier];
    
    [self.arrayOfContinent addObject:continent];
    
    cell.continentsImage = nil;
    cell.continentLable.text = continent.name;
    cell.countLable.text = [NSString stringWithFormat:@"%@", continent.places];

    
}

- (IBAction)actionDwnloadSwitch:(id)sender {
    
    HMDownloadCellTableViewCell* cell = [sender superCell];
    
    NSLog(@"name = %@, count = %@\n", cell.continentLable.text, cell.countLable.text);
    
//    for (NSInteger i=0; i<[self.arrayOfContinent count]; i++) {
//        Continents* continent = [self.arrayOfContinent objectAtIndex:i];
//        NSLog(@"%@",continent);
//    }
    
    for (Continents* continent in self.arrayOfContinent ) {
        if ([cell.continentLable.text isEqualToString:continent.name]) {
            //getPlacesByContinentName
            [[HMServerManager sharedManager] getPlacesByContinentName:continent.code onSuccess:^(NSDictionary *places) {
                NSLog(@"%@/n", places);
                
                for (NSDictionary* dict in places) {
                    
                    NSLog(@"%@", [dict objectForKey:@"id"]);
                    
                    [[HMServerManager sharedManager] getPlaceWithID:[dict valueForKey:@"id"] onSuccess:^(NSArray *places) {
                        
                        NSLog(@"%@", places);
                        
                        //Write to CoreData Place
                        
                    } onFailure:^(NSError *error, NSInteger statusCode) {
                        
                    }];
                }
                
            } onFailure:^(NSError *error, NSInteger statusCode) {
                NSLog(@"err");
            }];
            
            return;
        }
    }
    
}

@end
