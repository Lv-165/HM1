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
#import "FBAnnotationClustering/FBAnnotationClustering.h"
#import "HMSearchViewController.h"
#import <MapKit/MapKit.h>
#import "HMMapAnnotation.h"
#import "UIView+MKAnnotationView.h"
#import "Comments.h"
#import "Place.h"
#import "HMMapAnnotation.h"

@interface HMMapViewController ()

@property (strong, nonatomic) CLLocationManager *locationManager;

//@property (strong, nonatomic)NSMutableArray *arrayOfCountries;
//@property (strong, nonatomic)NSMutableArray *araryOfContinents;
//@property (strong, nonatomic)NSMutableArray *arrayOfCountriesByISO;
//@property (strong, nonatomic)NSMutableArray *arrayOfPlaces;
//@property (strong, nonatomic)NSMutableArray *arrayOfPlacesAndDot;
//@property (strong, nonatomic)NSMutableArray *arrayOfPlacesByCity;
//@property (strong, nonatomic)NSMutableArray *arrayOfPlacesByContinent;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext* managedObjectContext;

@property (strong, nonatomic) NSMutableArray* mapPointArray;
@property (strong, nonatomic) NSMutableArray * clusteredAnnotations;
@property (strong, nonatomic) FBClusteringManager * clusteringManager;


@end

@implementation HMMapViewController

static NSMutableArray* nameCountries;
static bool isMainRoute;

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
    
    [[NSOperationQueue new] addOperationWithBlock:^{
        double scale =
        _mapView.bounds.size.width / self.mapView.visibleMapRect.size.width;
       //NSArray *annotations = [self.clusteringManager clusteredAnnotationsWithinMapRect:_mapView.visibleMapRect  withZoomScale:scale];
        
        self.clusteringManager = [[FBClusteringManager alloc]initWithAnnotations:_clusteredAnnotations];
        [self.clusteringManager displayAnnotations:_clusteredAnnotations onMapView:_mapView];

    }];
    
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
    
    [self printPointWithContinent];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Countries"
                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    
//    NSError* error;
//    
//    NSUInteger count = [[self managedObjectContext] countForFetchRequest:fetchRequest
//                                                                   error:&error];
//    
//    if (!count) {
//        NSString * storyboardName = @"Main";
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
//        UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"downloadCountries"];
//        [self presentViewController:vc animated:YES completion:nil];
//    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
}

#pragma mark - buttons on Tool Bar

- (void)showYourCurrentLocation:(UIBarButtonItem *)sender {
    
    MKMapRect zoomRect = MKMapRectNull;
    
    CLLocationCoordinate2D location = self.mapView.userLocation.coordinate;
    
    MKMapPoint center = MKMapPointForCoordinate(location);
    
    static double delta = 40000;
    
    MKMapRect rect = MKMapRectMake(center.x - delta, center.y - delta, delta * 2, delta * 2);
    
    zoomRect = MKMapRectUnion(zoomRect, rect);
    
    zoomRect = [self.mapView mapRectThatFits:zoomRect];
    
    [self.mapView setVisibleMapRect:zoomRect
                        edgePadding:UIEdgeInsetsMake(50, 50, 50, 50)
                           animated:YES];
    
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
    } else if ([annotation isKindOfClass:[FBAnnotationCluster class]]) {
        // All clusters will have FBAnnotationCluster class, so when MKMapView delegate methods are called, you can check if current annotation is cluster by checking its class
        FBAnnotationCluster *cluster = (FBAnnotationCluster *)annotation;
        NSLog(@"Annotation is cluster. Number of annotations in cluster: %lu",
              (unsigned long)cluster.annotations.count);
    }
    
    static NSString* identifier = @"Annotation";
    
    MKPinAnnotationView* pin = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    
    if (!pin) {
        pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        pin.pinColor = MKPinAnnotationColorRed;
        //pin.animatesDrop = YES;
        pin.canShowCallout = YES;
        //pin.draggable = YES;
        
        
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

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    [[NSOperationQueue new] addOperationWithBlock:^{
        double scale = self.mapView.bounds.size.width / self.mapView.visibleMapRect.size.width;
        NSArray *annotations = [self.clusteringManager clusteredAnnotationsWithinMapRect:mapView.visibleMapRect withZoomScale:scale];
        
        [self.clusteringManager displayAnnotations:annotations onMapView:mapView];
    }];
}

#pragma mark - MKMapViewDelegate -

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay {
    
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        
        MKPolylineRenderer* renderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
        
        if (!isMainRoute) {
            
            renderer.lineWidth = 2.5f;
            renderer.strokeColor = [UIColor colorWithRed:0.f green:0.1f blue:1.f alpha:0.9f];
            return renderer;
        }
        else {
            
            renderer.lineWidth = 1.5f;
            renderer.strokeColor = [UIColor colorWithRed:0.f green:0.5f blue:1.f alpha:0.6f];
            return renderer;
        }
    }
    else if ([overlay isKindOfClass:[MKPolygon class]]) {
        
        MKPolygonRenderer *polygonView = [[MKPolygonRenderer alloc] initWithOverlay:overlay];
        polygonView.lineWidth = 2.f;
        polygonView.strokeColor = [UIColor magentaColor];
        
        return polygonView;
    }
    
    return nil;
}

#pragma mark - Alert -

- (UIAlertController *)createAlertControllerWithTitle:(NSString *)title message:(NSString *)message {
    
    UIAlertController * alert =   [UIAlertController
                                   alertControllerWithTitle:title
                                   message:message
                                   preferredStyle:UIAlertControllerStyleAlert];
    
    return alert;
}

- (void)actionWithTitle:(NSString *)title alertTitle:(NSString *)alertTitle alertMessage:(NSString *)alertMessage {
    
    UIAlertController * alert = [self createAlertControllerWithTitle:alertTitle message:alertMessage];
    
    UIAlertAction* alertAction = [UIAlertAction
                                  actionWithTitle:title
                                  style:UIAlertActionStyleCancel
                                  handler:^(UIAlertAction * action) {
                                  }];
    
    [alert addAction:alertAction];
    [self presentViewController:alert animated:YES completion:nil];
}

//Build routes
- (void) createRouteForAnotationCoordinate:(CLLocationCoordinate2D)endCoordinate
                           startCoordinate:(CLLocationCoordinate2D)startCoordinate {
    
    MKDirections* directions;
    
    MKDirectionsRequest* request = [[MKDirectionsRequest alloc] init];
    MKPlacemark* startPlacemark = [[MKPlacemark alloc] initWithCoordinate:startCoordinate
                                                        addressDictionary:nil];
    
    MKMapItem* startDestination = [[MKMapItem alloc] initWithPlacemark:startPlacemark];
    
    request.source = startDestination;
    
    MKPlacemark* endPlacemark = [[MKPlacemark alloc] initWithCoordinate:endCoordinate
                                                      addressDictionary:nil];
    
    MKMapItem* endDestination = [[MKMapItem alloc] initWithPlacemark:endPlacemark];
    
    request.destination = endDestination;
    request.transportType = MKDirectionsTransportTypeAutomobile;
    request.requestsAlternateRoutes = isMainRoute;
    
    BOOL temp = isMainRoute;
    
    directions = [[MKDirections alloc] initWithRequest:request];
    
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        
        if (error) {
            
            NSLog(@"%@", error);
            
        } else if ([response.routes count] == 0) {
            
            NSLog(@"routes = 0");
            
        } else {
            
            NSMutableArray *array  = [NSMutableArray array];
            for (MKRoute *route in response.routes) {
                [array addObject:route.polyline];
            }
            
            isMainRoute = temp;
            
            [self.mapView addOverlays:array level:MKOverlayLevelAboveRoads];
        }
        
    }];
}

- (void)removeRoutes {
    
    [self.mapView removeOverlays:self.mapView.overlays];
}

#pragma mark Action to pin button

- (void) actionDescription:(UIButton*) sender {
    
    MKAnnotationView* annotationView = [sender superAnnotationView];
    
    if (!annotationView) {
        return;
    }
    
    CLGeocoder* geoCoder = [[CLGeocoder alloc] init];
    CLLocationCoordinate2D coordinate = annotationView.annotation.coordinate;
    
    CLLocation* location = [[CLLocation alloc] initWithLatitude:coordinate.latitude
                                                      longitude:coordinate.longitude];
    
    if ([geoCoder isGeocoding]) {
        [geoCoder cancelGeocode];
    }
    
    [geoCoder
     reverseGeocodeLocation:location
     completionHandler:^(NSArray *placemarks, NSError *error) {
         
         NSString* message = nil;
         
         if (error) {
             message = [error localizedDescription];
             
         } else {
             
             if ([placemarks count] > 0) {
                 
                 MKPlacemark* placeMark = [placemarks firstObject];
                 message = [placeMark.addressDictionary description];
                 
             } else {
                 message = @"No Placemarks Found";
             }
         }
         
         [self actionWithTitle:@"OK" alertTitle:@"Location" alertMessage:message];
     }];
    
}

- (void) actionDirection:(UIButton*) sender {
    
    [self removeRoutes];
    
    MKAnnotationView* annotationView = [sender superAnnotationView];
    
    if (!annotationView) {
        return;
    }
    
//    UIButton* directionButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
//    [directionButton setBackgroundImage:[UIImage imageNamed:@"removeButton"] forState:UIControlStateNormal];
//    [directionButton addTarget:self action:@selector(actionRemoveRoute:) forControlEvents:UIControlEventTouchUpInside];
//    annotationView.leftCalloutAccessoryView = directionButton;
//    
//    if (self.annotationViewRemoveRoute) {
//        UIButton* directionButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
//        [directionButton addTarget:self action:@selector(actionDirection:) forControlEvents:UIControlEventTouchUpInside];
//        self.annotationViewRemoveRoute.leftCalloutAccessoryView = directionButton;
//        self.annotationViewRemoveRoute = annotationView;
//    }
//    else {
//        self.annotationViewRemoveRoute = annotationView;
//    }
    
    CLLocationCoordinate2D coordinate = annotationView.annotation.coordinate;
    
    isMainRoute = YES;
    [self createRouteForAnotationCoordinate:self.mapView.userLocation.coordinate
                            startCoordinate:coordinate];
    
    isMainRoute = NO;
    [self createRouteForAnotationCoordinate:self.mapView.userLocation.coordinate
                            startCoordinate:coordinate];
    
//    namePointRoute = [NSString stringWithFormat:@"%@ = %@",
//                      annotationView.annotation.title,
//                      annotationView.annotation.subtitle];
}

- (void) actionRemoveRoute:(UIButton*) sender {
    
    //self.annotationViewRemoveRoute = nil;
    
    MKAnnotationView* annotationView = [sender superAnnotationView];
    
    UIButton* directionButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [directionButton addTarget:self action:@selector(actionDirection:) forControlEvents:UIControlEventTouchUpInside];
    annotationView.leftCalloutAccessoryView = directionButton;
    
    [self removeRoutes];
}

//+ (void)addNameContinent:(NSString*)continent {
//    
//    if (!nameCountries) {
//        nameCountries = [[NSMutableArray alloc] init];
//    }
//    
//    nameCountries = [[NSMutableArray alloc] init];
//    
//    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Countries"];
//    
//    [nameCountries addObject:continent];
//}

- (void)printPointWithContinent {
    
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Countries"];
    self.mapPointArray = [[managedObjectContext executeFetchRequest:fetchRequest
                                                              error:nil] mutableCopy];
    _clusteredAnnotations = [NSMutableArray new];
//    for (Countries* countriesTemp in self.mapPointArray) {
//        for (NSString *nameContinent in nameCountries) {
//            if ([countriesTemp.name isEqualToString:nameContinent]) {
//                //NSLog(@"%@",continentTemp.placesOnContinent);
//                
//                NSSet* set = [[NSSet alloc] initWithSet:countriesTemp.place];
//                NSArray* array = [set allObjects];
//                for (NSInteger i=0; i<[array count]; i++) {
//                    Place* place = [array objectAtIndex:i];
//                    NSLog(@"\nid = %@, lat = %@, lon = %@",place.id, place.lat, place.lon);
//                    
//                    HMMapAnnotation *annotation = [[HMMapAnnotation alloc] init];
//                    
//                    CLLocationCoordinate2D coordinate;
//                    coordinate.latitude = [place.lat doubleValue];
//                    coordinate.longitude = [place.lon doubleValue];
//                    
//                    annotation.coordinate = coordinate;
//                    annotation.title = [NSString stringWithFormat:@"%@", place.id];
//                    annotation.subtitle = [NSString stringWithFormat:@"%.5g, %.5g",
//                                           annotation.coordinate.latitude,
//                                           annotation.coordinate.longitude];
//                    
//                    [_clusteredAnnotations addObject:annotation];
//                    
//                    [self.mapView addAnnotation:annotation];
//                }
//            }
//            
//        }
//    }
    
    for (Countries* countriesTemp in self.mapPointArray) {
        if ([countriesTemp.place count] != 0) {
            NSSet* set = [[NSSet alloc] initWithSet:countriesTemp.place];
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
                
                [_clusteredAnnotations addObject:annotation];
                
                [self.mapView addAnnotation:annotation];
            }
        }
        self.clusteringManager = [[FBClusteringManager alloc] initWithAnnotations:_clusteredAnnotations];
    }
}


@end
