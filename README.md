# ZRObjcKit

ZRObjcKit是我Objctive-C学习过程中部分练习Demo和封装组件，包括以下内容：

## ZRTracking

ZRTracking基于OC Runtime，实现iOS无埋点技术方案，埋点数据暂存于sqlite db，主要包括以下功能：

* App启动、运行记录
* 页面访问及存留时长记录
* 页面访问轨迹记录
* 事件点击记录
* 函数调用记录

## UI组件

### FileBrowser

FileBrowser支持浏览App沙盒、Bundle文件目录结构，查看文件信息，文件分享导出。
![](https://raw.githubusercontent.com/jiaxw32/ZRObjcKit/master/ZRObjcKit/Resource/file_browser.png)

### 拆线图绘制

类似微信运动步数统计，自定义绘制的拆线图，支持查看周数据、月数据，数据随机生成。
![](https://raw.githubusercontent.com/jiaxw32/ZRObjcKit/master/ZRObjcKit/Resource/polyline_graphic.png)

### 日历组件

一个自定义的日历选择组件。
![](https://raw.githubusercontent.com/jiaxw32/ZRObjcKit/master/ZRObjcKit/Resource/custom%20calendar.png)

### ZRGridView

类似Excel表格，用于展示多行多列的表格数据的组件。
![](https://raw.githubusercontent.com/jiaxw32/ZRGridView/master/ZRGridView/ZRGridView/gridview.gif)

### ZRPickerView

基于UIPickerView封装的数据选择组件，支持一维、二维数据。

![](https://raw.githubusercontent.com/jiaxw32/ZRObjcKit/master/ZRObjcKit/Resource/pickerview.png)

### TextViewAutoSizeDemo

一个TextView高度自适应及键盘事件处理Demo。

## 其他

### 类的构造

### 消息转发测试Demo

### KVO原理探究Demo

### 对象销毁监测Demo
