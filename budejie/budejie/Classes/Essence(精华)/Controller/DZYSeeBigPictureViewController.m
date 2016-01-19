//
//  DZYSeeBigPictureViewController.m
//  budejie
//
//  Created by dzy on 16/1/18.
//  Copyright © 2016年 董震宇. All rights reserved.
//

#import "DZYSeeBigPictureViewController.h"
#import "DZYTopicModel.h"
#import <UIImageView+WebCache.h>
#import <Photos/Photos.h>
#import <SVProgressHUD.h>

@interface DZYSeeBigPictureViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (nonatomic, weak) UIImageView *imageView;

/** 相册 */
@property (nonatomic, strong) PHAssetCollection *assetCollection;

- (PHFetchResult *)assets;
@end

@implementation DZYSeeBigPictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    DZYLog(@"%@", NSStringFromCGRect(self.view.frame));
    
    // scrollView
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = [UIScreen mainScreen].bounds;
    scrollView.backgroundColor = [UIColor blackColor];
    [scrollView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(back)]];
    [self.view insertSubview:scrollView atIndex:0];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.topicModel.image1] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image == nil) {
            return ;
        }
        self.saveButton.enabled = YES;
    }];
    [scrollView addSubview:imageView];
    self.imageView = imageView;
    
    // imageView - frame
    CGFloat imageW = DZYScreenW;
    CGFloat imageH = imageW * self.topicModel.height / self.topicModel.width;
    CGFloat imageY = 0;
    if (imageH < DZYScreenH) { // 图片高度不够
        imageY = (DZYScreenH - imageH) * 0.5;
    } else { // 超过一个屏幕的高度
        scrollView.contentSize = CGSizeMake(0, imageH);
    }
    imageView.frame = CGRectMake(0, imageY, imageW, imageH);
    
    // scrollView缩放比例
    CGFloat scale = self.topicModel.height / imageH;
    if (scale > 1.0) {
        scrollView.maximumZoomScale = scale;
        scrollView.delegate = self;
    }
}

#pragma mark - 代理方法
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

#pragma mark - 监听点击
- (IBAction)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)save {
    // 判断用户对当前应用访问相册的授权状态
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    switch (status) {
        // 用户还没有授权过当前App(用户还没有做出选择，从未弹框让用户选择)
        case PHAuthorizationStatusNotDetermined: {
            // 主动弹框请求授权
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus justNowStatus) {
                if (justNowStatus == PHAuthorizationStatusDenied) {
                    // 用户刚才点击了【Dont't Allow】\【不允许】按钮
                } else if (justNowStatus == PHAuthorizationStatusAuthorized) {
                    // 用户刚才点击了【OK】\【好】按钮
                    [self saveImage];
                }
            }];
        }
            break;
        // This application is not authorized to access photo data.
        // 当前应用没有访问相册的权限
        // The user cannot change this application’s status, possibly due to active restrictions such as parental controls being in place.
        // 用户不能改变当前应用的授权状态，一般是因为一些动态限制（比如家长控制）
        case PHAuthorizationStatusRestricted:
            [SVProgressHUD showErrorWithStatus:@"由于系统原因,无法保存图片"];
            break;
        case PHAuthorizationStatusDenied: {
            // 提示用户：【设置】-【隐私】-【照片】-【百思不得姐8】
            break;
        }
            
        // User has authorized this application to access photos data.
        // 用户已经允许当前App访问相册（用户当初点击了【OK】\【好】按钮）
        case PHAuthorizationStatusAuthorized:{
            [self saveImage];
            break;
        }
    }
    
}
/*
 一.保存图片到【自定义相册】
 1.保存图片到【Camera Roll(相机胶卷)】
 1) UIImageWriteToSavedPhotosAlbum函数
 2) AssetsLibrary.framework : 从iOS9开始废弃
 3) Photos.framework : 从iOS8开始可以使用
 
 2.创建【自定义相册】
 1) AssetsLibrary.framework
 2) Photos.framework
 
 3.将刚才保存到【Camera Roll(相机胶卷)】中的图片, 添加到【自定义相册】
 1) AssetsLibrary.framework
 2) Photos.framework
 
 二.Photos.framework须知
 1.PHAsset : 一个PHAsset对象就代表一张图片\一段视频
 
 2.PHAssetCollection : 一个PHAssetCollection对象就代表一个相册
 
 3.PHAssetChangeRequest : 利用这个对象能添加、删除、修改PHAsset（图片\视频）
 
 4.PHAssetCollectionChangeRequest : 利用这个对象能添加、删除、修改PHAssetCollection（相册）
 
 5.对相册(PHAsset\PHAssetCollection)的任何变动代码（增删改），必须放在以下的其中一个block中
 [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
 // 对相册的任何变动代码，需要放这个block中
 
 } completionHandler:^(BOOL success, NSError * _Nullable error) {
 
 }];
 
 [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
 // 对相册的任何变动代码，需要放这个block中
 
 } error:nil];
 
 6.performChanges的block中不能嵌套performChanges
 
 三.对数据的常见操作：
 1.增删改查
 2.CreateReadUpdateDelete(CRUD)
 */

/*
 错误信息 : This method can only be called from inside of -[PHPhotoLibrary performChanges:completionHandler:] or -[PHPhotoLibrary performChangesAndWait:error:]
 这个方法必须放在 -[PHPhotoLibrary performChanges:completionHandler:] or -[PHPhotoLibrary performChangesAndWait:error:] 中调用
 */

#pragma mark - 懒加载
/**
 * 获得当前App相册
 */
- (PHAssetCollection *)assetCollection
{
    if (!_assetCollection) {
        // type : PHAssetCollectionTypeAlbum
        // subtype : PHAssetCollectionSubtypeAlbumRegular
        // 获得所有的自定义相册
        PHFetchResult<PHAssetCollection *> *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
        for (PHAssetCollection *ac in assetCollections) {
            if ([ac.localizedTitle isEqualToString:DZYAssetCollectionTitle]) {
                return _assetCollection = ac;
            }
        }
        
        // 创建新的相册
        __block NSString *assetCollectionId = nil;
        [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
            assetCollectionId = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:DZYAssetCollectionTitle].placeholderForCreatedAssetCollection.localIdentifier;
        } error:nil];
        
        // 获得刚才创建好的新相册
        return _assetCollection = [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[assetCollectionId] options:nil].firstObject;
    }
    return _assetCollection;
}

#pragma mark - 相册处理
/**
 *  返回添加到相机胶卷中的图片
 */
- (PHFetchResult *)assets
{
    __block NSString *assetId = nil;
    
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        // 添加图片到【Camera Roll(相机胶卷)】
        assetId = [PHAssetChangeRequest creationRequestForAssetFromImage:self.imageView.image].placeholderForCreatedAsset.localIdentifier;
    } error:nil];
    
    return [PHAsset fetchAssetsWithLocalIdentifiers:@[assetId] options:nil];
}

/**
 *  保存图片到自定义相册
 */
- (void)saveImage
{
    NSError *error = nil;
    
    // 相册
    PHAssetCollection *assetCollection = self.assetCollection;
    
    // 图片
    PHFetchResult *assets = self.assets;
    
    // 将刚才添加到【Camera Roll(相机胶卷)】中的图片, 顺便添加到【自定义相册】
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        PHAssetCollectionChangeRequest *request = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection];
        [request insertAssets:assets atIndexes:[NSIndexSet indexSetWithIndex:0]];
    } error:&error];
    
    // 错误判断
    if (error) {
        [SVProgressHUD showErrorWithStatus:@"保存失败！"];
    } else {
        [SVProgressHUD showSuccessWithStatus:@"保存成功！"];
    }
    
}

/**
 *  获取相机胶卷相册
 */
- (void)getCameraRoll
{
    // type : PHAssetCollectionTypeSmartAlbum
    // subtype : PHAssetCollectionSubtypeSmartAlbumUserLibrary
    PHAssetCollection *cameraRoll = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil].firstObject;
    
    DZYLog(@"%@", cameraRoll);
//        PHFetchResult<PHAssetCollection *> *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
//        for (PHAssetCollection *ac in assetCollections) {
//            DZYLog(@"%@", ac.localizedTitle);
//        }
}


//- (void)saveImage
//{
//    __block NSString *assetCollectionId = nil;
//    __block NSString *assetId = nil;
//
//    // 获得已经创建好的相册
//    __block PHAssetCollection *assetCollection = nil;
//    // type : PHAssetCollectionTypeAlbum
//    // subtype : PHAssetCollectionSubtypeAlbumRegular
//    PHFetchResult<PHAssetCollection *> *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
//    for (PHAssetCollection *ac in assetCollections) {
//        if ([ac.localizedTitle isEqualToString:XMGAssetCollectionTitle]) {
//            assetCollection = ac;
//            break;
//        }
//    }
//
//    // 基本变量
//    PHPhotoLibrary *library = [PHPhotoLibrary sharedPhotoLibrary];
//    NSError *error = nil;
//
//    // 执行修改
//    [library performChangesAndWait:^{
//        // 添加图片到【Camera Roll(相机胶卷)】
//        assetId = [PHAssetChangeRequest creationRequestForAssetFromImage:self.imageView.image].placeholderForCreatedAsset.localIdentifier;
//
//        // 创建【自定义相册】
//        if (assetCollection == nil) {
//            assetCollectionId = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:XMGAssetCollectionTitle].placeholderForCreatedAssetCollection.localIdentifier;
//        }
//    } error:&error];
//
//    if (assetCollection == nil) {
//        // 根据已创建相册的唯一标识去获得相册
//        assetCollection = [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[assetCollectionId] options:nil].firstObject;
//    }
//
//    // 执行修改
//    [library performChangesAndWait:^{
//        // 将刚才添加到【Camera Roll(相机胶卷)】中的图片, 顺便添加到【自定义相册】
//        PHAssetCollectionChangeRequest *request = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection];
//
//        PHFetchResult *assets = [PHAsset fetchAssetsWithLocalIdentifiers:@[assetCollectionId] options:nil];
//        [request addAssets:assets];
//    } error:&error];
//
//    // 错误判断
//    if (error) {
//        [SVProgressHUD showErrorWithStatus:@"保存失败！"];
//    } else {
//        [SVProgressHUD showSuccessWithStatus:@"保存成功！"];
//    }
//}
@end
