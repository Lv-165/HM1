//
//  Continents+CoreDataProperties.h
//  lv-165IOS
//
//  Created by AG on 11/30/15.
//  Copyright © 2015 SS. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Continents.h"

NS_ASSUME_NONNULL_BEGIN

@interface Continents (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *code;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSNumber *places;
@property (nullable, nonatomic, retain) NSSet<Place *> *placesOnContinent;

@end

@interface Continents (CoreDataGeneratedAccessors)

- (void)addPlacesOnContinentObject:(Place *)value;
- (void)removePlacesOnContinentObject:(Place *)value;
- (void)addPlacesOnContinent:(NSSet<Place *> *)values;
- (void)removePlacesOnContinent:(NSSet<Place *> *)values;

@end

NS_ASSUME_NONNULL_END
