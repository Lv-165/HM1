//
//  HMServerManager.h
//  lv-165IOS
//
//  Created by roman on 27.11.15.
//  Copyright © 2015 SS. All rights reserved.
//

#import <Foundation/Foundation.h>

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

@end
