//
//  HappinessViewController.m
//  Happiness
//
//  Created by HaoQi on 1/6/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "HappinessViewController.h"
#import "FaceView.h"

// private outlet controller to view
@interface HappinessViewController() <FaceViewDataSource>
@property (nonatomic, weak) IBOutlet FaceView *faceView;
@end

@implementation HappinessViewController

@synthesize happiness = _happiness;
@synthesize faceView = _faceView;

// redraw everytime model changes
- (void) setHappiness:(int)happiness
{
    _happiness = happiness;
    [self.faceView setNeedsDisplay]; // never call drawRect directly
}

- (void)setFaceView:(FaceView *)faceView
{
    _faceView = faceView;
    [self.faceView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self.faceView action:@selector(pinch:)]];
    
    [self.faceView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleHappinessGesture:)]];
    
    self.faceView.dataSource = self;
}

- (void) handleHappinessGesture:(UIPanGestureRecognizer *)gesture
{
    if ((gesture.state == UIGestureRecognizerStateChanged) ||
        (gesture.state == UIGestureRecognizerStateEnded)) {
        // inView asks for which coordinate system
        CGPoint translation = [gesture translationInView:self.faceView];
        self.happiness -= translation.y / 2;
        [gesture setTranslation:CGPointZero inView:self.faceView];
    }
}
- (float)smileForFaceView:(FaceView *)sender
{
    // model's happiness is 0 - 100
    // smiley is -1 to 1
    // so this controller converts that
    return (self.happiness - 50) / 50.0;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}
@end
