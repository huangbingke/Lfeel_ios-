//
//  SLCollectionLogTool.h
//  RunningMan
//
//  Created by Seven Lv on 16/4/16.
//  Copyright © 2016年 Toocms. All rights reserved.
//

#import <UIKit/UIKit.h>
#if TARGET_OS_IPHONE

#define SLEdgeInsets    UIEdgeInsets
#define SLOffset        UIOffset
#define valueWithSLOffset   valueWithUIOffset
#define valueWithSLEdgeInsets   valueWithUIEdgeInsets

#elif TARGET_OS_MAC

#define SLEdgeInsets    NSEdgeInsets
#define SLOffset        NSOffset
#define valueWithSLOffset   valueWithNSOffset
#define valueWithSLEdgeInsets   valueWithNSEdgeInsets

#endif

#define SLBox(var) __sl_box(@encode(__typeof__((var))), (var))
#define SLBoxToString(var)  [SLBox(var) description]


//#ifdef DEBUG
//    #define TSLog(Anything)         SLLog2(@"%@", SLBox(Anything))
//    #define TSLog2(formate, ...)    printf("🎈%s 第 %d 行📍\n %s\n\n", __func__, __LINE__, [[NSString stringWithFormat:formate, ##__VA_ARGS__]UTF8String])
//    #define SLLog(Anything)         SLLog2(@"%@", SLBox(Anything))
//    #define SLLog2(formate, ...)    printf("🎈%s 第 %d 行📍\n %s\n\n", __func__, __LINE__, [[NSString stringWithFormat:formate, ##__VA_ARGS__]UTF8String])
//
//#else
//#define TSLog2(fmt, ...)
//#define TSLog(any)
//#define SLLog2(fmt, ...)
//#define SLLog(any)
//#endif

#define LogSwitchOpen

#ifdef LogSwitchOpen

#define SLLog(Anything) SLLog2(@"%@",SLBox(Anything))
#define TSLog(Anything) TSLog2(@"%@",SLBox(Anything))

#define TSLog2(formate, ...)   { \
NSString * str = [NSString stringWithFormat:@"🎈%s 第 %d 行📍\n %@\n\n", __func__, __LINE__, [NSString stringWithFormat:formate, ##__VA_ARGS__]];\
[[SLCollectionLogTool sharedTool].logs addObject:str]; \
printf("%s", str.UTF8String); }

#define SLLog2(formate, ...)   { \
NSString * str = [NSString stringWithFormat:@"🎈%s 第 %d 行📍\n %@\n\n", __func__, __LINE__, [NSString stringWithFormat:formate, ##__VA_ARGS__]];\
[[SLCollectionLogTool sharedTool].logs addObject:str]; \
printf("%s", str.UTF8String); }

#else

#define SLLog(Anything)
#define SLLog2(formate, ...)
#define TSLog(Anything)
#define TSLog2(formate, ...)

#endif


@interface SLCollectionLogTool : NSObject

@property (nonatomic, strong) NSMutableArray * logs;
+ (instancetype)sharedTool;

FOUNDATION_EXPORT void printPropertyName (NSDictionary * request);
FOUNDATION_EXPORT id __sl_box(const char * type, ...);

@end




@interface _SLLogView : UIView

@property (nonatomic,   weak) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * logs;

@end

