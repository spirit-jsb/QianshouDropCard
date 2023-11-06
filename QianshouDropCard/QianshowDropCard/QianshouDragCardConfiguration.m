//
//  QianshouDragCardConfiguration.m
//  QianshouDropCard
//
//  Created by Max on 2023/11/4.
//

#import "QianshouDragCardConfiguration.h"

@implementation QianshouDragCardConfiguration

- (NSInteger)visibleCount {
    return 3;
}

- (UIEdgeInsets)cardContainerInsets {
    return UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
}

- (CGFloat)cardSpacing {
    return 10.0f;
}

- (CGFloat)cardCornerRadius {
    return 10.0f;
}

- (CGFloat)cardBorderWidth {
    return 1.0f;
}

- (UIColor *)cardBorderColor {
    return [UIColor grayColor];
}

@end
