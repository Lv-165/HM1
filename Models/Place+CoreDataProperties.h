//
//  Place+CoreDataProperties.h
//  lv-165IOS
//
//  Created by AG on 11/27/15.
//  Copyright © 2015 SS. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Place.h"

NS_ASSUME_NONNULL_BEGIN

@interface Place (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *comments_count;
@property (nullable, nonatomic, retain) NSDate *datetime;
@property (nullable, nonatomic, retain) NSNumber *elevation;
@property (nullable, nonatomic, retain) NSNumber *id;
@property (nullable, nonatomic, retain) NSNumber *lat;
@property (nullable, nonatomic, retain) NSNumber *lon;
@property (nullable, nonatomic, retain) NSNumber *rating;
@property (nullable, nonatomic, retain) NSNumber *rating_count;
@property (nullable, nonatomic, retain) NSSet<NSManagedObject *> *comments;
@property (nullable, nonatomic, retain) NSManagedObject *country;
@property (nullable, nonatomic, retain) NSSet<NSManagedObject *> *descript;
@property (nullable, nonatomic, retain) Location *location;
@property (nullable, nonatomic, retain) NSManagedObject *user;

@end

@interface Place (CoreDataGeneratedAccessors)

- (void)addCommentsObject:(NSManagedObject *)value;
- (void)removeCommentsObject:(NSManagedObject *)value;
- (void)addComments:(NSSet<NSManagedObject *> *)values;
- (void)removeComments:(NSSet<NSManagedObject *> *)values;

- (void)addDescriptObject:(NSManagedObject *)value;
- (void)removeDescriptObject:(NSManagedObject *)value;
- (void)addDescript:(NSSet<NSManagedObject *> *)values;
- (void)removeDescript:(NSSet<NSManagedObject *> *)values;

@end

NS_ASSUME_NONNULL_END
