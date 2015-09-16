//
//  ViewController.m
//  AutoLayoutAnimation
//
//  Created by Rafael Fantini da Costa on 9/15/15.
//  Copyright © 2015 Rafael Fantini da Costa. All rights reserved.
//

#import "ViewController.h"
#import "PaintingView.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet PaintingView *paintingView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)buttonPressed:(id)sender {
    self.paintingView.erasing = !self.paintingView.isErasing;
}

@end
