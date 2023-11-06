//
//  QianshouDragCardContainerView.m
//  QianshouDropCard
//
//  Created by Max on 2023/11/4.
//

#import "QianshouDragCardContainerView.h"
#import "QianshouDragCardConfiguration.h"

@interface QianshouDragCardContainerView()

//@property (nonatomic, strong) NSMutableArray<QianshouCardView *> *cardViews;
//@property (nonatomic, strong) NSMutableArray<UIViewController *> *cardViewControllers;
@property (nonatomic, strong) NSMutableArray<QianshouCardView *> *cardContainerViews;
@property (nonatomic, strong) NSMutableArray<UIView *> *cardViews;

@property (nonatomic, assign) QianshowDragCardDirection direction;

@property (nonatomic, assign) BOOL isDragging;

@property (nonatomic, assign) NSInteger loadedCardIndex;

@property (nonatomic, assign) CGPoint cardCenter;

@property (nonatomic, assign) CGRect initialCardFrame;
@property (nonatomic, assign) CGRect finalCardFrame;
@property (nonatomic, assign) CGAffineTransform finalCardTransform;

@property (nonatomic, strong) QianshouDragCardConfiguration *configuration;
@property (nonatomic, strong) UIViewController *parentViewController;

@end

@implementation QianshouDragCardContainerView

- (QianshouDragCardConfiguration *)defaultConfiguration {
    QianshouDragCardConfiguration *configuration = [[QianshouDragCardConfiguration alloc] init];
    
    configuration.visibleCount = 3;
    configuration.cardContainerInsets = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
    configuration.cardSpacing = 10.0f;
    configuration.cardCornerRadius = 10.0f;
    configuration.cardBorderWidth = 1.0f;
    configuration.cardBorderColor = UIColor.grayColor;
    
    return configuration;
}

- (instancetype)initWithFrame:(CGRect)frame parentViewController:(UIViewController *)parentViewController {
    return [self initWithFrame:frame configuration:[self defaultConfiguration] parentViewController:parentViewController];
}

- (instancetype)initWithFrame:(CGRect)frame configuration:(QianshouDragCardConfiguration *)configuration parentViewController:(UIViewController *)parentViewController {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.cardContainerViews = [[NSMutableArray alloc] init];
        self.cardViews = [[NSMutableArray alloc] init];
        
        self.configuration = configuration;
        self.parentViewController = parentViewController;
        
        [self configureDragCardContainerView];
    }
    
    return self;
}

- (void)reloadData {
    if ([self.dataSource respondsToSelector:@selector(numberOfRowsInDragCardContainerView:)] && [self.dataSource respondsToSelector:@selector(dragCardContainerView:cardViewForRowAtIndex:)]) {
        [self configureDragCardContainerView];
        
        [self constructCardViewHierarchy];
        [self activateCardLayout];
    }
}

- (void)configureDragCardContainerView {
    self.direction = QianshowDragCardDirectionNatural;
    
    self.isDragging = NO;
    
    self.loadedCardIndex = 0;
}

- (void)constructCardViewHierarchy {
    NSInteger totalCardCount = [self.dataSource numberOfRowsInDragCardContainerView:self];
    NSInteger addedCardCount = (totalCardCount <= self.configuration.visibleCount) ? totalCardCount : self.configuration.visibleCount;
    
    if (self.loadedCardIndex < totalCardCount) {
        for (NSInteger i = self.cardViews.count; i < (self.isDragging ? addedCardCount + 1 : addedCardCount); i++) {
            CGFloat containerWidth = self.bounds.size.width;
            CGFloat containerHeight = self.bounds.size.height;
            
            UIEdgeInsets containerInsets = self.configuration.cardContainerInsets;
            CGFloat spacing = self.configuration.cardSpacing;
            
            QianshouCardView *cardContainerView = [[QianshouCardView alloc] initWithFrame:CGRectMake(containerInsets.left, containerInsets.top, containerWidth - containerInsets.left - containerInsets.right, containerHeight - containerInsets.top - spacing - spacing - containerInsets.bottom)];
            
            if (self.loadedCardIndex >= self.configuration.visibleCount) {
                cardContainerView.frame = self.finalCardFrame;
            } else {
                if (CGRectIsEmpty(self.initialCardFrame)) {
                    self.cardCenter = cardContainerView.center;
                    
                    self.initialCardFrame = cardContainerView.frame;
                }
            }
            
            cardContainerView.tag = self.loadedCardIndex;
            
            [cardContainerView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapGesture:)]];
            [cardContainerView addGestureRecognizer:[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePanGesture:)]];
            
            [cardContainerView setConfiguration:self.configuration];
            
            [self addSubview:cardContainerView];
            [self sendSubviewToBack:cardContainerView];
            
            UIView *cardView = [self.dataSource dragCardContainerView:self cardViewForRowAtIndex:self.loadedCardIndex];
            [cardView setFrame:cardContainerView.bounds];
            
            [cardContainerView addSubview:cardView];
            
            [self.cardContainerViews addObject:cardContainerView];
            [self.cardViews addObject:cardView];
            
            self.loadedCardIndex += 1;
        }
    }
}

- (void)activateCardLayout {
    [UIView animateWithDuration:0.5f delay:0.0f usingSpringWithDamping:0.6f initialSpringVelocity:0.6f options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveEaseInOut animations:^{
        if ([self.delegate respondsToSelector:@selector(dragCardContainerViewDidBeginDragging:cardView:draggingDirection:)]) {
            [self.delegate dragCardContainerViewDidBeginDragging:self cardView:self.cardViews.firstObject draggingDirection:self.direction];
        }
        
        for (NSInteger i = 0; i < self.cardViews.count; i++) {
            QianshouCardView *cardContainerView = [self.cardContainerViews objectAtIndex:i];
            cardContainerView.transform = CGAffineTransformIdentity;
            
            CGRect initialCardFrame = self.initialCardFrame;
            
            switch (i) {
            case 0: {
                cardContainerView.frame = initialCardFrame;
            }
                break;
            case 1: {
                initialCardFrame.origin.y = initialCardFrame.origin.y + self.configuration.cardSpacing;
                
                cardContainerView.frame = initialCardFrame;
                cardContainerView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.95f, 1.0f);
            }
                break;
            case 2: {
                initialCardFrame.origin.y = initialCardFrame.origin.y + self.configuration.cardSpacing + self.configuration.cardSpacing;
                
                cardContainerView.frame = initialCardFrame;
                cardContainerView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.90f, 1.0f);
                
                if (CGRectIsEmpty(self.finalCardFrame)) {
                    self.finalCardFrame = cardContainerView.frame;
                    self.finalCardTransform = cardContainerView.transform;
                }
            }
                break;
            default:
                break;
            }
            
            cardContainerView.originTransform = cardContainerView.transform;
        }
        
    } completion:^(BOOL finished) {
        if (self.cardViews.count == 0 && [self.delegate respondsToSelector:@selector(dragCardContainerViewNeedLoad:)]) {
            [self.delegate dragCardContainerViewNeedLoad:self];
        }
    }];
}

- (void)handleTapGesture:(UITapGestureRecognizer *)sender {
    if ([self.delegate respondsToSelector:@selector(dragCardContainerView:didSelectRowAtIndex:)]) {
        [self.delegate dragCardContainerView:self didSelectRowAtIndex:sender.view.tag];
    }
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)sender {
    BOOL canDrag = YES;
    if ([self.delegate respondsToSelector:@selector(dragCardContainerViewCanDrag:cardView:)]) {
        canDrag = [self.delegate dragCardContainerViewCanDrag:self cardView:self.cardViews.firstObject];
    }
    
    if (canDrag) {
        if (sender.state == UIGestureRecognizerStateBegan) {
            
        } else if (sender.state == UIGestureRecognizerStateChanged) {
            CGPoint translation = [sender translationInView:self];
            
            QianshouCardView *cardContainerView = (QianshouCardView *)sender.view;
            cardContainerView.center = CGPointMake(sender.view.center.x + translation.x, sender.view.center.y + translation.y);
            cardContainerView.transform = CGAffineTransformRotate(cardContainerView.originTransform, (sender.view.center.x - self.cardCenter.x) / self.cardCenter.x * (M_PI_4 / 12));

            [sender setTranslation:CGPointZero inView:self];
                        
            if ([self.delegate respondsToSelector:@selector(dragCardContainerViewDidBeginDragging:cardView:draggingDirection:)]) {
                float horizontalDragRatio = (sender.view.center.x - self.cardCenter.x) / self.cardCenter.x;
                                
                if (self.isDragging) {
                    float scale = horizontalDragRatio;
                    
                    scale = fabsf(horizontalDragRatio) >= 0.8f ? 0.8f : fabsf(scale);
                    
                    CGFloat xScaleOffset = (0.95f - 0.90f) / (0.8f / scale);
                    CGFloat yTranslateOffset = self.configuration.cardSpacing / (0.8f / scale);
                    
                    for (NSInteger i = 1; i < self.cardViews.count; i++) {
                        QianshouCardView *cardContainerView = (QianshouCardView *)self.cardContainerViews[i];
                        
                        switch (i) {
                            case 1: {
                                CGAffineTransform scale = CGAffineTransformScale(CGAffineTransformIdentity, xScaleOffset + 0.95f, 1.0f);
                                CGAffineTransform translate = CGAffineTransformTranslate(scale, 0.0f, -yTranslateOffset);
                                
                                cardContainerView.transform = translate;
                            }
                                break;
                            case 2: {
                                CGAffineTransform scale = CGAffineTransformScale(CGAffineTransformIdentity, xScaleOffset + 0.90f, 1.0f);
                                CGAffineTransform translate = CGAffineTransformTranslate(scale, 0.0f, -yTranslateOffset);
                                
                                cardContainerView.transform = translate;
                            }
                                break;
                            case 3: {
                                cardContainerView.transform = self.finalCardTransform;
                            }
                                break;
                            default:
                                break;
                        }
                    }
                } else {
                    self.isDragging = YES;
                    
                    [self constructCardViewHierarchy];
                }
                
                if (horizontalDragRatio > 0.0f) {
                    self.direction = QianshowDragCardDirectionLeftToRight;
                } else if (horizontalDragRatio < 0.0f) {
                    self.direction = QianshowDragCardDirectionRightToLeft;
                } else {
                    self.direction = QianshowDragCardDirectionNatural;
                }
                
                [self.delegate dragCardContainerViewDidBeginDragging:self cardView:self.cardViews.firstObject draggingDirection:self.direction];
            }
        } else if (sender.state == UIGestureRecognizerStateEnded || sender.state == UIGestureRecognizerStateEnded) {
            float horizontalDragRatio = (sender.view.center.x - self.cardCenter.x) / self.cardCenter.x;
                        
            if (fabs(horizontalDragRatio) > 0.8f) {
                if ([self.delegate respondsToSelector:@selector(dragCardContainerViewDidEndDragging:cardView:draggingDirection:)]) {
                    [self.delegate dragCardContainerViewDidEndDragging:self cardView:self.cardViews.firstObject draggingDirection:self.direction];
                }
                
                QianshouCardView *cardContainerView = (QianshouCardView *)sender.view;
                UIView *cardView = self.cardViews.firstObject;
                
                NSInteger flag = self.direction == QianshowDragCardDirectionRightToLeft ? -1 : 2;
                
                [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveLinear animations:^{
                    cardContainerView.center = CGPointMake(flag * [UIScreen mainScreen].bounds.size.width, flag * [UIScreen mainScreen].bounds.size.width / horizontalDragRatio + self.cardCenter.y);
                } completion:^(BOOL finished) {
                    [cardView removeFromSuperview];
                    
                    [cardContainerView removeFromSuperview];
                }];
                
                [self.cardContainerViews removeObject:cardContainerView];
                [self.cardViews removeObject:cardView];
            } else {
                if (self.isDragging && self.cardViews.count > self.configuration.visibleCount) {
                    QianshouCardView *finalCardContainerView = self.cardViews.lastObject;
                    UIView *finalCardView = self.cardViews.lastObject;
  
                    [finalCardView removeFromSuperview];

                    [finalCardContainerView removeFromSuperview];
                                                            
                    [self.cardContainerViews removeObject:finalCardContainerView];
                    [self.cardViews removeObject:finalCardView];
                    
                    self.loadedCardIndex = finalCardContainerView.tag;
                }
            }
            
            self.isDragging = NO;
            
            [self activateCardLayout];
        }
    }
}

@end
