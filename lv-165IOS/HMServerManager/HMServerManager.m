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
         
         self.countriesResponceObjects = [responseObject allValues];
         NSLog(@"Countries get GOOD");
         [self moveCountriesCoreData];
         
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

- (void) moveCountriesCoreData {
    
//    NSLog(@"ALL VALUES%@",self.countriesResponceObjects);
    
    for (NSDictionary* dict in self.countriesResponceObjects) {
        
//        NSLog(@" DICT %@",dict);
        Countries* country = [self.delegate addCountry:dict];//не передает
        NSLog(@"%@  AND %@",country.name, country.iso);

    }
   
    [self.delegate printCountries];//не пашет
    
//    NSError* error = nil;
    
//    if (![self.managedObjectContext save:&error]) {
//        NSLog(@"%@", [error localizedDescription]);
//    }

    


}
- (NSManagedObjectContext* )managedObjectContext {
    if (!_managedObjectContext) {
        _managedObjectContext = [[HMCoreDataManager sharedManager]managedObjectContext];
    }
    return _managedObjectContext;

}

@end
