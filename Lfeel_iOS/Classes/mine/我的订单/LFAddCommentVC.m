//
//  LFAddCommentVC.m
//  Lfeel_iOS
//
//  Created by Seven Lv on 17/3/27.
//  Copyright © 2017年 Seven. All rights reserved.
//

#import "LFAddCommentVC.h"
#import "TZImagePickerController.h"

static NSString * const _URLKey = @"_URLKey";
@implementation UIImage (_URL)
- (void)setUrlString:(NSString *)urlString {
    objc_setAssociatedObject(self, &_URLKey, urlString, OBJC_ASSOCIATION_COPY);
}
- (NSString *)urlString {
    return objc_getAssociatedObject(self, &_URLKey);
}

@end


@interface LFAddCommentVC ()
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *placeholder;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (nonatomic,   weak) UIView * picView;
@property (nonatomic, strong) NSMutableArray<UIImage *> * pics;
@property (nonatomic,   weak) UIButton * addBtn;
@property (nonatomic, strong) NSMutableArray<UIImageView *> * imageViews;
@end

@implementation LFAddCommentVC

#pragma mark - Life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.contentView rm_fitAllConstraint];
    [self setupSubViews];
    
    [self setupNavigationBar];
    
    
}

///  初始化子控件
- (void)setupSubViews {
    
    [self.icon sd_setImageWithURL:[NSURL URLWithString:self.goods.goodsImgUrl] placeholderImage:SLPlaceHolder];
    
    UIView * picView = [UIView viewWithBgColor:nil frame:Rect(Fit(15), Fit(110), kScreenWidth - Fit(30), Fit(65))];
    [self.contentView addSubview:picView];
    self.picView = picView;
    
    UIButton * addBtn = [UIButton buttonWithTitle:nil titleColor:nil backgroundColor:nil font:0 image:@"添加评论" frame:Rect(0, 0, picView.height, picView.height)];
    [picView addSubview:addBtn];
    self.addBtn = addBtn;
    [addBtn addTarget:self action:@selector(_didClickAddBtn)];
    
    UILabel * label = [UILabel labelWithText:@"您可以发表5张图片" font:Fit(12) textColor:self.placeholder.textColor frame:Rect(addBtn.maxX + Fit(20), 0, 0, 0)];
    [label sizeToFit];
    label.centerY = addBtn.centerY;
    [picView addSubview:label];
    label.tag = 10;
    
    for (int i = 0; i < 5; i++) {
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:addBtn.bounds];
        [self.imageViews addObject:imageView];
        [picView addSubview:imageView];
        imageView.userInteractionEnabled = YES;
        imageView.tag = i;
        imageView.hidden = YES;
        UITapGestureRecognizer * tap = [UITapGestureRecognizer new];
        [tap.rac_gestureSignal subscribeNext:^(UITapGestureRecognizer * x) {
            if (x.view.hidden) return ;
            [self.pics removeObjectAtIndex:x.view.tag];
            [self _layoutImageViews];
        }];
        [imageView addGestureRecognizer:tap];
        
    }
    
    SLDevider * devider = [[SLDevider alloc] initWithFrame:Rect(picView.x, picView.maxY + 20, kScreenWidth - picView.x, 1)];
    [self.contentView addSubview:devider];
    
    @weakify(self);
    [self.textView.rac_textSignal subscribeNext:^(id x) {
        @strongify(self);
        self.placeholder.hidden = [x length] > 0;
    }];
}

///  设置自定义导航条
- (void)setupNavigationBar {
    @weakify(self);
    NSString * title = @"发表评价";
    self.ts_navgationBar = [TSNavigationBar navWithTitle:title backAction:^{
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma mark - Actions
/// 点击发送
- (IBAction)_didSend:(id)sender {
    SLAssert(self.textView.hasText, @"说点什么吧");
    [self _requestAddComment];
}
/// 添加图片
- (void)_didClickAddBtn {
    
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:5 - self.pics.count delegate:nil];
    
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets) {
        UIView * label = [self.contentView viewWithTag:10];
        label.hidden = YES;
        
        [self _uploadImages:photos];
    }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
    
}

/// 布局图片
- (void)_layoutImageViews {
    for (int i = 0; i < self.imageViews.count; i++) {
        UIImageView * imageView = self.imageViews[i];
        imageView.hidden = YES;
    }
    
    CGFloat margin = (self.picView.width - self.picView.height * 5) / 4;
    for (int i = 0; i < self.pics.count + 1; i++) {
        CGFloat x = i * (margin + self.picView.height);
        if (i == self.pics.count) {
            if (self.pics.count == 5) {
                self.addBtn.hidden = YES;
            } else {
                self.addBtn.x = x;
                self.addBtn.hidden = NO;
            }
            return;
        }
        UIImageView * imageView = self.imageViews[i];
        imageView.x = x;
        imageView.image = self.pics[i];
        imageView.hidden = NO;
    }
}

#pragma mark - Networking
/// 上传图片
- (void)_uploadImages:(NSArray *)images {
    dispatch_group_t group = dispatch_group_create();
    
    for (int i = 0; i < images.count; i++) {
        UIImage * image = images[i];
        NSString * url = @"image/upload";
        dispatch_group_enter(group);
        [TSNetworking POSTImageWithURL:url paramsModel:nil image:image imageParam:@"111" completeBlock:^(NSDictionary *request) {
            SLLog(request);
            if ([request[@"result"] integerValue] != 200) {
                SVShowError(request[@"msg"]);
                return ;
            }
            image.urlString = request[@"imgUrl"];
            dispatch_group_leave(group);
        } failBlock:^(NSError *error) {
            SLShowNetworkFail;
            SLLog(error);
            dispatch_group_leave(group);
        }];
    }
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        BOOL y = YES;
        for (UIImage * image in images) {
            if (!image.urlString) {
                y = NO;
                break;
            }
        }
        if (!y) return ;
        [self.pics addObjectsFromArray:images];
        [self _layoutImageViews];
    });
}

///  新增评论
- (void)_requestAddComment {
    /*
     Name	Identifier	Type	Remark
     评论图片，多张以；隔开	commentImgUrls	string	@mock=http://qiniu1.com;http://qiniu2.com
     loginKey	string	@mock=00fa95958febf957bf48ce2aebde71db
     评论内容	content	string	@mock=评论内容
     商品ID	goodsId	string	@mock=1
     */
    
    NSString * url = @"manage/publishComment.htm?";
    LFParameter * parameter = [LFParameter new];
    [parameter appendBaseParam];
    parameter.content = self.textView.text;
    parameter.orderId = self.order_id;
    parameter.goodsId = self.goods.goodsId;
    if (self.pics.count) {
        NSMutableString * IDs = [NSMutableString new];
        for (UIImage * image in self.pics) {
            if (image.urlString.length) {
                [IDs appendFormat:@"%@;", image.urlString];
            }
        }
        if (IDs.length) {
            [IDs deleteCharactersInRange:NSMakeRange(IDs.length - 1, 1)];
        }
        parameter.commentImgUrls = IDs;
    }
    
    [TSNetworking POSTWithURL:url paramsModel:parameter needProgressHUD:YES completeBlock:^(NSDictionary *request) {
        SLLog(request);
        if ([request[@"result"] integerValue] != 200) {
            SVShowError(request[@"msg"]);
            return ;
        }
        SVShowSuccess(request[@"msg"]);
        [User sharedUser].needRefreshOrder = YES;
        BLOCK_SAFE_RUN(self.vBlock);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
        
    } failBlock:^(NSError *error) {
        SLShowNetworkFail;
        SLLog(error);
    }];
    
}
#pragma mark - Private


#pragma mark - Public


#pragma mark - Getter\Setter
- (NSMutableArray *)pics { SLLazyMutableArray(_pics) }
- (NSMutableArray *)imageViews { SLLazyMutableArray(_imageViews)}
@end
