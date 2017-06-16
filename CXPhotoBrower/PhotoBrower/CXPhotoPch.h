//
//  CXPhotoPch.h
//  CXPhotoBrower
//
//  Created by 陈晨昕 on 2017/6/13.
//  Copyright © 2017年 bugWacko. All rights reserved.
//

#ifndef CXPhotoPch_h
#define CXPhotoPch_h

//动画时间
#define PhotoBrowerAnimationTime   0.3f

// 左右边距
#define PhotoBrowerMargin          20.f

// 图片的最大放大倍数
#define PhotoBrowerImageMaxScale   2.f
// 图片的最小缩小倍数
#define PhotoBrowerImageMinScale   1.f

#ifndef ScreenWidth
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#endif

#ifndef ScreenHeight
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#endif


#endif /* CXPhotoPch_h */
