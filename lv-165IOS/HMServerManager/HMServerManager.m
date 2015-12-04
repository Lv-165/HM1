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
#import "AFURLConnectionOperation.h"

@interface HMServerManager ()

@property (strong, nonatomic) AFHTTPRequestOperationManager* requestOperationManager;

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

- (void) getCountriesWithonSuccess:(void(^)(NSArray* countries)) success
                         onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure {
    [self.requestOperationManager
     GET:@"?countries"
     parameters:nil
     success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject) {
         
         success(responseObject.allValues);
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"Error: %@", error);
     }];
    
}

- (void) getContinentsWithonSuccess:(void (^)(NSArray *))success onFailure:(void (^)(NSError *, NSInteger))failure {
    [self.requestOperationManager
     GET:@"?continents"
     parameters:nil
     success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject) {
                  NSLog(@"Countries get GOOD");// вызов записи в кор дату
         success(responseObject.allValues);
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"Error: %@", error);
     }];
}

- (void) getPlacesByCountryWithISO:(NSString *)iso
                 onSuccess:(void(^)(NSDictionary* places)) success
                 onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure {
    
    NSString* countriesForGet = [NSString stringWithFormat:@"?country=%@",iso];
    
    [self.requestOperationManager
     GET:countriesForGet
     parameters:nil
     success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject) {
         //NSLog(@"JSON: %@", responseObject);
         
         success(responseObject);
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"Error: %@", error);
     }];
}

- (void)getPlaceWithID:(NSString *)placeID
             onSuccess:(void(^)(NSDictionary* cities)) success
             onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure {
    
    //NSString* IDplace = [NSString stringWithFormat:@"http://hitchwiki.org/maps/api/?place=%@",placeID];
    NSString* IDplace = [NSString stringWithFormat:@"?place=%@",placeID];
    
//    + (NSArray *)batchOfRequestOperations:(nullable NSArray *)operations
//progressBlock:(nullable void (^)(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations))progressBlock
//completionBlock:(nullable void (^)(NSArray *operations))completionBlock;
//    for (NSString *ident in places) {
//            AFHTTPRequestOperation *operation = [self.requestOperationManager HTTPRequestOperationWithHTTPMethod:@"GET" URLString:URLString parameters:parameters success:success failure:failure];
//        [arra add:operation];
//        
//    }
    
//    NSOperationQueue *networkQueue = [[NSOperationQueue alloc] init];
//    networkQueue.maxConcurrentOperationCount = 25;
//    
//    NSURL *url = [NSURL URLWithString:IDplace];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        // do whatever you'd like here; for example, if you want to convert
//        // it to a string and log it, you might do something like:
//        
//        NSLog(@"JSON: %@", responseObject);
//        
//        success(responseObject);
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"%s: AFHTTPRequestOperation error: %@", __FUNCTION__, error);
//    }];
//    [networkQueue addOperation:operation];
    
    [self.requestOperationManager
     GET:IDplace
     parameters:nil
     success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject) {
         //NSLog(@"JSON: %@", responseObject);
         
         success(responseObject);
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"Error: %@", error);
     }];
}

- (void)getPlaceyByName:(NSString *)cityName
            onSuccess:(void(^)(NSArray* cities)) success
            onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure {
    
    NSString* city = [NSString stringWithFormat:@"?city=%@",cityName];
    
    [self.requestOperationManager
     GET:city
     parameters:nil
     success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject) {
         NSLog(@"JSON: %@", responseObject);
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"Error: %@", error);
     }];
}

- (void)getPlacesByContinentName:(NSString *)continentName
                  onSuccess:(void (^)(NSDictionary *))success
                  onFailure:(void (^)(NSError *, NSInteger))failure {
    NSString* continent = [NSString stringWithFormat:@"?continent=%@",continentName];
    
    [self.requestOperationManager
     GET:continent
     parameters:nil
     success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject) {
         //NSLog(@"JSON: %@", responseObject);
         
         success(responseObject);
         
         //for (NSDictionary* dict in responseObject) {
             
             //NSLog(@"id = %@", [dict objectForKey:@"id"]);
             
//             [self getPlaceWithID:[dict objectForKey:@"id"] onSuccess:^(NSArray *places) {
//                 
//                 NSLog(@"LOL");
//                 
//             } onFailure:^(NSError *error, NSInteger statusCode) {
//                 
//                 NSLog(@"LOL");
//                 
//             }];
             
             
             
             //NSDictionary *dic = [[NSDictionary alloc] initWithDictionary:[self getPlaceWithID:[dict objectForKey:@"id"]]];
             
             //NSLog(@"%@", dic);
         //}
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"Error: %@", error);
         
         failure(error, error.code);
         
     }];
}

- (NSManagedObjectContext* )managedObjectContext {
    if (!_managedObjectContext) {
        _managedObjectContext = [[HMCoreDataManager sharedManager]managedObjectContext];
    }
    return _managedObjectContext;

}

@end
