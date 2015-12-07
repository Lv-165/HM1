//
//  HMMapAnnotation.m
//  lv-165IOS
//
//  Created by Yurii Huber on 03.12.15.
//  Copyright © 2015 SS. All rights reserved.
//

#import "HMMapAnnotation.h"
#import "HMMapAnnotationView.h"

@implementation HMMapAnnotation

- (id)initWithLocation:(CLLocationCoordinate2D) coord {
    
    self = [super init];
    
    if (self) {
        
        self.coordinate = coord;
        
    }
    
    return self;
    
}

+ (MKAnnotationView *)createViewAnnotationForMapView:(MKMapView *)mapView annotation:(id <MKAnnotation>)annotation
{
    MKAnnotationView *returnedAnnotationView =
        (HMMapAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:NSStringFromClass([HMMapAnnotation class])];
    if (returnedAnnotationView == nil)
    {
        returnedAnnotationView =
        [[HMMapAnnotationView alloc] initWithAnnotation:annotation
                                         reuseIdentifier:NSStringFromClass([HMMapAnnotation class])];

    }
    
    return returnedAnnotationView;
}

@end
