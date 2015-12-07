//
//  HMCoreDataManager.m
//  lv-165IOS
//
//  Created by AG on 11/27/15.
//  Copyright © 2015 SS. All rights reserved.
//

#import "HMCoreDataManager.h"
#import "NSNumber+HMNumber.h"

@implementation HMCoreDataManager

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;


+ (HMCoreDataManager*) sharedManager {
    
    static HMCoreDataManager* manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[HMCoreDataManager alloc] init];
    });
    
    return manager;
}

#pragma mark - Create_Delete Objects


- (void) saveContinentsToCoreDataWithNSArray:(NSArray*) countryArray {
    
    NSLog(@"saveContinentsToCoreDataWithNSArray");

    for (NSDictionary* dict in countryArray) {
        
        Continents* continent = [NSEntityDescription insertNewObjectForEntityForName:@"Continents"
                                                              inManagedObjectContext:[self managedObjectContext]];
        
        continent.code = [dict objectForKey:@"code"];
        continent.name = [dict objectForKey:@"name"];
        NSInteger tempInteger = [[dict valueForKey:@"places"] doubleValue];
        continent.places = [NSNumber numberWithInteger:tempInteger];
        
        NSLog(@"%@  AND %@ PLACES",continent.name, continent.code);
        
    }
    
    NSError* error = nil;
    
    if (![[self managedObjectContext] save:&error]) {
        NSLog(@"%@", [error localizedDescription]);
    }

}

- (void) savePlaceToCoreDataWithNSArray:(NSDictionary*) placeNSDictionary continent:(Continents*)continent {
    
    NSLog(@"savePlaceToCoreDataWithNSArray");
    
    Place* place = [NSEntityDescription insertNewObjectForEntityForName:@"Place"                                                              inManagedObjectContext:[self managedObjectContext]];
        
    NSInteger tempInteger = [[placeNSDictionary valueForKey:@"id"] integerValue];
     place.id = [NSNumber numberWithInteger:tempInteger];
    
    NSInteger ratInteger = [[placeNSDictionary valueForKey:@"rating"] integerValue];
    place.rating = [NSNumber numberWithInteger:ratInteger];
    
    NSInteger ratCountInteger = [[placeNSDictionary valueForKey:@"rating_count"] integerValue];
    place.rating_count = [NSNumber numberWithInteger:ratCountInteger];

    //place.elevation = [NSNumber numberFromValue:placeNSDictionary[@"elevation"]];
    
    double lonDounble = [[placeNSDictionary valueForKey:@"lon"] doubleValue];
     place.lon = [NSNumber numberWithDouble:lonDounble];
    
    double latDounble = [[placeNSDictionary valueForKey:@"lat"] doubleValue];
    place.lat = [NSNumber numberWithDouble:latDounble];
    
    //NSLog(@"\n\nID - %@\n LON - %@\n LAT - %@\n RATING - %@\n  RATCOUNT - %@\n ELEVATION -%@",
       //   place.id, place.lon,place.lat, place.rating, place.rating_count, place.elevation);
    
//    Continents* continents = [NSEntityDescription insertNewObjectForEntityForName:@"Continents"                                                              inManagedObjectContext:[self managedObjectContext]];
    
    //place.continent = continent;
    
    [continent addPlacesOnContinentObject:place];
    
    NSError* error = nil;
    if (![[self managedObjectContext] save:&error]) {
        NSLog(@"%@", [error localizedDescription]);
    }
    
}


- (void) deleteAllObjects {
    
    NSArray* allObjects = [self allObjects];
    
    for (id object in allObjects) {
        [self.managedObjectContext deleteObject:object];
    }
    [self.managedObjectContext save:nil];
}

#pragma mark - Print Objects

//- (void) printCountries {
//    
//    NSFetchRequest* request = [[NSFetchRequest alloc] init];
//    
//    NSEntityDescription* description =
//    [NSEntityDescription entityForName:@"Countries"
//                inManagedObjectContext:self.managedObjectContext];
//    
//    [request setEntity:description];
//    
//    NSError* requestError = nil;
//    NSArray* resultArray = [self.managedObjectContext executeFetchRequest:request error:&requestError];
//   
//}

- (void) printAllObjects {
    
    NSArray* allObjects = [self allObjects];
    
}


- (NSArray*) allObjects {
    
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription* description =
    [NSEntityDescription entityForName:@"HMCoreDataObjects"
                inManagedObjectContext:self.managedObjectContext];
    
    [request setEntity:description];
    
    NSError* requestError = nil;
    NSArray* resultArray = [self.managedObjectContext executeFetchRequest:request error:&requestError];
    if (requestError) {
        NSLog(@"%@", [requestError localizedDescription]);
    }
    
    return resultArray;
}


- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.lv_165IOS" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"lv_165IOS" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"lv_165IOS.sqlite"];
    NSError *error = nil;
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];

    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    
//    NSURL *  url = [[[NSFileManager defaultManager]
//                     URLsForDirectory:NSDocumentDirectory
//                     inDomains:NSUserDomainMask] lastObject];
//    
//    NSURL *storeURL = [url
//                       URLByAppendingPathComponent:@"lv-165IOS.sqlite"];
//    // MARK: Deleting previous sqlite db before creating a new one
//    // NSLog(@"deleting previous sqlite db before creating a new one");
//    [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
//    

    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


@end
