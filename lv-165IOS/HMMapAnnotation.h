//
//  HMMapAnnotation.h
//  lv-165IOS
//
//  Created by Ihor Zabrotsky on 12/2/15.
//  Copyright © 2015 SS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface HMMapAnnotation : NSObject <MKAnnotation>

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

@end