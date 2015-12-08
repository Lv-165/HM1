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
#import <MapKit/MapKit.h>
#import "HMMapAnnotation.h"
#import "UIView+MKAnnotationView.h"
#import "Comments.h"
#import "Place.h"
#import "HMMapAnnotation.h"

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

@property (strong, nonatomic) NSMutableArray* mapPointArray;

@end

@implementation HMMapViewController

static NSMutableArray* nameContinents;

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
    
    self.mapView.showsUserLocation = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                              selector:@selector(receiveChangeMapTypeNotification:)
                                                  name:@"ChangeMapTypeNotification"
                                                object:nil];
    
    // Experiment
    
//    HMMapAnnotation* annotation = [[HMMapAnnotation alloc] init];
//    
//    CLLocationCoordinate2D coord;
//    
//    coord.latitude = 49;
//    coord.longitude = 24;
//    
//    annotation.title = @"Some title";
//    annotation.subtitle = @"Yes, it's me";
//    annotation.coordinate = coord;
//    
//    [self.mapView addAnnotation:annotation];
    
    [self printPointWithContinent];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
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

- (void) receiveChangeMapTypeNotification:(NSNotification *) notification {
    
    if ([[notification name] isEqualToString:@"ChangeMapTypeNotification"])  {
        
        NSLog(@"Successfully received ChangeMapTypeNotification notification!");
        
        self.mapView.mapType = [[notification.userInfo objectForKey:@"value"] intValue];
        
        
    }
    
}

#pragma mark - Deallocation

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Annotation View

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    static NSString* identifier = @"Annotation";
    
    MKPinAnnotationView* pin = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    
    if (!pin) {
        pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        pin.pinTintColor = MKPinAnnotationColorRed;
        pin.animatesDrop = YES;
        pin.canShowCallout = YES;
        pin.draggable = YES;
        
        
        UIButton* descriptionButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        
        [descriptionButton addTarget:self
                              action:@selector(actionDescription:)
                    forControlEvents:UIControlEventTouchUpInside];
        
        pin.rightCalloutAccessoryView = descriptionButton;
        
        
        UIButton* directionButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
        
        [directionButton addTarget:self
                            action:@selector(actionDirection:)
                  forControlEvents:UIControlEventTouchUpInside];
        pin.leftCalloutAccessoryView = directionButton;
        
    } else {
        pin.annotation = annotation;
    }
    
    return pin;
}

- (void)actionDescription:(id)sender {
    
    MKAnnotationView* annotationView = [sender superAnnotationView];
    
    if (!annotationView) {
        return;
    }
    
//    CLLocationCoordinate2D coordinate = annotationView.annotation.coordinate;
//    
//    CLLocation* location = [[CLLocation alloc] initWithLatitude:coordinate.latitude
//                                                      longitude:coordinate.longitude];
    
    [self showAlertWithTitle:@"Alert"
                  andMessage:@"some message"];
}

- (void) showAlertWithTitle:(NSString*)title
                 andMessage:(NSString*)message {
    
    [[[UIAlertView alloc]
      initWithTitle:title
      message:message
      delegate:nil
      cancelButtonTitle:@"OK"
      otherButtonTitles:nil] show];
}

+ (void)addNameContinent:(NSString*)continent {
    
    if (!nameContinents) {
        nameContinents = [[NSMutableArray alloc] init];
    }
    
    [nameContinents addObject:continent];
}

- (void)printPointWithContinent {
    
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Continents"];
    self.mapPointArray = [[managedObjectContext executeFetchRequest:fetchRequest
                                                              error:nil] mutableCopy];
    
    for (Continents* continentTemp in self.mapPointArray) {
        for (NSString *nameContinent in nameContinents) {
            if ([continentTemp.name isEqualToString:nameContinent]) {
                //NSLog(@"%@",continentTemp.placesOnContinent);
                
                NSSet* set = [[NSSet alloc] initWithSet:continentTemp.placesOnContinent];
                NSArray* array = [set allObjects];
                for (NSInteger i=0; i<[array count]; i++) {
                    Place* place = [array objectAtIndex:i];
                    NSLog(@"\nid = %@, lat = %@, lon = %@",place.id, place.lat, place.lon);
                    
                    HMMapAnnotation *annotation = [[HMMapAnnotation alloc] init];
                    
                    CLLocationCoordinate2D coordinate;
                    coordinate.latitude = [place.lat doubleValue];
                    coordinate.longitude = [place.lon doubleValue];
                    
                    annotation.coordinate = coordinate;
                    annotation.title = [NSString stringWithFormat:@"%@", place.id];
                    annotation.subtitle = [NSString stringWithFormat:@"%.5g, %.5g",
                                           annotation.coordinate.latitude,
                                           annotation.coordinate.longitude];
                    
                    [self.mapView addAnnotation:annotation];
                }
            }
        }
    }
    
    
    
//    for (NSInteger i=0; i<[self.mapPointArray count]; i++) {
//
//        MapPoints *mapPoint = [self.mapPointArray objectAtIndex:i];
//        MapAnnotation *annotation = [[MapAnnotation alloc] init];
//        
//        CLLocationCoordinate2D coordinate;
//        coordinate.latitude = [mapPoint.latitude doubleValue];
//        coordinate.longitude = [mapPoint.longitude doubleValue];
//        
//        annotation.coordinate = coordinate;
//        annotation.title = mapPoint.namePoint;
//        annotation.subtitle = [NSString stringWithFormat:@"%.5g, %.5g",
//                               annotation.coordinate.latitude,
//                               annotation.coordinate.longitude];
//        
//        [self.mapView addAnnotation:annotation];
//    }
}


@end
