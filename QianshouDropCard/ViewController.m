//
//  ViewController.m
//  QianshouDropCard
//
//  Created by Max on 2023/11/4.
//

#import "ViewController.h"
#import "QianshouDragCardContainerView.h"

@interface ViewController ()<QianshouDragCardContainerDataSource, QianshouDragCardContainerDelegate>

@property (nonatomic,strong)  QianshouDragCardContainerView *containerView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    QianshouDragCardConfiguration *configuration = [[QianshouDragCardConfiguration alloc] init];
    configuration.visibleCount = 3;
    configuration.cardContainerInsets = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
    configuration.cardSpacing  = 10.0f;
    configuration.cardCornerRadius = 10.0f;
    configuration.cardBorderWidth = 1.0f;
    configuration.cardBorderColor = [UIColor grayColor];
    
    self.containerView = [[QianshouDragCardContainerView alloc] initWithFrame:[UIScreen mainScreen].bounds configuration:configuration parentViewController:self];
    self.containerView.dataSource = self;
    self.containerView.delegate = self;
    
    [self.view addSubview:self.containerView];
    
    [self.containerView reloadData];
}

- (NSInteger)numberOfRowsInDragCardContainerView:(QianshouDragCardContainerView *)dropCardContainerView {
    return 10;
}

- (UIView *)dragCardContainerView:(QianshouDragCardContainerView *)dragCardContainerView cardViewForRowAtIndex:(NSInteger)index {
//    let loadName = nibname == nil ? "\(Self.self)" : nibname!
//            return Bundle.main.loadNibNamed(loadName, owner: nil, options: nil)![index] as! Self
    return [[NSBundle mainBundle] loadNibNamed:@"ScrollContainerView" owner:nil options:nil].firstObject;
}

- (void)dragCardContainerViewDidBeginDragging:(QianshouDragCardContainerView *)dragCardContainerView cardView:(UIView *)cardView draggingDirection:(QianshowDragCardDirection)draggingDirection {
    NSLog(@"**** didBeginDragging draggingDirection %ld ****", draggingDirection);
}

- (void)dragCardContainerViewDidEndDragging:(QianshouDragCardContainerView *)dragCardContainerView cardView:(UIView *)cardView draggingDirection:(QianshowDragCardDirection)draggingDirection {
    NSLog(@"**** didEndDragging draggingDirection %ld ****", draggingDirection);
}

//- (UIViewController *)dragCardContainerView:(QianshouDragCardContainerView *)dropCardContainerView cardViewControllerForRowAtIndex:(NSInteger)index {
//    return [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ScrollContainerViewController"];
//}

//- (void)dragCardContainerViewDidBeginDragging:(QianshouDragCardContainerView *)dragCardContainerView cardViewController:(UIViewController *)cardViewController draggingDirection:(QianshowDragCardDirection)draggingDirection {
//    NSLog(@"**** didBeginDragging draggingDirection %ld ****", draggingDirection);
//}
//
//- (void)dragCardContainerViewDidEndDragging:(QianshouDragCardContainerView *)dragCardContainerView cardViewController:(UIViewController *)cardViewController draggingDirection:(QianshowDragCardDirection)draggingDirection {
//    NSLog(@"**** didEndDragging draggingDirection %ld ****", draggingDirection);
//}

@end
