//
//  HMServerManager.h
//  lv-165IOS
//
//  Created by roman on 27.11.15.
//  Copyright © 2015 SS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Countries.h"

@protocol HMCoreDataDelegate;

@interface HMServerManager : NSObject

+ (HMServerManager*) sharedManager;

- (void) getContinentWithonSuccess:(void(^)(NSArray* continents)) success
                         onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;

- (void) getCountryWithISO:(NSString *)iso
                 onSuccess:(void(^)(NSArray* continents)) success
                 onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;

- (void)getPlaceWithID:(NSString *)placeID
             onSuccess:(void(^)(NSArray* continents)) success
             onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;

@property (weak, nonatomic) NSDictionary <HMCoreDataDelegate>* delegate;
@property (strong, nonatomic) NSManagedObjectContext* managedObjectContext;

@end

@protocol HMCoreDataDelegate <NSObject>

@required
- (Countries*) addCountry:(NSDictionary*) countryDictionary;
- (void) printCountries;

@end