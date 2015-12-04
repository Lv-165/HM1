/*
 Copyright (C) 2015 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 The custom MKAnnotationView object representing a generic location, displaying a title and image.
 */

#import "HMMapAnnotationView.h"
#import "HMMapAnnotation.h"

static CGFloat kMaxViewWidth = 150.0;

static CGFloat kViewWidth = 90;
static CGFloat kViewLength = 100;

static CGFloat kLeftMargin = 15.0;
static CGFloat kRightMargin = 5.0;
static CGFloat kTopMargin = 5.0;
static CGFloat kBottomMargin = 10.0;
static CGFloat kRoundBoxLeft = 10.0;

@implementation HMMapAnnotationView


- (UILabel *)makeiOSLabel:(NSString *)placeLabel
{
    // add the annotation's label
    UILabel *annotationLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    annotationLabel.font = [UIFont systemFontOfSize:9.0];
    annotationLabel.textColor = [UIColor whiteColor];
    annotationLabel.text = placeLabel;
    [annotationLabel sizeToFit];   // get the right vertical size
    
    // compute the optimum width of our annotation, based on the size of our annotation label
    CGFloat optimumWidth = annotationLabel.frame.size.width + kRightMargin + kLeftMargin;
    CGRect frame = self.frame;
    if (optimumWidth < kViewWidth)
        frame.size = CGSizeMake(kViewWidth, kViewLength);
    else if (optimumWidth > kMaxViewWidth)
        frame.size = CGSizeMake(kMaxViewWidth, kViewLength);
    else
        frame.size = CGSizeMake(optimumWidth, kViewLength);
    self.frame = frame;
    
    annotationLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    annotationLabel.backgroundColor = [UIColor clearColor];
    CGRect newFrame = annotationLabel.frame;
    newFrame.origin.x = kLeftMargin;
    newFrame.origin.y = kTopMargin;
    newFrame.size.width = self.frame.size.width - kRightMargin - kLeftMargin;
    annotationLabel.frame = newFrame;

    return annotationLabel;
}


// determine the MKAnnotationView based on the annotation info and reuseIdentifier
//
- (id)initWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self != nil)
    {
        HMMapAnnotation *mapItem = (HMMapAnnotation *)self.annotation;
        
        // offset the annotation so it won't obscure the actual lat/long location
        self.centerOffset = CGPointMake(50.0, 50.0);
        
        //
        self.backgroundColor = [UIColor clearColor];
 
        UILabel *annotationLabel = [self makeiOSLabel:mapItem.title];
        [self addSubview:annotationLabel];
        
        // add the annotation's image
        // the annotation image snaps to the width and height of this view
        UIImageView *annotationImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:mapItem.imageName]];
        annotationImage.contentMode = UIViewContentModeScaleAspectFit;
        annotationImage.frame =
            CGRectMake(kLeftMargin,
                       annotationLabel.frame.origin.y + annotationLabel.frame.size.height + kTopMargin,
                       self.frame.size.width - kRightMargin - kLeftMargin,
                       self.frame.size.height - annotationLabel.frame.size.height - kTopMargin*2 - kBottomMargin);
        [self addSubview:annotationImage];
        
    }
    
    return self;
}


- (void)drawRect:(CGRect)rect
{
    // used to draw the rounded background box and pointer
    HMMapAnnotation *mapItem = (HMMapAnnotation *)self.annotation;
    if (mapItem != nil)
    {
        [[UIColor darkGrayColor] setFill];
        
        // draw the pointed shape
        UIBezierPath *pointShape = [UIBezierPath bezierPath];
        [pointShape moveToPoint:CGPointMake(14.0, 0.0)];
        [pointShape addLineToPoint:CGPointMake(0.0, 0.0)];
        [pointShape addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height)];
        [pointShape fill];
        
        // draw the rounded box
        UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:
                                     CGRectMake(kRoundBoxLeft,
                                                0.0,
                                                self.frame.size.width - kRoundBoxLeft,
                                                self.frame.size.height)
                                                               cornerRadius:3.0];
        roundedRect.lineWidth = 2.0;
        [roundedRect fill];
    }
}



@end
