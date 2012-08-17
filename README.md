URLManager
=============

URLManager是为iOS App开发的导航组件。使用URL Scheme管理整个App的ViewController。

安装/配置
==========

把URLManager目录拷贝到你的工程下。

在AppDelegate中初始化Navigator和配置信息

<pre>
    self.viewController = [[UMgrDemoViewController alloc] initWithURL:[NSURL URLWithString:@"um://demo"]];
    self.navigator = [[UMNavigator alloc] initWithRootViewController:self.viewController];
    self.navigator.navigationBar.tintColor = [UIColor lightGrayColor];

    [self.navigator setViewControllerName:@"UMgrDemoViewController" forURL:@"um://demo"];
    [self.navigator setViewControllerName:@"UMgrDemoBViewController" forURL:@"um://demob"];

    self.viewController.navigator = self.navigator;
    
    [self.window addSubview:self.navigator.view];
</pre>

使用
======
## URL管理ViewController

使用URLManager要求所有的ViewControlelr继承自UMViewController，如UMgrDemoViewController。UMViewController继承自UIViewController。
ViewController的初始化方法变为

<pre>
- (id)initWithURL:(NSURL *)aUrl;
- (id)initWithURL:(NSURL *)aUrl query:(NSDictionary *)query;
</pre>

详细配置可参考UMgrDemoViewController和UMgrDemoBViewController

在UMgrDemoViewController中可以通过一下代码调用新的ViewController

<pre>
    [self.navigator openURL:[[NSURL URLWithString:@"um://demob/path/aaa"]
                             addParams:[NSDictionary dictionaryWithObjectsAndKeys:
                                        @"va", @"ka",
                                        @"vb", @"kb",
                                        nil]]];

    [self.navigator openURL:[NSURL URLWithString:@"um://demob/?a=b"]
                  withQuery:[NSDictionary dictionaryWithObjectsAndKeys:
                             [NSArray arrayWithObjects:@"1", @"2", nil], @"q_key", nil]];
</pre>

在每一个ViewController中，通过实现

<pre>
- (BOOL)shouldOpenViewControllerWithURL:(NSURL *)aUrl;
- (void)openedFromViewControllerWithURL:(NSURL *)aUrl;
</pre>

可以捕捉到打开一个新的ViewController的动作。

## 通过滑动打开ViewController

继承自UMViewController的ViewController支持 Path 首页一样的左右滑动，左右的View也通过单独ViewController控制，并用URL管理。

在ViewController中实现 UMSlideDelegate 的方法即可实现
<pre>
#import "UMViewController.h"

@interface UMgrDemoViewController : UMViewController <UMSlideDelegate>

@end
</pre>

<pre>
- (NSURL *)leftViewControllerURL
{
    return [NSURL URLWithString:@"um://demob"];
}

- (NSURL *)rightViewControllerURL
{
    return [NSURL URLWithString:@"um://demoweb"];
}

- (CGFloat)rightViewWidth {
    return 200.0f;
}

- (void)willOpenLeftViewController
{
    NSLog(@"will open left view controller.");
}

</pre>





