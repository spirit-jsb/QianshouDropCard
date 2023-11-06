//
//  QianshouCardView.h
//  QianshouDropCard
//
//  Created by Max on 2023/11/4.
//

#import <UIKit/UIKit.h>
#import "QianshouDragCardConfiguration.h"

@interface QianshouCardView : UIView

@property (nonatomic, assign) CGAffineTransform originTransform;

@property (nonatomic, strong) QianshouDragCardConfiguration *configuration;

@end
