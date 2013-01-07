//
//  FaceView.h
//  Happiness
//
//  Created by HaoQi on 1/6/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

// forward reference for the compiler
@class FaceView;

@protocol FaceViewDataSource
// passing myself when delegating (normally done this way)
- (float)smileForFaceView:(FaceView *)sender;
@end

@interface FaceView : UIView

// public property
@property (nonatomic) CGFloat scale;

// public pinch
- (void) pinch:(UIPinchGestureRecognizer *)gesture;

@property (nonatomic, weak) IBOutlet id <FaceViewDataSource> dataSource;

@end
