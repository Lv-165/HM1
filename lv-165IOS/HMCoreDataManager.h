//
//  HMCoreDataManager.h
//  lv-165IOS
//
//  Created by AG on 11/27/15.
//  Copyright © 2015 SS. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "HMServerManager.h"
#import "Continents.h"
#import "HMCoreDataObjects.h"
#import "Place.h"

@interface HMCoreDataManager : NSManagedObject 

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
//- (void) printArray:(NSArray*) array;
- (void) deleteAllObjects;

+ (HMCoreDataManager*) sharedManager;

- (void) saveContinentsToCoreDataWithNSArray:(NSArray*) countryArray;

- (void) savePlaceToCoreDataWithNSArray:(NSDictionary*) placeNSDictionary continent:(Continents*)continent;

@end
