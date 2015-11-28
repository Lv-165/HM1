//
//  Continents+CoreDataProperties.h
//  lv-165IOS
//
//  Created by AG on 11/27/15.
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
@property (nullable, nonatomic, retain) NSSet<NSManagedObject *> *countriesOnContinent;

@end

@interface Continents (CoreDataGeneratedAccessors)

- (void)addCountriesOnContinentObject:(NSManagedObject *)value;
- (void)removeCountriesOnContinentObject:(NSManagedObject *)value;
- (void)addCountriesOnContinent:(NSSet<NSManagedObject *> *)values;
- (void)removeCountriesOnContinent:(NSSet<NSManagedObject *> *)values;

@end

NS_ASSUME_NONNULL_END
