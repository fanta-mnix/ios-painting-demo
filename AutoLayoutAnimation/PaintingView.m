//
//  PaintingView.m
//  AutoLayoutAnimation
//
//  Created by Rafael Fantini da Costa on 9/15/15.
//  Copyright © 2015 Rafael Fantini da Costa. All rights reserved.
//

#import "PaintingView.h"
#import <QuartzCore/QuartzCore.h>

@interface PaintingView ()

@property (nonatomic) CGContextRef offscreenContext;
@property (nonatomic) CGPoint lastLocation;

@end

@implementation PaintingView

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.offscreenContext != NULL) {
        CGContextRelease(self.offscreenContext);
    }

    //CGFloat scale = [UIScreen mainScreen].scale;
    CGSize viewSize = self.frame.size;
    size_t width = viewSize.width;
    size_t height = viewSize.height;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    self.offscreenContext = CGBitmapContextCreate(NULL, width, height, 8, 0, colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedFirst);
    CGColorSpaceRelease(colorSpace);
}

- (void)dealloc {
    if (self.offscreenContext != NULL) {
        CGContextRelease(self.offscreenContext);
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSAssert(self.offscreenContext != NULL, @"nil");
    self.lastLocation = [[touches anyObject] locationInView:self];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UIColor *strokeColor = self.strokeColor ?: [UIColor blackColor];
    
    if (self.isErasing) {
        CGContextSaveGState(self.offscreenContext);
        CGContextSetBlendMode(self.offscreenContext, kCGBlendModeClear);
    }
    
    CGContextSetLineWidth(self.offscreenContext, 10);
    CGContextSetLineCap(self.offscreenContext, kCGLineCapRound);
    CGContextSetStrokeColorWithColor(self.offscreenContext, strokeColor.CGColor);
    
    CGContextMoveToPoint(self.offscreenContext,
                         self.lastLocation.x,
                         self.lastLocation.y);
    
    CGPoint touchLocation = [[touches anyObject] locationInView:self];
    CGContextAddLineToPoint(self.offscreenContext, touchLocation.x, touchLocation.y);
    CGContextStrokePath(self.offscreenContext);
    
    if (self.isErasing) {
        CGContextRestoreGState(self.offscreenContext);
    }
    
    self.lastLocation = touchLocation;
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    NSAssert(self.offscreenContext != NULL, @"nil");
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGImageRef offscreenImage = CGBitmapContextCreateImage(self.offscreenContext);
    CGContextDrawImage(context, self.bounds, offscreenImage);
    CGImageRelease(offscreenImage);
}


@end
