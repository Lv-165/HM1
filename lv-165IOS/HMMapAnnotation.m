//
//  HMMapAnnotation.m
//  lv-165IOS
//
//  Created by Ihor Zabrotsky on 12/2/15.
//  Copyright © 2015 SS. All rights reserved.
//

#import "HMMapAnnotation.h"


@implementation HMMapAnnotation

- (id)initWithLocation:(CLLocationCoordinate2D) coord {
    
    self = [super init];
    
    if (self) {
        
        self.coordinate = coord;
        
    }
    
    return self;
    
}

@end
