//
//  QianshouCardView.m
//  QianshouDropCard
//
//  Created by Max on 2023/11/4.
//

#import "QianshouCardView.h"

@implementation QianshouCardView

- (void)setConfiguration:(QianshouDragCardConfiguration *)configuration {
    _configuration = configuration;
    
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = configuration.cardCornerRadius;
    self.layer.cornerCurve = kCACornerCurveContinuous;
    self.layer.borderWidth = configuration.cardBorderWidth;
    self.layer.borderColor = configuration.cardBorderColor.CGColor;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self configureView];
    }
    
    return self;
}

- (void)dealloc {
    NSLog(@"**** QianshouCardView %ld is dealloc ****", self.tag);
}

- (void)configureView {
    self.userInteractionEnabled = YES;
}

@end
