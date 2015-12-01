//
//  UIView+HMUItableViewCell.m
//  lv-165IOS
//
//  Created by Yurii Huber on 01.12.15.
//  Copyright © 2015 SS. All rights reserved.
//

#import "UIView+HMUItableViewCell.h"

@implementation UIView (HMUItableViewCell)

- (UITableViewCell*) superCell {
    
    if (!self.superview) {
        return nil;
    }
    
    if ([self.superview isKindOfClass:[UITableViewCell class]]) {
        return (UITableViewCell*)self.superview;
    }
    
    return [self.superview superCell];
}

@end
