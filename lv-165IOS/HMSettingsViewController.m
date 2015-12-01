//
//  HMSettingsViewController.m
//  lv-165IOS
//
//  Created by Ihor Zabrotsky on 11/30/15.
//  Copyright © 2015 SS. All rights reserved.
//

#import "HMSettingsViewController.h"

@interface HMSettingsViewController ()

@end

@implementation HMSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.segmentedControlForMapType.selectedSegmentIndex = [self.mapType intValue];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Segmented Control For Map Type

- (IBAction)segmentedControlForMapTypeValueChanged:(id)sender {

    self.mapType = [NSNumber numberWithLong:self.segmentedControlForMapType.selectedSegmentIndex];
    
    NSDictionary *dictionary = @{@"value" : self.mapType};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeMapTypeNotification"
                                                        object:self
                                                      userInfo:dictionary];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
