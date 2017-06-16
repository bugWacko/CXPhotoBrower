---

# CXPhotoBrower

CXPhotoBrower是一个图片浏览工具，类似微博、微信浏览方式。

在这里面有几个值得关注的点：

* 添加方式
* 滚动展示控件
* 缩放计算
* 出入动画

###  添加方式
这个开源代码和MJPhotoBrower不同的在于，这个不是使用ViewControl进行设计。而是直接使用View进行设计，并将其添加到Window上，代码如下：

```
	UIWindow *window = [[UIApplication sharedApplication] keyWindow];
	[self setFrame:window.bounds];
	[window addSubview:self];

```

值得注意的是，这种方式的灵活度更高。对于喜欢丰富的动画或者重构的童鞋们来说，这种方式无疑是比较让人开心的。

### 滚动展示控件

之前有接触过，也有用过，很多APP都是使用UIScrollView作为图片展示的滚动控件。这种方式是可行的，但是会增加代码量和计算量。而CXPhotoBrower使用的是继承于UIScrollView的UICollectionView，使用UICollectionView的好处在于，它已经帮你解决了模块复利用、同时设置大小、间距等属性更加简单，有兴趣的童鞋可以试试。关键代码如下：

```
	UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
	[layout setItemSize:bounds.size];
	[layout setMinimumLineSpacing:0];
	[layout setMinimumInteritemSpacing:0];
	
	//这是关键的设置环节，就是设置横向滑动属性。如果是使用xib或者storeboard，大家也可以在可视化界面中进行设置，方便简单
	[layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];

	UICollectionView * collectionView  = [[UICollectionView alloc] initWithFrame:bounds collectionViewLayout:layout];

```

### 缩放计算

直接上代码：
	
```
	//获取 UIScrollView 高 和 图片 高 的 比率
   CGFloat maxScale = frame.size.height / imageFrame.size.height;
   //获取 宽度的比率
   CGFloat widthRadit = frame.size.width / imageFrame.size.width;
        
   //取出 最大的 比率
   maxScale = widthRadit > maxScale ? widthRadit : maxScale;
   //如果 最大比率 >= PhotoBrowerImageMaxScale 倍 , 则取 最大比率 ,否则去 PhotoBrowerImageMaxScale 倍
   maxScale = maxScale > PhotoBrowerImageMaxScale?maxScale:PhotoBrowerImageMaxScale;
        
   //设置 UIScrollView的 最大 和 最小 缩放比率
   _scrollView.minimumZoomScale = PhotoBrowerImageMinScale;
   _scrollView.maximumZoomScale = maxScale;
```
 
 ```
 	if(_scrollView.zoomScale <= 1){
   // 获取到 手势 在 自身上的 位置
	// UIScrollView的偏移量 x(为负) + 手势的 x 需要放大的图片的X点
	CGFloat x = [doubleTap locationInView:self].x + _scrollView.contentOffset.x;
        
	// UIScrollView的偏移量 y(为负) + 手势的 y 需要放大的图片的Y点
	CGFloat y = [doubleTap locationInView:self].y + _scrollView.contentOffset.y;
	[_scrollView zoomToRect:(CGRect){{x,y},CGSizeZero} animated:YES];
	
    } else {
        // 设置 缩放的大小  还原
        [_scrollView setZoomScale:1.f animated:YES];
    }
 ```
 
### 出入动画
 
 出入动画主要用到了简单的慢动画效果，关键点是计算图片位置。
 
 ```
 	//获取图片所在位置
 	CGRect rect = [sourceView convertRect:[sourceView bounds] toView:self];
 ```
 
 ```
 	//使用苹果自带API，实现慢动作动画效果
 	+ (void)animateWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay options:(UIViewAnimationOptions)options animations:(void (^)(void))animations completion:(void (^ __nullable)(BOOL finished))completion NS_AVAILABLE_IOS(4_0);
 ```
 
### PS:
如果无法加载图片，请检查App Transport Security Settings 设置

---
 