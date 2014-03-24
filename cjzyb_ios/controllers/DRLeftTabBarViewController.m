//
//  DRLeftTabBarViewController.m
//  cjzyb_ios
//
//  Created by david on 14-2-26.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "DRLeftTabBarViewController.h"
#import "UserInfoPopViewController.h"
#import "ImageSelectedViewController.h"

#define ORIGINAL_MAX_WIDTH 640.0f

#import "UserObjDaoInterface.h"

@interface DRLeftTabBarViewController ()
@property (nonatomic,strong) LeftTabBarView *leftTabBar;
@property (nonatomic,strong) UserInfoPopViewController *userInfoPopViewController;
@property (nonatomic,strong) WYPopoverController *poprController;
@property (nonatomic,strong) StudentListViewController *studentListViewController;
@end

@implementation DRLeftTabBarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void) roundView: (UIView *) view{
    [view.layer setCornerRadius: (view.frame.size.height/2)];
    [view.layer setMasksToBounds:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    //设置左边栏
    NSArray *bundles = [[NSBundle mainBundle] loadNibNamed:@"LeftTabBarView" owner:self options:nil];
    self.leftTabBar = (LeftTabBarView*)[bundles objectAtIndex:0];
    self.leftTabBar.delegate = self;
    _isHiddleLeftTabBar = YES;
    self.leftTabBar.frame = (CGRect){-120,67,120,1024-67};
    [self.view addSubview:self.leftTabBar];
    [self.leftTabBar defaultSelected];
    
    //设置导航栏
    self.drNavigationBar = [[[NSBundle mainBundle]  loadNibNamed:@"DRNavigationBar" owner:self options:nil] firstObject];
    [self.drNavigationBar.rightButtonItem addTarget:self action:@selector(navigationRightItemClicked) forControlEvents:UIControlEventTouchUpInside];
    [self roundView:self.drNavigationBar.userHeaderImage];
    [self.drNavigationBar.imageButton addTarget:self action:@selector(selectedImage:) forControlEvents:UIControlEventTouchUpInside];
    [self.drNavigationBar.leftButtonItem addTarget:self action:@selector(navigationLeftItemClicked) forControlEvents:UIControlEventTouchUpInside];
    self.drNavigationBar.frame = (CGRect){0,0,768,67};
    self.drNavigationBar.userNameLabel.text = [[[DataService sharedService] user] nickName];
    [self.view addSubview:self.drNavigationBar];
    //设置子controller
    self.currentViewController = [self.childenControllerArray firstObject];
    if (self.currentViewController) {
        [self addOneController:self.currentViewController];
    }
    
    //加载用户信息界面
    self.userInfoPopViewController = [[UserInfoPopViewController alloc] initWithNibName:@"UserInfoPopViewController" bundle:nil];
    
    //加载学生列表界面
    self.studentListViewController = [[StudentListViewController alloc] initWithNibName:@"StudentListViewController" bundle:nil];
    self.studentListViewController.delegate = self;
    
    //相册
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showImageWithAlbum:) name:@"showImageWithAlbum" object:nil];
    //拍照
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showImageWithCamera:) name:@"showImageWithCamera" object:nil];
}

-(void)showImageWithAlbum:(NSNotification *)object {
    [self.poprController dismissPopoverAnimated:YES];
    
    // 从相册中选取
    if ([self isPhotoLibraryAvailable]) {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
        [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
        controller.mediaTypes = mediaTypes;
        controller.delegate = self;
        [self presentViewController:controller
                           animated:YES
                         completion:^(void){
                             NSLog(@"Picker View Controller is presented");
                         }];
    }
    
}
-(void)showImageWithCamera:(NSNotification *)object {
    [self.poprController dismissPopoverAnimated:YES];
    // 拍照
    if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]) {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.sourceType = UIImagePickerControllerSourceTypeCamera;
        if ([self isFrontCameraAvailable]) {
            controller.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        }
        NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
        [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
        controller.mediaTypes = mediaTypes;
        controller.delegate = self;
        [self presentViewController:controller
                           animated:YES
                         completion:^(void){
                             NSLog(@"Picker View Controller is presented");
                         }];
    }
}
#pragma mark 子controller之间切换
-(void)addOneController:(UIViewController*)childController{
    if (!childController) {
        return;
    }
    [childController willMoveToParentViewController:childController];
    childController.view.frame = (CGRect){0,67,768,1024-67};
    [self.view addSubview:childController.view];
    [childController didMoveToParentViewController:self];
    [self.view bringSubviewToFront:self.leftTabBar];
}

-(void)changeFromController:(UIViewController*)from toController:(UIViewController*)to{
    if (!from || !to) {
        return;
    }
    if (from == to) {
        return;
    }
    to.view.frame =  (CGRect){0,67,768,1024-67};
    [self transitionFromViewController:from toViewController:to duration:0 options:UIViewAnimationOptionTransitionNone animations:^{
        
    } completion:^(BOOL finished) {
        self.currentViewController = to;
        [self.view bringSubviewToFront:self.leftTabBar];
    }];
    [self.view bringSubviewToFront:self.leftTabBar];
}
#pragma mark --

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 导航栏
///导航栏左边item点击事件
-(void)navigationLeftItemClicked{
    self.isHiddleLeftTabBar = !self.isHiddleLeftTabBar;
    if (self.isHiddleLeftTabBar) {
        self.leftTabBar.userGroupTabBarItem.isSelected = NO;
        [self hiddleStudentListViewController:self.studentListViewController];
    }
}
///导航栏右边item点击事件
-(void)navigationRightItemClicked{
    

//    return;
    /////////////////////////////////////////
    [self.drNavigationBar.rightButtonItem setUserInteractionEnabled:NO];
    self.poprController= [[WYPopoverController alloc] initWithContentViewController:self.userInfoPopViewController];
    self.poprController.theme.tintColor = [UIColor colorWithRed:53./255. green:207./255. blue:143./255. alpha:1.0];
    self.poprController.theme.fillTopColor = [UIColor colorWithRed:53./255. green:207./255. blue:143./255. alpha:1.0];
    self.poprController.theme.fillBottomColor = [UIColor colorWithRed:53./255. green:207./255. blue:143./255. alpha:1.0];
    self.poprController.theme.glossShadowColor = [UIColor colorWithRed:53./255. green:207./255. blue:143./255. alpha:1.0];
    
    self.poprController.popoverContentSize = (CGSize){224,293};
    CGRect rect = (CGRect){720,0,50,70};
    [self.poprController presentPopoverFromRect:rect inView:self.view permittedArrowDirections:WYPopoverArrowDirectionUp animated:YES completion:^{
        [self.drNavigationBar.rightButtonItem setUserInteractionEnabled:YES];
    }];
    self.userInfoPopViewController.drleftTabBarController = self;
    [self.userInfoPopViewController updateViewContents];
}

-(void)selectedImage:(id)sender {
    UIButton *btn = (UIButton *)sender;
    
    ImageSelectedViewController *imageView = [[ImageSelectedViewController alloc]initWithNibName:@"ImageSelectedViewController" bundle:nil];
    self.poprController= [[WYPopoverController alloc] initWithContentViewController:imageView];
    self.poprController.theme.tintColor = [UIColor colorWithRed:53./255. green:207./255. blue:143./255. alpha:1.0];
    self.poprController.theme.fillTopColor = [UIColor colorWithRed:53./255. green:207./255. blue:143./255. alpha:1.0];
    self.poprController.theme.fillBottomColor = [UIColor colorWithRed:53./255. green:207./255. blue:143./255. alpha:1.0];
    self.poprController.theme.glossShadowColor = [UIColor colorWithRed:53./255. green:207./255. blue:143./255. alpha:1.0];
    
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    __block UIBarButtonItem *barItemm = barItem;
    self.poprController.popoverContentSize = (CGSize){164,86};
    [self.poprController presentPopoverFromBarButtonItem:barItem permittedArrowDirections:WYPopoverArrowDirectionUp animated:YES completion:^{
        barItemm=nil;
    }];
}
#pragma mark --
///隐藏学生列表
-(void)hiddleStudentListViewController:(StudentListViewController*)controller{
    if ([self.childViewControllers containsObject:controller]) {
        [self.view setUserInteractionEnabled:NO];
        [controller willMoveToParentViewController:nil];
        [UIView animateWithDuration:0.5 animations:^{
            controller.view.center = (CGPoint){-CGRectGetWidth(controller.view.frame),controller.view.center.y};
        } completion:^(BOOL finished) {
            [controller.view removeFromSuperview];
            [controller removeFromParentViewController];
            [controller didMoveToParentViewController:nil];
            [self.view setUserInteractionEnabled:YES];
        }];
        
    }
}
///显示学生列表
-(void)appearStudentListViewController:(StudentListViewController*)controller{
    if (![self.childViewControllers containsObject:controller]) {
        [self.view setUserInteractionEnabled:NO];
        [controller willMoveToParentViewController:self];
        [self addChildViewController:controller];
        controller.view.frame = (CGRect){-CGRectGetWidth(controller.view.frame),CGRectGetMinY(self.leftTabBar.frame),200,CGRectGetHeight(self.leftTabBar.frame)};
        [self.view addSubview:controller.view];
        [controller didMoveToParentViewController:self];
        [self.view bringSubviewToFront:self.leftTabBar];
        [UIView animateWithDuration:0.5 animations:^{
            controller.view.frame = (CGRect){CGRectGetMaxX(self.leftTabBar.frame)-12,CGRectGetMinY(self.leftTabBar.frame),200,CGRectGetHeight(self.leftTabBar.frame)};
        } completion:^(BOOL finished) {
            [self.view setUserInteractionEnabled:YES];
        }];
        
    }
}
#pragma mark LeftTabBarViewDelegate 左边栏代理
-(void)leftTabBar:(LeftTabBarView *)tabBarView selectedItem:(LeftTabBarItemType)itemType{
    NSLog(@"%d",itemType);
    if (itemType == LeftTabBarItemType_userGroup ) {
        if (tabBarView.userGroupTabBarItem.isSelected) {
            [self appearStudentListViewController:self.studentListViewController];
        }else{
            [self hiddleStudentListViewController:self.studentListViewController];
        }
        return;
    }else{
        if (tabBarView.userGroupTabBarItem.isSelected) {
            tabBarView.userGroupTabBarItem.isSelected = NO;
             [self hiddleStudentListViewController:self.studentListViewController];
        }
    }
    
    if (itemType < self.childenControllerArray.count) {
        [self changeFromController:self.currentViewController toController:[self.childenControllerArray objectAtIndex:itemType]];
    }
}
#pragma mark --

#pragma mark StudentListViewControllerDelegate学生列表点击返回按钮
-(void)studentListViewController:(StudentListViewController *)controller backButtonClicked:(UIButton *)button{
    self.leftTabBar.userGroupTabBarItem.isSelected = NO;
    [self hiddleStudentListViewController:controller];
}
#pragma mark --

///设置隐藏左侧边栏
-(void)hiddleLeftTabBar:(BOOL)isHiddle withAnimation:(BOOL)animation{
     [self.drNavigationBar.leftButtonItem setEnabled:NO];
    if (animation) {
        [self.leftTabBar.layer removeAllAnimations];
        if (isHiddle) {
            self.leftTabBar.center = (CGPoint){CGRectGetWidth(self.leftTabBar.frame)/2,self.leftTabBar.center.y};
        }else{
            self.leftTabBar.center = (CGPoint){-CGRectGetWidth(self.leftTabBar.frame),self.leftTabBar.center.y};
        }
        
        [UIView animateWithDuration:0.5 animations:^{
            if (isHiddle) {
                self.leftTabBar.center = (CGPoint){-CGRectGetWidth(self.leftTabBar.frame),self.leftTabBar.center.y};
            }else{
                self.leftTabBar.center = (CGPoint){CGRectGetWidth(self.leftTabBar.frame)/2,self.leftTabBar.center.y};
            }
        } completion:^(BOOL finished) {
            [self.drNavigationBar.leftButtonItem setEnabled:YES];
        }];
    }else{
        if (isHiddle) {
            self.leftTabBar.center = (CGPoint){-CGRectGetWidth(self.leftTabBar.frame),self.leftTabBar.center.y};
        }else{
            self.leftTabBar.center = (CGPoint){CGRectGetWidth(self.leftTabBar.frame)/2,self.leftTabBar.center.y};
        }
        [self.drNavigationBar.leftButtonItem setEnabled:YES];
    }
}


#pragma mark progerty
-(void)setIsHiddleLeftTabBar:(BOOL)isHiddleLeftTabBar{
    _isHiddleLeftTabBar = isHiddleLeftTabBar;
    [self hiddleLeftTabBar:isHiddleLeftTabBar withAnimation:YES];
}

-(void)setChildenControllerArray:(NSArray *)childenControllerArray{
    if (_childenControllerArray != childenControllerArray && childenControllerArray&& childenControllerArray.count > 0) {
        for (UIViewController *controller in childenControllerArray) {
            [self addChildViewController:controller];
        }
    }
    
    _childenControllerArray = childenControllerArray;
}
#pragma mark --

//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    [super touchesBegan:touches withEvent:event];
//    self.isHiddleLeftTabBar = YES;
//}
#pragma mark VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    self.drNavigationBar.userHeaderImage.image = editedImage;
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        
        UserObjDaoInterface
        
        
    }];
}

- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        portraitImg = [self imageByScalingToMaxSize:portraitImg];
        // 裁剪
        VPImageCropperViewController *imgEditorVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:3.0];
        imgEditorVC.delegate = self;
        [self presentViewController:imgEditorVC animated:YES completion:^{
            // TO DO
        }];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^(){
    }];
}

#pragma mark camera utility
- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL) isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickVideosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickPhotosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}

#pragma mark image scale utility
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

@end
