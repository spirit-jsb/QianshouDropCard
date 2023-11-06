//
//  QianshouDragCardContainerView.h
//  QianshouDropCard
//
//  Created by Max on 2023/11/4.
//

#import <UIKit/UIKit.h>
#import "QianshouCardView.h"
#import "QianshouDragCardConfiguration.h"

@class QianshouDragCardContainerView;

@protocol QianshouDragCardContainerDataSource <NSObject>

@required
- (NSInteger)numberOfRowsInDragCardContainerView:(QianshouDragCardContainerView *)dragCardContainerView;
//- (UIViewController *_Nonnull)dragCardContainerView:(QianshouDragCardContainerView *)dragCardContainerView cardViewControllerForRowAtIndex:(NSInteger)index;
- (UIView *_Nonnull)dragCardContainerView:(QianshouDragCardContainerView *)dragCardContainerView cardViewForRowAtIndex:(NSInteger)index;

@end

@protocol QianshouDragCardContainerDelegate <NSObject>

@optional
- (void)dragCardContainerView:(QianshouDragCardContainerView *)dragCardContainerView didSelectRowAtIndex:(NSInteger *)index;
- (void)dragCardContainerViewNeedLoad:(QianshouDragCardContainerView *)dragCardContainerView;
//- (BOOL)dragCardContainerViewCanDrag:(QianshouDragCardContainerView *)dragCardContainerView cardViewController:(UIViewController *)cardViewController;
//- (void)dragCardContainerViewDidBeginDragging:(QianshouDragCardContainerView *)dragCardContainerView cardViewController:(UIViewController *)cardViewController draggingDirection:(QianshowDragCardDirection)draggingDirection;
//- (void)dragCardContainerViewDidEndDragging:(QianshouDragCardContainerView *)dragCardContainerView cardViewController:(UIViewController *)cardViewController draggingDirection:(QianshowDragCardDirection)draggingDirection;
- (BOOL)dragCardContainerViewCanDrag:(QianshouDragCardContainerView *)dragCardContainerView cardView:(UIView *)cardView;
- (void)dragCardContainerViewDidBeginDragging:(QianshouDragCardContainerView *)dragCardContainerView cardView:(UIView *)cardView draggingDirection:(QianshowDragCardDirection)draggingDirection;
- (void)dragCardContainerViewDidEndDragging:(QianshouDragCardContainerView *)dragCardContainerView cardView:(UIView *)cardView draggingDirection:(QianshowDragCardDirection)draggingDirection;

@end

@interface QianshouDragCardContainerView : UIView

@property (nonatomic, weak, nullable) id <QianshouDragCardContainerDataSource> dataSource;
@property (nonatomic, weak, nullable) id <QianshouDragCardContainerDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame parentViewController:(UIViewController *)parentViewController;
- (instancetype)initWithFrame:(CGRect)frame configuration:(QianshouDragCardConfiguration *)configuration parentViewController:(UIViewController *)parentViewController;

- (void)reloadData;

@end
