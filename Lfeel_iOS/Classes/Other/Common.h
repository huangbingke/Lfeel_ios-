//
//
//  Created by Seven Lv on 15/10/18.
//  Copyright (c) 2015年 Seven Lv. All rights reserved.
//  定义各种宏

//#define FuckCHY


//比例 以iPhone6 为基准
#define kRatio kScreenWidth/375
#define kFont(size)  [UIFont systemFontOfSize:size]


#define RGBColor(r, g, b)  [UIColor colorWithRed:(r) / 255.0 green:(g) / 255.0 blue:(b) / 255.0 alpha:1]
#define RGBColor2(r, g, b, a)  [UIColor colorWithRed:(r) / 255.0 green:(g) / 255.0 blue:(b) / 255.0 alpha:(a)]

#define HexColorInt32_t(rgbValue) \
[UIColor colorWithRed:((float)((0x##rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((0x##rgbValue & 0x00FF00) >> 8))/255.0 blue:((float)(0x##rgbValue & 0x0000FF))/255.0  alpha:1]

/// 十六进制颜色
#define HexColor(hexString) [UIColor hexColor:(hexString)]
///  主题色
#define ThemeColor HexColorInt32_t(01C665)
///  设置背景颜色
#define SetBackgroundGrayColor self.view.backgroundColor = HexColorInt32_t(F6F6F6); ;


#define BLOCK_SAFE_RUN(block, ...) block ? block(__VA_ARGS__) : nil;

/////////////////////////////////////////////////////////////////////////////////
#pragma mark - 适配屏幕
///  屏幕适配
#define _fitSize(num, base) _getScreenWidth() / base * (num)
//#define Fit750(num)  _fitSize(num, 750.0)
//#define Fit1125(num) _fitSize(num, 1125.0)
#define Fit375(num)  _fitSize(num, 375.0)
#define Fit414(num)  _fitSize(num, 414.0)
#define Fit1242(num)  _fitSize(num, 1242.0)

/////////////////////////////////////////////////////////////////////////////////
///  获取屏幕宽度
static inline CGFloat _getScreenWidth () {
    static CGFloat _screenWidth = 0;
    if (_screenWidth > 0) return _screenWidth;
    _screenWidth = CGRectGetWidth([UIScreen mainScreen].bounds);
    return _screenWidth;
}

///  获取屏幕高度
static inline CGFloat _getScreenHeight () {
    static CGFloat _screenHeight = 0;
    if (_screenHeight > 0) return _screenHeight;
    _screenHeight = CGRectGetHeight([UIScreen mainScreen].bounds);
    return _screenHeight;
}

#define WeakSelf __weak typeof(self) wself = self;
#define kScreenHeight     _getScreenHeight()
#define kScreenWidth      _getScreenWidth()
#define kHalfScreenHeight _getScreenHeight() * 0.5
#define kHalfScreenWidth  _getScreenWidth() * 0.5

/////////////////////////////////////////////////////////////////////////////////

#define user_is_login [User sharedUser].isLogin
#define USER [User sharedUser]
#define user_loginKey [User sharedUser].userInfo.loginKey




#define SVShowError(message) [SVProgressHUD showErrorWithStatus:(message)]
#define SVShowSuccess(message)[SVProgressHUD showSuccessWithStatus:message];
#define SLShowNetworkFail SVShowError(@"网络连接失败");

#define NavHeight CGRectGetMaxY(self.ts_navgationBar.frame)
#define SLPlaceHolder [UIImage imageNamed:@"结算中心、收藏"]
#define SLPlaceHolderFlat [UIImage imageNamed:@"place_flat"]


/// CGRect
#define Rect(x, y, w, h) CGRectMake((x), (y), (w), (h))
/// CGSize
#define Size(w, h) CGSizeMake((w), (h))
/// CGPoint
#define Point(x, y) CGPointMake((x), (y))

#define IfUserIsNotLogin \
if (!user_is_login) {    \
    BaseNavigationController * b = [[BaseNavigationController alloc] initWithRootViewController:[LFLoginViewController new]];\
    [self presentViewController:b animated:YES completion:nil]; return;\
}


/// 验证是文字是否输入
///
/// @param __Text    文字长度
/// @param __Message 错误提示
#define SLVerifyText(__TextLength, __Message)\
if (!__TextLength) {\
SVShowError(__Message);\
return;\
}

/// 验证手机正则
///
/// @param __Text    文字
/// @param __Message 错误提示
#define SLVerifyPhone(__Phone, __Message)\
if (![__Phone validateMobile]) {\
SVShowError(__Message);\
return;\
}

/// 验证邮箱正则
///
/// @param __Text    文字
/// @param __Message 错误提示
#define SLVerifyEmail(__Email, __Message)\
if (![__Email validateEmail]) {\
SVShowError(__Message);\
return;\
}

/// 验证密码正则
///
/// @param __Text    文字
/// @param __Message 错误提示
#define SLVerifyPassword(__Password, __Message)\
if (![__Password validatePassword]) {\
SVShowError(__Message);\
return;\
}
/// 验证条件
#define SLAssert(Condition, Message)\
if (!(Condition)) {\
SVShowError(Message);\
return;\
}
#define SLEndRefreshing(__ScrollView)\
if ([__ScrollView.mj_footer isRefreshing]) {\
[__ScrollView.mj_footer endRefreshing];\
}\
if ([__ScrollView.mj_header isRefreshing]) {\
[__ScrollView.mj_header endRefreshing];\
}

/////////////////////////// 懒加载 /////////////////////////////
#define SLLazyMutableArray(_array) \
return !(_array) ? (_array) = [NSMutableArray array] : (_array);

#define SLLazyArray(_array)    \
return !(_array) ? (_array) = [NSArray array] : (_array);

#define SLLazyMutableDictionary(_dictionary) \
return !(_dictionary) ? (_dictionary) = [NSMutableDictionary dictionary] : (_dictionary);

#define SLLazyDictionary(_dictionary) \
return !(_dictionary) ? (_dictionary) = [NSDictionary dictionary] : (_dictionary);



#define KLogin_Info   @"KLogin_Info"


#define kVipStatus    @"kVipStatus"





