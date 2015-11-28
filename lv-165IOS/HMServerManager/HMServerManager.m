//
//  HMServerManager.m
//  lv-165IOS
//
//  Created by roman on 27.11.15.
//  Copyright © 2015 SS. All rights reserved.
//

#import "HMServerManager.h"
#import "AFNetworking.h"
#import "HMCoreDataManager.h"


@interface HMServerManager ()

@property (strong, nonatomic) AFHTTPRequestOperationManager* requestOperationManager;
@property (strong, nonatomic) NSArray* countriesResponceObjects;

@end


@implementation HMServerManager

+ (HMServerManager*) sharedManager {
    
    static HMServerManager* manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[HMServerManager alloc] init];
    });
    
    return manager;
}

- (id)init
{
    self = [super init];
    if (self) {
       
        NSURL* url = [NSURL URLWithString:@"http://hitchwiki.org/maps/api/"];

        self.requestOperationManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
    }
    return self;
}

- (void) getContinentWithonSuccess:(void(^)(NSArray* continents)) success
                         onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure {
    [self.requestOperationManager
     GET:@"?countries"
     parameters:nil
     success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject) {
         NSLog(@"JSON: %@", responseObject);
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"Error: %@", error);
     }];
    
}

- (void) getCountryWithISO:(NSString *)iso
                 onSuccess:(void(^)(NSArray* continents)) success
                 onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure {
    
    NSString* countries = [NSString stringWithFormat:@"?country=%@",iso];
    
    [self.requestOperationManager
     GET:countries
     parameters:nil
     success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject) {
         NSLog(@"JSON: %@", responseObject);
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"Error: %@", error);
     }];
    
}

- (void)getPlaceWithID:(NSString *)placeID
             onSuccess:(void(^)(NSArray* places)) success
             onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure {
    
    NSString* IDplace = [NSString stringWithFormat:@"?place=%@",placeID];
    
    [self.requestOperationManager
     GET:IDplace
     parameters:nil
     success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject) {
         NSLog(@"JSON: %@", responseObject);
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"Error: %@", error);
     }];
}

- (void) saveCountriesCoreData {
    
    for (int i=0; i<self.countriesResponceObjects.count; i++) {
        
        NSDictionary* dict = self.countriesResponceObjects[i];
        [self.delegate addCountry:dict];
        
        NSLog(@"DICT : %@ ISO: %@ name: %@ Places: %@",dict,[dict valueForKey:@"iso"],[dict valueForKey:@"name"],[dict valueForKey:@"places"]);
        
    }
    
    NSLog(@"Countries in server responce: %lu JSON: %@", (unsigned long)[self.countriesResponceObjects count],self.countriesResponceObjects);

}


@end
