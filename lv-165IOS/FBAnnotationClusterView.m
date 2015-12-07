//
//  FBAnnotationClusterView.m
//  lv-165IOS
//
//  Created by Admin on 12/7/15.
//  Copyright © 2015 SS. All rights reserved.
//

#import "FBAnnotationClusterView.h"

static CGFloat kMaxViewWidth = 150.0;

static CGFloat kViewWidth = 90;
static CGFloat kViewLength = 100;

static CGFloat kLeftMargin = 15.0;
static CGFloat kRightMargin = 5.0;
static CGFloat kTopMargin = 5.0;
static CGFloat kBottomMargin = 10.0;
static CGFloat kRoundBoxLeft = 10.0;

@interface FBAnnotationClusterView()


@end

@implementation FBAnnotationClusterView


- (UILabel *)makeiOSLabel{
//:(NSString *)placeLabel {
  // add the annotation's label
  self.annotationLabel = [[UILabel alloc] initWithFrame:CGRectZero];
  self.annotationLabel.font = [UIFont systemFontOfSize:9.0];
  self.annotationLabel.textColor = [UIColor whiteColor];
  
  //self.annotationLabel.text = placeLabel;
  
  //making annotationlabela circle
  self.annotationLabel.layer.cornerRadius = 8;
  [self.annotationLabel sizeToFit]; // get the right vertical size

  // compute the optimum width of our annotation, based on the size of our annotation label
  CGFloat optimumWidth =
      self.annotationLabel.frame.size.width + kRightMargin + kLeftMargin;
  CGRect frame = self.frame;
  if (optimumWidth < kViewWidth)
    frame.size = CGSizeMake(kViewWidth, kViewLength);
  else if (optimumWidth > kMaxViewWidth)
    frame.size = CGSizeMake(kMaxViewWidth, kViewLength);
  else
    frame.size = CGSizeMake(optimumWidth, kViewLength);
  self.frame = frame;

   self.annotationLabel.lineBreakMode = NSLineBreakByTruncatingTail;
   self.annotationLabel.backgroundColor = [UIColor clearColor];
  CGRect newFrame =  self.annotationLabel.frame;
  newFrame.origin.x = kLeftMargin;
  newFrame.origin.y = kTopMargin;
  newFrame.size.width = self.frame.size.width - kRightMargin - kLeftMargin;
   self.annotationLabel.frame = newFrame;

  return  self.annotationLabel;
}

// determine the MKAnnotationView based on the annotation info and reuseIdentifier
//
- (id)initWithAnnotation:(id<MKAnnotation>)annotation
         reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
  if (self != nil) {
    FBAnnotationCluster *clusterAnnotation = (FBAnnotationCluster *)self.annotation;

    // offset the annotation so it won't obscure the actual lat/long location
    self.centerOffset = CGPointMake(50.0, 50.0);

//
    //self.backgroundColor = [UIColor clearColor];
   // self.annotationLabel = [self makeiOSLabel];
    //TODO: geocode and output on address on label - in mapItem.title];
    self.annotationLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)clusterAnnotation.annotations.count];
   // [self addSubview:self.annotationLabel];

    // add the annotation's image the annotation image snaps to the width and height of this view
//    UIImageView *annotationImage = [[UIImageView alloc]
//        initWithImage:[UIImage imageNamed:mapItem.imageName]];
 //   annotationImage.contentMode = UIViewContentModeScaleAspectFit;
 //   annotationImage.frame = CGRectMake(
//        kLeftMargin, self.annotationLabel.frame.origin.y +
//                         self.annotationLabel.frame.size.height + kTopMargin,
//        self.frame.size.width - kRightMargin - kLeftMargin,
//        self.frame.size.height - self.annotationLabel.frame.size.height -
//            kTopMargin * 2 - kBottomMargin);
//    [self addSubview:annotationImage];
  }

  return self;
}



//- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
//
//    if ([touches count] == 1) {
//        UITouch * touch = [touches anyObject];
//        if (touch.view.subviews.count ==1  && [touch tapCount] == 1) {
// 
//
// 
//                       // This is a simple tap
//  //CGPoint point = [touch locationInView:touch.view.subviews[0]];
//   // if (CGRectContainsPoint(touch.view.subviews[0].frame, point)){
//     
// //FBAnnotationClusterView  * annotationClusterView = [touch.view.subviews[0] hitTest:point withEvent:nil];
//            
//  //getting from touch MKAnnotationView container with array of MKAnnotationViews and casting it
//  
//FBAnnotationClusterView  * annotationClusterView = (FBAnnotationClusterView *) touch.view.subviews[0];
//
//  //  CGPoint point = [touch locationInView:annotationClusterView];
//  //  UIView* view = [annotationClusterView hitTest:point withEvent:nil];
//  
//// for (GridCell * aCell in cells) {
////                if (CGRectContainsPoint(aCell.frame, point)) {
////                    cell = aCell;
////                    break;
////                }
////            }
////            if (cell) {
////                // The tap was inside this cell
////            }
//            
//if (annotationClusterView.tag == 1){
//NSLog(@"%@",annotationClusterView.annotation.annotations);
//  //  [self.mapView showAnnotations:annotationClusterView.annotation.annotations animated:YES];
//  //if (touch.view isKindOfClass:[FBAnnotationClusterView class]) {
// //  NSLog(@"catched touchesBegan with tags for view %ld and label %ld",(long)annotationClusterView.tag,(long)annotationClusterView.annotationLabel.tag);
//
//}
//}
//    }
//}



//- (void)drawRect:(CGRect)rect {
//  // used to draw the rounded background box and pointer
//  FBAnnotationCluster *mapItem = (FBAnnotationCluster *)self.annotation;
//  if (mapItem != nil) {
//
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    CGContextAddEllipseInRect(ctx, rect);
//    CGContextSetFillColor(ctx,
//                          CGColorGetComponents([[UIColor blueColor] CGColor]));
//    CGContextFillPath(ctx);
//
//
//    UIView *circle =
//        [[UIView alloc] initWithFrame:CGRectMake(10, 20, 100, 100)];
//    circle.alpha = 0.5;
//    circle.layer.cornerRadius = 50;
//    circle.backgroundColor = [UIColor blueColor];
//
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
//    view.backgroundColor = [UIColor blueColor];
//
//    CAShapeLayer *shape = [CAShapeLayer layer];
//    UIBezierPath *path =
//        [UIBezierPath bezierPathWithArcCenter:view.center
//                                       radius:(view.bounds.size.width / 2)
//                                   startAngle:0
//                                     endAngle:(2 * M_PI)
//                                    clockwise:YES];
//    shape.path = path.CGPath;
//    view.layer.mask = shape;
//
//    [[UIColor darkGrayColor] setFill];
//
//    // draw the pointed shape
//    UIBezierPath *pointShape = [UIBezierPath bezierPath];
//    [pointShape moveToPoint:CGPointMake(14.0, 0.0)];
//    [pointShape addLineToPoint:CGPointMake(0.0, 0.0)];
//    [pointShape addLineToPoint:CGPointMake(self.frame.size.width,
//                                           self.frame.size.height)];
//    [pointShape fill];
//
//    // draw the rounded box
//    UIBezierPath *roundedRect = [UIBezierPath
//        bezierPathWithRoundedRect:CGRectMake(kRoundBoxLeft, 0.0,
//                                             self.frame.size.width -
//                                                 kRoundBoxLeft,
//                                             self.frame.size.height)
//                     cornerRadius:3.0];
//    roundedRect.lineWidth = 2.0;
//    [roundedRect fill];
//  }
//}

@end
