//
//  XLButtonBarPagerTabStripViewController.m
//  XLPagerTabStrip ( https://github.com/xmartlabs/XLPagerTabStrip )
//
//  Copyright (c) 2014 Xmartlabs ( http://xmartlabs.com )
//
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "XLButtonBarViewCell.h"
#import "XLButtonBarPagerTabStripViewController.h"

@interface XLButtonBarPagerTabStripViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic) IBOutlet XLButtonBarView * buttonBarView;
@property (nonatomic) BOOL shouldUpdateButtonBarView;

@property (nonatomic) NSInteger selectedCell;
@property (nonatomic) BOOL shouldChangeActiveColors;
@property (strong, nonatomic) UIColor* activeColor;
@property (strong, nonatomic) UIColor* disabledColor;

@end

@implementation XLButtonBarPagerTabStripViewController
{
    XLButtonBarViewCell * _sizeCell;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.shouldUpdateButtonBarView = YES;
        self.shouldChangeActiveColors = NO;
        self.selectedCell = 0;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.shouldUpdateButtonBarView = YES;
        self.shouldChangeActiveColors = NO;
        self.selectedCell = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (!self.buttonBarView.superview){
        [self.view addSubview:self.buttonBarView];
    }
    if (!self.buttonBarView.delegate){
        self.buttonBarView.delegate = self;
    }
    if (!self.buttonBarView.dataSource){
        self.buttonBarView.dataSource = self;
    }
    self.buttonBarView.labelFont = [UIFont fontWithName:@"Helvetica-Bold" size:18.0f];
    self.buttonBarView.leftRightMargin = 8;
    [self.buttonBarView setScrollsToTop:NO];
    UICollectionViewFlowLayout * flowLayout = (id)self.buttonBarView.collectionViewLayout;
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [self.buttonBarView setShowsHorizontalScrollIndicator:NO];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UICollectionViewLayoutAttributes *attributes = [self.buttonBarView layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentIndex inSection:0]];
    CGRect cellRect = attributes.frame;
    [self.buttonBarView.selectedBar setFrame:CGRectMake(cellRect.origin.x, self.buttonBarView.frame.size.height - 5, cellRect.size.width, 5)];
}

-(void)reloadPagerTabStripView
{
    [super reloadPagerTabStripView];
    if ([self isViewLoaded])
    {
        [self.buttonBarView reloadData];
        [self.buttonBarView moveToIndex:self.currentIndex animated:NO swipeDirection:XLPagerTabStripDirectionNone];
    }
}

-(void) setEnabledTextColor:(UIColor *)enabledColor andDisabledColor:(UIColor *)disabledColor {
    self.activeColor = enabledColor;
    self.disabledColor = disabledColor;
    self.shouldChangeActiveColors = YES;
}

#pragma mark - Properties

-(XLButtonBarView *)buttonBarView
{
    if (_buttonBarView) return _buttonBarView;
    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [flowLayout setSectionInset:UIEdgeInsetsMake(0, 35, 0, 35)];
    _buttonBarView = [[XLButtonBarView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50.0f) collectionViewLayout:flowLayout];
    _buttonBarView.backgroundColor = [UIColor orangeColor];
    _buttonBarView.selectedBar.backgroundColor = [UIColor blackColor];
    _buttonBarView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    return _buttonBarView;
}

#pragma mark - XLPagerTabStripViewControllerDelegate

-(void)pagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController updateIndicatorToViewController:(UIViewController *)toViewController fromViewController:(UIViewController *)fromViewController
{
    if (self.shouldUpdateButtonBarView){
        NSUInteger newIndex = [self.pagerTabStripChildViewControllers indexOfObject:toViewController];
        XLPagerTabStripDirection direction = XLPagerTabStripDirectionLeft;
        if (newIndex < [self.pagerTabStripChildViewControllers indexOfObject:fromViewController]){
            direction = XLPagerTabStripDirectionRight;
        }
        
        if (self.shouldChangeActiveColors) {
            [self.buttonBarView deselectItemAtIndexPath:[NSIndexPath indexPathForRow:self.selectedCell inSection:0] animated:NO];
            ((XLButtonBarViewCell*)[self.buttonBarView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.selectedCell inSection:0]]).label.textColor = self.disabledColor;
            
            self.selectedCell += direction==XLPagerTabStripDirectionRight?-1:+1;
            
            ((XLButtonBarViewCell*)[self.buttonBarView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.selectedCell inSection:0]]).label.textColor = self.activeColor;
            [self.buttonBarView selectItemAtIndexPath:[NSIndexPath indexPathForRow:self.selectedCell inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        }
        
        [self.buttonBarView moveToIndex:newIndex animated:YES swipeDirection:direction];
        
        if ([self.delegate respondsToSelector:@selector(pagerTabStripViewController:didSelectIndex:)]) {
            [self.delegate pagerTabStripViewController:pagerTabStripViewController didSelectIndex:newIndex];
        }
    }
}

-(void)pagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController
          updateIndicatorFromIndex:(NSInteger)fromIndex
                           toIndex:(NSInteger)toIndex
            withProgressPercentage:(CGFloat)progressPercentage
{
    if (self.shouldUpdateButtonBarView){
        [self.buttonBarView moveFromIndex:fromIndex
                                  toIndex:toIndex
                   withProgressPercentage:progressPercentage];
        
        //Calculate which are the previous/next cells
        NSInteger previousCell = self.selectedCell;
        NSInteger nextCell;
        if (progressPercentage > 0.6 && self.selectedCell!=toIndex) {
            nextCell = toIndex;
        }
        else if (progressPercentage < 0.4 && self.selectedCell!=fromIndex) {
            nextCell = fromIndex;
        }
        else {
            nextCell = previousCell;
        }
        
        //if the cell hasn't changed, don't call the next functions
        if (nextCell == previousCell) {
            return;
        }
        
        //update the current cell
        self.selectedCell = nextCell;
        
        //If there is an active color, then set the cell as active
        if (self.shouldChangeActiveColors) {
            [self.buttonBarView deselectItemAtIndexPath:[NSIndexPath indexPathForRow:previousCell inSection:0] animated:NO];
            ((XLButtonBarViewCell*)[self.buttonBarView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:previousCell inSection:0]]).label.textColor = self.disabledColor;
            
            
            ((XLButtonBarViewCell*)[self.buttonBarView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:nextCell inSection:0]]).label.textColor = self.activeColor;
            [self.buttonBarView selectItemAtIndexPath:[NSIndexPath indexPathForRow:nextCell inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        }
        
        //Tell the delegate that there's a new active tab
        if ([self.delegate respondsToSelector:@selector(pagerTabStripViewController:didSelectIndex:)]) {
            
            [self.delegate pagerTabStripViewController:pagerTabStripViewController didSelectIndex:nextCell];
        }
    }
}



#pragma merk - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UILabel * label = [[UILabel alloc] init];
    [label setTranslatesAutoresizingMaskIntoConstraints:NO];
    label.font = self.buttonBarView.labelFont;
    UIViewController<XLPagerTabStripChildItem> * childController =   [self.pagerTabStripChildViewControllers objectAtIndex:indexPath.item];
    [label setText:[childController titleForPagerTabStripViewController:self]];
    CGSize labelSize = [label intrinsicContentSize];
    
    return CGSizeMake(labelSize.width + (self.buttonBarView.leftRightMargin * 2), collectionView.frame.size.height);
}

#pragma mark - UICollectionViewDelegate


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.buttonBarView moveToIndex:indexPath.item animated:YES swipeDirection:XLPagerTabStripDirectionNone];
    self.shouldUpdateButtonBarView = NO;
    self.selectedCell = indexPath.row;
    if (self.shouldChangeActiveColors) {
        ((XLButtonBarViewCell*)[collectionView cellForItemAtIndexPath:indexPath]).label.textColor = self.activeColor;
    }
    [self moveToViewControllerAtIndex:indexPath.item];
    
    //Tell the delegate a new cell has been selected
    if ([self.delegate respondsToSelector:@selector(pagerTabStripViewController:didSelectIndex:)]) {
        [self.delegate pagerTabStripViewController:self didSelectIndex:self.selectedCell];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.shouldChangeActiveColors) {
        ((XLButtonBarViewCell*)[collectionView cellForItemAtIndexPath:indexPath]).label.textColor = self.disabledColor;
    }
}


#pragma merk - UICollectionViewDataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.pagerTabStripChildViewControllers.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    if (!cell){
        cell = [[XLButtonBarViewCell alloc] initWithFrame:CGRectMake(0, 0, 50, self.buttonBarView.frame.size.height)];
    }
    NSAssert([cell isKindOfClass:[XLButtonBarViewCell class]], @"UICollectionViewCell should be or extend XLButtonBarViewCell");
    XLButtonBarViewCell * buttonBarCell = (XLButtonBarViewCell *)cell;
    UIViewController<XLPagerTabStripChildItem> * childController =   [self.pagerTabStripChildViewControllers objectAtIndex:indexPath.item];
    
    [buttonBarCell.label setText:[childController titleForPagerTabStripViewController:self]];
    
    if (self.shouldChangeActiveColors) {
        if (indexPath.row == self.selectedCell) {
            buttonBarCell.label.textColor = self.activeColor;
        }
        else {
            buttonBarCell.label.textColor = self.disabledColor;
        }
    }
    
    return buttonBarCell;
}


#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [super scrollViewDidEndScrollingAnimation:scrollView];
    if (scrollView == self.containerView){
        self.shouldUpdateButtonBarView = YES;
    }
}


@end
