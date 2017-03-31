//
//  MPTableSDWebImageViewController.m
//  MobileProject
//
//  Created by wujunyang on 2017/2/9.
//  Copyright © 2017年 wujunyang. All rights reserved.
//

#import "MPTableSDWebImageViewController.h"

@interface MPTableSDWebImageViewController ()<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic,copy)NSArray *imageUrlList;
@property (nonatomic,strong) UITableView         *myTableView;
@property (strong, nonatomic) NSValue *targetRect; //定义一个当前屏幕显示的范围
@end

@implementation MPTableSDWebImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    [self.view addSubview:self.myTableView];
    [self.myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 重写BaseViewController设置内容

//设置导航栏背景色
-(UIColor*)set_colorBackground
{
    return [UIColor whiteColor];
}

////设置标题
-(NSMutableAttributedString*)setTitle
{
    return [self changeTitle:@"列表只加载显示时Cell的SDWebImage图"];
}

//设置左边按键
-(UIButton*)set_leftButton
{
    UIButton *left_button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 22, 22)];
    [left_button setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [left_button setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateHighlighted];
    return left_button;
}

//设置左边事件
-(void)left_button_event:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark UITableViewDataSource, UITableViewDelegate相关内容

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.imageUrlList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    cell.accessoryType    = UITableViewCellAccessoryDisclosureIndicator;
    [self setupCell:cell withIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

#pragma mark 自定义代码

- (void)setupCell:(UITableViewCell *)cell withIndexPath:(NSIndexPath *)indexPath
{
    NSURL *targetURL=[NSURL URLWithString:self.imageUrlList[indexPath.row]];
    if (![[cell.imageView sd_imageURL] isEqual:targetURL]) {
        cell.imageView.alpha=0.0;
        
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        BOOL shouldLoadImage = YES;
        CGRect cellFrame = [self.myTableView rectForRowAtIndexPath:indexPath];
        //判断显示的当前屏幕范围内
        if (self.targetRect &&!CGRectIntersectsRect([self.targetRect CGRectValue], cellFrame)) {
            //如果不在范围内 接着判断是否有缓存
            SDImageCache *cache = [manager imageCache];
            NSString *key = [manager cacheKeyForURL:targetURL];
            //如果没有缓存 则设置shouldLoadImage = NO 因为没有缓存说明以前也没有下载过，就不去进行下面的加载操作
            if (![cache imageFromMemoryCacheForKey:key]) {
                shouldLoadImage = NO;
            }
        }
        
        //执行这个代码 要进入当前的屏幕范围，或者以前已经在出现过且缓存过
        if (shouldLoadImage) {
            NSLog(@"我这时加载的图片是%ld",indexPath.row);
            
            [cell.imageView sd_setImageWithURL:targetURL placeholderImage:[UIImage imageNamed:@"public_empty_loading"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if (!error && [imageURL isEqual:targetURL]) {
                    [UIView animateWithDuration:0.25 animations:^{
                        cell.imageView.alpha = 1.0;
                    }];
                }
            }];
        }
    }
}

- (void)loadImageForVisibleCells
{
    NSArray *cells = [self.myTableView visibleCells];
    for (UITableViewCell *cell in cells) {
        NSIndexPath *indexPath = [self.myTableView indexPathForCell:cell];
        [self setupCell:cell withIndexPath:indexPath];
    }
}

#pragma mark ScrollDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.targetRect = nil;
    [self loadImageForVisibleCells];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    CGRect targetRect = CGRectMake(targetContentOffset->x, targetContentOffset->y, scrollView.frame.size.width, scrollView.frame.size.height);
    self.targetRect = [NSValue valueWithCGRect:targetRect];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.targetRect = nil;
    [self loadImageForVisibleCells];
}


-(NSMutableAttributedString *)changeTitle:(NSString *)curTitle
{
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:curTitle];
    [title addAttribute:NSForegroundColorAttributeName value:HEXCOLOR(0x333333) range:NSMakeRange(0, title.length)];
    [title addAttribute:NSFontAttributeName value:CHINESE_SYSTEM(18) range:NSMakeRange(0, title.length)];
    return title;
}


-(NSArray *)imageUrlList
{
    if (!_imageUrlList) {
        _imageUrlList=@[@"http://www.dabaoku.com/sucaidatu/dongwu/chongwujingling/953838.JPG",@"http://img4.duitang.com/uploads/item/201507/30/20150730163204_A24MX.thumb.700_0.jpeg",@"http://www.wallcoo.com/animal/Dogs_Summer_and_Winter/wallpapers/1920x1200/DogsB10_Lucy.jpg",@"http://mvimg2.meitudata.com/56074c97d79468889.jpg",@"http://www.dabaoku.com/sucaidatu/dongwu/chongwujingling/804838.JPG",@"http://img3.duitang.com/uploads/item/201601/28/20160128230209_iSYUx.jpeg",@"http://photo.iyaxin.com/attachement/jpg/site2/20120402/001966720af110e381132c.jpg",@"http://a.hiphotos.baidu.com/zhidao/pic/item/f9dcd100baa1cd11aa2ca018bf12c8fcc3ce2d74.jpg",@"http://img.pconline.com.cn/images/upload/upc/tx/photoblog/1112/28/c11/10084076_10084076_1325087736046.jpg",@"http://g.hiphotos.baidu.com/zhidao/pic/item/738b4710b912c8fcc51b78bbf4039245d78821df.jpg",@"http://www.wallcoo.com/animal/Pet-Miniature-Schnauzer/wallpapers/1280x1024/Miniature-Schnauzer-puppy-photo-83448_wallcoo.com.jpg",@"http://img0.pclady.com.cn/pclady/1702/04/1664938_36613700_148.jpg",@"http://t-1.tuzhan.com/64098acae587/c-2/l/2013/09/14/04/c4481aa3564c449f8793a13716419be1.jpg",@"http://mvimg1.meitudata.com/5517f3b94c1ba116.jpg",@"http://pic24.nipic.com/20121023/5692504_110554234175_2.jpg",@"http://t1.niutuku.com/960/21/21-262743.jpg",@"http://cdn.duitang.com/uploads/item/201508/14/20150814074658_xRSe5.thumb.700_0.jpeg",@"http://www.wallcoo.com/animal/Dogs_Summer_and_Winter/wallpapers/1920x1200/DogsB10_Lucy.jpg",@"http://mvimg2.meitudata.com/56074c97d79468889.jpg",@"http://www.dabaoku.com/sucaidatu/dongwu/chongwujingling/804838.JPG",@"http://img3.duitang.com/uploads/item/201601/28/20160128230209_iSYUx.jpeg",@"http://photo.iyaxin.com/attachement/jpg/site2/20120402/001966720af110e381132c.jpg",@"http://a.hiphotos.baidu.com/zhidao/pic/item/f9dcd100baa1cd11aa2ca018bf12c8fcc3ce2d74.jpg",@"http://img.pconline.com.cn/images/upload/upc/tx/photoblog/1112/28/c11/10084076_10084076_1325087736046.jpg",@"http://g.hiphotos.baidu.com/zhidao/pic/item/738b4710b912c8fcc51b78bbf4039245d78821df.jpg",@"http://www.wallcoo.com/animal/Pet-Miniature-Schnauzer/wallpapers/1280x1024/Miniature-Schnauzer-puppy-photo-83448_wallcoo.com.jpg",@"http://img0.pclady.com.cn/pclady/1702/04/1664938_36613700_148.jpg",@"http://t-1.tuzhan.com/64098acae587/c-2/l/2013/09/14/04/c4481aa3564c449f8793a13716419be1.jpg",@"http://mvimg1.meitudata.com/5517f3b94c1ba116.jpg",@"http://pic24.nipic.com/20121023/5692504_110554234175_2.jpg",@"http://t1.niutuku.com/960/21/21-262743.jpg",@"http://cdn.duitang.com/uploads/item/201508/14/20150814074658_xRSe5.thumb.700_0.jpeg"];
    }
    
    return _imageUrlList;
}

-(UITableView *)myTableView
{
    //初始化表格
    if (!_myTableView) {
        _myTableView                                = [[UITableView alloc] initWithFrame:CGRectMake(0,0.5, Main_Screen_Width, Main_Screen_Height) style:UITableViewStylePlain];
        _myTableView.showsVerticalScrollIndicator   = NO;
        _myTableView.showsHorizontalScrollIndicator = NO;
        _myTableView.dataSource                     = self;
        _myTableView.delegate                       = self;
        _myTableView.backgroundColor=[UIColor redColor];
        [_myTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    }
    
    return _myTableView;
}

@end
