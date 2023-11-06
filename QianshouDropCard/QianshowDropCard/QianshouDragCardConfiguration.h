//
//  QianshouDragCardConfiguration.h
//  QianshouDropCard
//
//  Created by Max on 2023/11/4.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, QianshowDragCardDirection) {
    QianshowDragCardDirectionNatural,
    QianshowDragCardDirectionLeftToRight,
    QianshowDragCardDirectionRightToLeft
};

@interface QianshouDragCardConfiguration : NSObject

@property (nonatomic, assign) QianshowDragCardDirection direction;

@property (nonatomic, assign) NSInteger visibleCount;

@property (nonatomic, assign) UIEdgeInsets cardContainerInsets;
@property (nonatomic, assign) CGFloat cardSpacing;

@property (nonatomic, assign) CGFloat cardCornerRadius;

@property (nonatomic, assign) CGFloat cardBorderWidth;
@property (nonatomic, strong) UIColor *cardBorderColor;

@end
