//
//  HMCountriesViewController.h
//  lv-165IOS
//
//  Created by AG on 11/28/15.
//  Copyright © 2015 SS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMCoreDataViewController.h"
#import "FBAnnotationClustering/FBAnnotationClustering.h"

@interface HMCountriesViewController : HMCoreDataViewController

//@property (weak, nonatomic) IBOutlet UISwitch *downloadSwitch;
- (IBAction)actionDwnloadSwitch:(id)sender;

@end
