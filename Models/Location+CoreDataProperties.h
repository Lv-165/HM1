//
//  Location+CoreDataProperties.h
//  lv-165IOS
//
//  Created by AG on 11/27/15.
//  Copyright © 2015 SS. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Location.h"

NS_ASSUME_NONNULL_BEGIN

@interface Location (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *city;
@property (nullable, nonatomic, retain) NSManagedObject *continent;
@property (nullable, nonatomic, retain) NSManagedObject *country;
@property (nullable, nonatomic, retain) NSManagedObject *place;

@end

NS_ASSUME_NONNULL_END
