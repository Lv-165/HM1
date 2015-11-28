//
//  Countries+CoreDataProperties.h
//  lv-165IOS
//
//  Created by AG on 11/27/15.
//  Copyright © 2015 SS. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Countries.h"

NS_ASSUME_NONNULL_BEGIN

@interface Countries (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *iso;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSNumber *places;
@property (nullable, nonatomic, retain) NSSet<Place *> *allPlacesInCountry;
@property (nullable, nonatomic, retain) Continents *continentOfCountry;

@end

@interface Countries (CoreDataGeneratedAccessors)

- (void)addAllPlacesInCountryObject:(Place *)value;
- (void)removeAllPlacesInCountryObject:(Place *)value;
- (void)addAllPlacesInCountry:(NSSet<Place *> *)values;
- (void)removeAllPlacesInCountry:(NSSet<Place *> *)values;

@end

NS_ASSUME_NONNULL_END
