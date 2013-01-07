//
//  FaceView.m
//  Happiness
//
//  Created by HaoQi on 1/6/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "FaceView.h"

@implementation FaceView

@synthesize dataSource = _dataSource;
@synthesize scale = _scale;

#define DEFAULT_SCALE 0.90

// getter of scale
- (CGFloat)scale
{
    if (!_scale){
        return DEFAULT_SCALE;
    } 
    return _scale;
}
// setter of scale
- (void)setScale:(CGFloat)scale
{
    if (scale != _scale) { // redraw is expensive
        _scale = scale;
        [self setNeedsDisplay]; // needs to redraw
    }
}

// handler implementation of pinch
- (void)pinch:(UIPinchGestureRecognizer *)gesture
{
    if ((gesture.state == UIGestureRecognizerStateChanged) || (gesture.state == UIGestureRecognizerStateEnded)) {
        self.scale *= gesture.scale;
        // reset scale to 1
        gesture.scale = 1;
    }
}
- (void)setup
{
    self.contentMode = UIViewContentModeRedraw;
}

- (void) awakeFromNib
{
    [self setup];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}

- (void)drawCircleAtPoint:(CGPoint)p withRadius:(CGFloat)radius inContext:(CGContextRef)context
{
    UIGraphicsPushContext(context); //goes with pop at end
    
    CGContextBeginPath(context);
    
    CGContextAddArc(context, p.x, p.y, radius, 0, 2*M_PI, YES);
    
    CGContextStrokePath(context);
    
    UIGraphicsPopContext();
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
// called by setNeedsDisplay
- (void)drawRect:(CGRect)rect
{
    // almost always get context
    CGContextRef context = UIGraphicsGetCurrentContext();

    // get midpoint of face
    CGPoint midPoint;
    midPoint.x = self.bounds.origin.x + self.bounds.size.width/2;
    midPoint.y = self.bounds.origin.y + self.bounds.size.height/2;
    
    CGFloat size = (self.bounds.size.height < self.bounds.size.width) ? (self.bounds.size.height / 2) : (self.bounds.size.width / 2);
    size *= self.scale;
    
    CGContextSetLineWidth(context, 5.0);
    [[UIColor blueColor] setStroke];
    
    // draw face (circle)
    [self drawCircleAtPoint:midPoint withRadius:size inContext:context];
    
    // draw eyes (2 circle)
#define EYE_H 0.35
#define EYE_V 0.35
#define EYE_RADIUS 0.10
    
    CGPoint eyePoint;
    eyePoint.x = midPoint.x - size * EYE_H;
    eyePoint.y = midPoint.y - size * EYE_V;
    
    [self drawCircleAtPoint:eyePoint withRadius:size * EYE_RADIUS inContext:context];
    eyePoint.x += size * EYE_H * 2;
    [self drawCircleAtPoint:eyePoint withRadius:size * EYE_RADIUS inContext:context];
    
    // draw mouth
#define MOUTH_H 0.45
#define MOUTH_V 0.40
#define MOUTH_SMILE 0.25
    
    CGPoint mouthStart;
    mouthStart.x = midPoint.x - MOUTH_H * size;
    mouthStart.y = midPoint.y + MOUTH_V * size;
    CGPoint mouthEnd = mouthStart;
    mouthEnd.x += MOUTH_H * size * 2;
    CGPoint mouthCP1 = mouthStart;
    mouthCP1.x += MOUTH_H * size * 2/3;
    CGPoint mouthCP2 = mouthEnd;
    mouthCP2.x -= MOUTH_H * size * 2/3;
    
    // this should be delegated
    // it's our faceview's data
    float smile = [self.dataSource smileForFaceView:self];
    if (smile < -1 ) smile = -1;
    if (smile > 1) smile = 1;
    
    CGFloat smileOffset = MOUTH_SMILE * size * smile;
    mouthCP1.y += smileOffset;
    mouthCP2.y += smileOffset;
    
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, mouthStart.x, mouthStart.y);
    CGContextAddCurveToPoint(context, mouthCP1.x, mouthCP1.y, mouthCP2.x, mouthCP2.y, mouthEnd.x, mouthEnd.y);
    CGContextStrokePath(context);
    
}


@end
