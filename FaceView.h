//
//  FaceView.h
//  Happiness
//
//  Created by HaoQi on 1/6/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FaceView : UIView

// public property
@property (nonatomic) CGFloat scale;

// public pinch
- (void) pinch:(UIPinchGestureRecognizer *)gesture;

@end
