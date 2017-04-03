# LazyScrollView

[中文说明](http://pingguohe.net/2016/01/31/lazyscroll.html)

[中文Demo说明](http://pingguohe.net/2017/03/02/lazyScrollView-demo.html)

LazyScrollView is an iOS ScrollView , to resolve the problem of reusability of views. 

We reply an another way to control reuse in a ScrollView, it depends on give a special reuse identifier to every view controlled in LazyScrollView.

Comparing to UITableView , LazyScrollView can easily create different layout , instead of the single row flow layout. 

Comparing to UICollectionView , LazyScrollView can create views without Grid layout , and provides a easier way to create different kinds of layous in a ScrollView .

The system requirement is iOS 5+

# Usage

    #import "TMMuiLazyScrollView.h"
    
 Then , create LazyScrollView  
 
```objectivec
TMMuiLazyScrollView *scrollview = [[TMMuiLazyScrollView alloc]init];
scrollview.frame = self.view.bounds;
```

next implement`TMMuiLazyScrollViewDataSource`
 
```objectivec
@protocol TMMuiLazyScrollViewDataSource <NSObject>
@required
//number of item om scrollView
- (NSUInteger)numberOfItemInScrollView:(TMMuiLazyScrollView *)scrollView;
//return view model (TMMuiRectModel) by index 
- (TMMuiRectModel *)scrollView:(TMMuiLazyScrollView *)scrollView rectModelAtIndex:(NSUInteger)index;
//return view by the unique string that identify a model(muiID) . You should render the item view here. And the view is probably . Item view display. You should always try to reuse views by setting each view's reuseIdentifier and querying for available reusable views with dequeueReusableItemWithIdentifier:
- (UIView *)scrollView:(TMMuiLazyScrollView *)scrollView itemByMuiID:(NSString *)muiID;
@end
```

next , set datasource delegate of LazyScrollView

```objectivec
scrollview.dataSource = self;
```

finally , do reload

```objectivec
[scrollview reloadData];
```

 To view detailed usage , please clone the repo and open project to see demo. 

# License

LazyScroll is releasd under MIT license .

````
The MIT License

Copyright (c) 2017 Alibaba

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

````

