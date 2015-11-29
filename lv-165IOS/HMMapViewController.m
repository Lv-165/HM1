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

@property (strong, nonatomic)NSMutableArray *arrayOfCountries;
@property (strong, nonatomic)NSMutableArray *arrayOfCountriesByISO;
@property (strong, nonatomic)NSMutableArray *arrayOfPlaces;
@property (strong, nonatomic)NSMutableArray *arrayOfPlacesAndDot;
@property (strong, nonatomic)NSMutableArray *arrayOfPlacesByCity;
@property (strong, nonatomic)NSMutableArray *arrayOfPlacesByContinent;

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
    [self getPlaceFromServerByID:@"355"];
    self.mapView.showsUserLocation = YES;
    
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

@end
