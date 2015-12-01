//
//  ViewController.m
//  lv-165IOS
//
//  Created by AG on 11/23/15.
//  Copyright © 2015 AG. All rights reserved.
//

#import "HMMapViewController.h"
#import "HMSettingsViewController.h"
#import "HMFilterViewController.h"
#import "HMSearchViewController.h"

@interface HMMapViewController ()

@property (strong, nonatomic) CLLocationManager *locationManager;

@property (strong, nonatomic)NSMutableArray *arrayOfCountries;
@property (strong, nonatomic)NSMutableArray *araryOfContinents;
@property (strong, nonatomic)NSMutableArray *arrayOfCountriesByISO;
@property (strong, nonatomic)NSMutableArray *arrayOfPlaces;
@property (strong, nonatomic)NSMutableArray *arrayOfPlacesAndDot;
@property (strong, nonatomic)NSMutableArray *arrayOfPlacesByCity;
@property (strong, nonatomic)NSMutableArray *arrayOfPlacesByContinent;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext* managedObjectContext;

@end

@implementation HMMapViewController

- (NSManagedObjectContext*) managedObjectContext {
    
    if (!_managedObjectContext) {
        _managedObjectContext = [[HMCoreDataManager sharedManager] managedObjectContext];
    }
    return _managedObjectContext;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.locationManager = [[CLLocationManager alloc] init];
    
    // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    flexibleItem.
    
    UIButton *yourCurrentLocation = [UIButton buttonWithType:UIButtonTypeCustom];
    [yourCurrentLocation setBackgroundImage:[UIImage imageNamed:@"compass"]
                           forState:UIControlStateNormal];
    [yourCurrentLocation addTarget:self action:@selector(showYourCurrentLocation:) forControlEvents:UIControlEventTouchUpInside];
    yourCurrentLocation.frame = CGRectMake(0, 0, 30, 30);
    yourCurrentLocation.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin;
    UIView *viewForShowCurrentLocation = [[UIView alloc] initWithFrame:CGRectMake(0, 30, 30, 30)];
    [viewForShowCurrentLocation addSubview:yourCurrentLocation];
    UIBarButtonItem *buttonForShowCurrentLocation = [[UIBarButtonItem alloc] initWithCustomView:viewForShowCurrentLocation];
    
    UIButton *moveToSettingsController = [UIButton buttonWithType:UIButtonTypeCustom];
    [moveToSettingsController setBackgroundImage:[UIImage imageNamed:@"tools"]
                                  forState:UIControlStateNormal];
    [moveToSettingsController addTarget:self action:@selector(moveToToolsController:) forControlEvents:UIControlEventTouchUpInside];
    moveToSettingsController.frame = CGRectMake(0, 0, 30, 30);
    moveToSettingsController.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin;
    UIView *viewForMoveToSettingsController = [[UIView alloc] initWithFrame:CGRectMake(0, 30, 30, 30)];
    [viewForMoveToSettingsController addSubview:moveToSettingsController];
    UIBarButtonItem *buttonForMoveToSettingsController = [[UIBarButtonItem alloc] initWithCustomView:viewForMoveToSettingsController];
    
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchButton setBackgroundImage:[UIImage imageNamed:@"Lupa"]
                                      forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(buttonSearch:) forControlEvents:UIControlEventTouchUpInside];
    searchButton.frame = CGRectMake(0, 0, 30, 30);
    searchButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin;
    UIView *viewForSearchButton = [[UIView alloc] initWithFrame:CGRectMake(0, 30, 30, 30)];
    [viewForSearchButton addSubview:searchButton];
    UIBarButtonItem *buttonSearchButton = [[UIBarButtonItem alloc] initWithCustomView:viewForSearchButton];

    
    
    UIButton *moveToFilterController = [UIButton buttonWithType:UIButtonTypeCustom];
    [moveToFilterController setBackgroundImage:[UIImage imageNamed:@"filter"]
                                       forState:UIControlStateNormal];
    [moveToFilterController addTarget:self action:@selector(moveToFilterController:) forControlEvents:UIControlEventTouchUpInside];
    moveToFilterController.frame = CGRectMake(0, 0, 30, 30);
    moveToFilterController.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin;
    UIView *viewForMoveToFilterController = [[UIView alloc] initWithFrame:CGRectMake(0, 30, 30, 30)];
    [viewForMoveToFilterController addSubview:moveToFilterController];
    UIBarButtonItem *buttonForMoveToFilterController = [[UIBarButtonItem alloc] initWithCustomView:viewForMoveToFilterController];

    
    NSArray *buttons = @[ buttonForShowCurrentLocation ,flexibleItem , buttonSearchButton , flexibleItem , buttonForMoveToFilterController , flexibleItem, buttonForMoveToSettingsController ];
    
    [self.downToolBar setItems:buttons animated:NO];
    

    
    [self getContinentsFromServer];
    self.mapView.showsUserLocation = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                              selector:@selector(receiveChangeMapTypeNotification:)
                                                  name:@"ChangeMapTypeNotification"
                                                object:nil];
    
}

#pragma mark - buttons on Tool Bar

- (void)showYourCurrentLocation:(UIBarButtonItem *)sender {
}

- (void)moveToToolsController:(UIBarButtonItem *)sender {
    
    [self performSegueWithIdentifier:@"showSettingsViewController" sender:sender];
    
}

- (void)moveToFilterController:(UIBarButtonItem *)sender {
    
    [self performSegueWithIdentifier:@"showFilterViewController" sender:sender];
    
}

- (void)buttonSearch:(UIBarButtonItem *)sender {
    
    [self performSegueWithIdentifier:@"showSearchViewController" sender:sender];
    
}

#pragma mark - API

- (void)getCountriesFromServer {
    [[HMServerManager sharedManager]
     
     getCountriesWithonSuccess:^(NSArray *countries) {
         [self.arrayOfCountries addObjectsFromArray:countries];
     }
     onFailure:^(NSError *error, NSInteger statusCode) {
         NSLog(@"error = %@, code = %ld", [error localizedDescription], statusCode);
     }];
}

- (void)getContinentsFromServer {
    [[HMServerManager sharedManager]
     
     getContinentsWithonSuccess:^(NSArray *continents) {
         [self.araryOfContinents addObjectsFromArray:continents];
     }
     onFailure:^(NSError *error, NSInteger statusCode) {
         NSLog(@"error = %@, code = %ld", [error localizedDescription], statusCode);
     }];
}

- (void)getPlacesFromServerByISOCountryName:(NSString *)iso {
    [[HMServerManager sharedManager]
     getPlacesByCountryWithISO:iso
     onSuccess:^(NSArray *countriesWithISO) {
         [self.arrayOfCountriesByISO addObjectsFromArray:countriesWithISO];
     }
     onFailure:^(NSError *error, NSInteger statusCode) {
         NSLog(@"error = %@, code = %ld", [error localizedDescription], statusCode);
     }];
    
}

- (void)getPlaceFromServerByID:(NSString *)placeID {
    [[HMServerManager sharedManager]
     getPlaceWithID:placeID
     onSuccess:^(NSArray* places) {
         [self.arrayOfPlaces addObjectsFromArray:places];
     }
     onFailure:^(NSError *error, NSInteger statusCode) {
         NSLog(@"error = %@, code = %ld", [error localizedDescription], statusCode);
     }];
    
}

- (void)getPlaceFromServerByIDandDot:(NSString *)placeID {
    NSString *stringForRequest = [NSString stringWithFormat:@"%@&dot",placeID];
    [self getPlaceFromServerByID:stringForRequest];
}

- (void)getPlacesFromServerByContinent:(NSString *)continentCode {
    [[HMServerManager sharedManager]
     getPlacesByContinentName:continentCode
     onSuccess:^(NSArray* places) {
         [self.arrayOfPlacesByContinent addObjectsFromArray:places];
     }
     onFailure:^(NSError *error, NSInteger statusCode) {
         NSLog(@"error = %@, code = %ld", [error localizedDescription], statusCode);
     }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"showSettingsViewController"]) {
        
        HMSettingsViewController *destViewController = segue.destinationViewController;
        
        switch (self.mapView.mapType) {
            case MKMapTypeStandard:

                destViewController.mapType = [NSNumber numberWithInt:MKMapTypeStandard];
                
                break;
                
            case MKMapTypeSatellite:
                
                destViewController.mapType = [NSNumber numberWithInt:MKMapTypeSatellite];
                
                break;
            
            case MKMapTypeHybrid:
                
                destViewController.mapType = [NSNumber numberWithInt:MKMapTypeHybrid];
                
                break;
                
            default:
                break;
        }
        
        
    } else
        if ([segue.identifier isEqualToString:@"showFilterViewController"]) {
            
            HMFilterViewController *destViewController = segue.destinationViewController;
            
        }
    else
        if ([segue.identifier isEqualToString:@"showSearchViewController"]) {
            
            HMSearchViewController *destViewController = segue.destinationViewController;
            
        }

    
}

#pragma mark - Notifications

- (void) receiveChangeMapTypeNotification:(NSNotification *) notification
{
    
    if ([[notification name] isEqualToString:@"ChangeMapTypeNotification"])  {
        
        NSLog(@"Successfully received ChangeMapTypeNotification notification!");
        
        self.mapView.mapType = [[notification.userInfo objectForKey:@"value"] intValue];
        
        
    }
    
}

#pragma mark - Deallocation

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

@end
