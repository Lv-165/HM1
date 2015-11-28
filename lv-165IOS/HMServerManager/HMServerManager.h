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

- (void) getCountriesWithOffset:(NSInteger) offset
                      onSuccess:(void(^)(NSArray* placeInfo)) success
                      onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;

@property (weak, nonatomic) NSDictionary <HMCoreDataDelegate>* delegate;

@end

@protocol HMCoreDataDelegate <NSObject>

@required
- (Countries*) addCountry:(NSDictionary*) countryDictionary;

@end