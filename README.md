# ZRObjcKit

ZRObjcKit包括一些自定义组件和探索Objective-C原理的Demo。

## ZRTracking

ZRTracking基于OC Runtime，实现iOS App无埋点技术方案，数据存储于sqlite db，功能包括：

* App启动、运行记录
* 页面访问及存留时长记录
* 页面访问轨迹记录
* 事件点击记录
* 函数调用记录

## UI组件

### FileBrowser

FileBrowser支持浏览App沙盒、Bundle文件目录结构，查看文件信息，分享导出文件。

<img src="https://raw.githubusercontent.com/jiaxw32/ZRObjcKit/master/ZRObjcKit/Resource/fileBrowser.png" width="320">

### 拆线图绘制

自定义绘制拆线图，类似微信运动步数统计，支持查看周数据、月数据，数据随机生成。

<img src="https://raw.githubusercontent.com/jiaxw32/ZRObjcKit/master/ZRObjcKit/Resource/polylineGraphic.png" width="320">

### 日历组件

一个自定义的日历组件，支持最大、最小日期设置、日期选择、高亮显示指定日期。

<img src="https://raw.githubusercontent.com/jiaxw32/ZRObjcKit/master/ZRObjcKit/Resource/customCalendar.png" width="320">

### ZRGridView

类似Excel表格，用于展示多行多列的表格数据。       

<img src="https://raw.githubusercontent.com/jiaxw32/ZRGridView/master/ZRGridView/ZRGridView/gridview.gif" width="320">

### ZRPickerView

基于UIPickerView封装的数据选择框，支持一维、二维数据。

<img src="https://raw.githubusercontent.com/jiaxw32/ZRObjcKit/master/ZRObjcKit/Resource/pickerview.png" width="320">

### TextViewAutoSizeDemo

一个TextView高度自适应及键盘事件处理Demo。

## Objective-C探索

* 类的构造

* 消息转发测试Demo

* KVO原理探究Demo

* 对象销毁监测Demo

    ```Objctive-C
    ZRPerson *personC = [[ZRPerson alloc] init];
    [personC observeDeallocWithBlock:^{
        //invoke when the object dealloc
        NSLog(@"Person C dealloc");
    }];
    ```

## LICENSE

项目使用 MIT LICENSE，详情见 LICENSE 文件。
