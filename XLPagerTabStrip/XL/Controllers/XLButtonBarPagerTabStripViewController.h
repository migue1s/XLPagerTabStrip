//
//  XLButtonBarPagerTabStripViewController.h
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

#import "XLButtonBarView.h"
#import "XLPagerTabStripViewController.h"

@interface XLButtonBarPagerTabStripViewController : XLPagerTabStripViewController

@property (readonly, nonatomic) XLButtonBarView * buttonBarView;

/**
 *
 * @brief Changes the color for the text inside the bar. All unselected texts will get the disabledColor while the currently selected one will have the enabledColor
 * @param enabledColor The color for the selected tab
 * @param disabledColor The color for the unselected tabs
 *
 **/
-(void) setEnabledTextColor:(UIColor*) enabledColor andDisabledColor:(UIColor*) disabledColor;

@end
