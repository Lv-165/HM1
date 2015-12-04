//
//  HMMapAnnotation.h
//  lv-165IOS
//
//  Created by Yurii Huber on 03.12.15.
//  Copyright © 2015 SS. All rights reserved.
//

@import MapKit;
@import Foundation;

@interface HMMapAnnotation : NSObject <MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

@property (nonatomic, strong) NSString *imageName;

+ (MKAnnotationView *)createViewAnnotationForMapView:(MKMapView *)mapView annotation:(id <MKAnnotation>)annotation;


@end
