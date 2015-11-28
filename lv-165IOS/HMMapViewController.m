//
//  ViewController.m
//  lv-165IOS
//
//  Created by AG on 11/23/15.
//  Copyright © 2015 AG. All rights reserved.
//

#import "HMMapViewController.h"


@interface HMMapViewController ()

@property (strong, nonatomic) CLLocationManager *locationManager;

@property (strong, nonatomic)NSMutableArray *arrayOfContinent;
@property (strong, nonatomic)NSMutableArray *arrayOfCountry;
@property (strong, nonatomic)NSMutableArray *arrayOfPlaces;

@end

@implementation HMMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.locationManager = [[CLLocationManager alloc] init];
    
    // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    //[self getContinentFromServer];
    //[self getCountryFromServer:@"ua"];
    [self getPlaceFromServerByID:@"355"];
    
    self.mapView.showsUserLocation = YES;
    
}

#pragma mark - API

- (void)getContinentFromServer {
    [[HMServerManager sharedManager]
     
     getContinentWithonSuccess:^(NSArray *continents) {
         [self.arrayOfContinent addObjectsFromArray:continents];
     }
     onFailure:^(NSError *error, NSInteger statusCode) {
         NSLog(@"error = %@, code = %ld", [error localizedDescription], statusCode);
     }];
}

- (void)getCountryFromServerByISOname:(NSString *)iso {
    [[HMServerManager sharedManager]
     getCountryWithISO:iso
     onSuccess:^(NSArray *countries) {
         [self.arrayOfCountry addObjectsFromArray:countries];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
