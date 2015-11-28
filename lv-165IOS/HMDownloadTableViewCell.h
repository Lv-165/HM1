//
//  HMDownloadTableViewCell.h
//  lv-165IOS
//
//  Created by Yurii Huber on 27.11.15.
//  Copyright © 2015 SS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMDownloadTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *flagCountryImage;
@property (weak, nonatomic) IBOutlet UIButton *downloadButton;
@property (weak, nonatomic) IBOutlet UILabel *countPlacesLable;
@property (weak, nonatomic) IBOutlet UILabel *countryNameLable;

@end
