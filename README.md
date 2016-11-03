# copy - [演示](https://xuexb.github.io/copy/)

基于`jQuery`的`flash`复制插件, 特点:

* 基于`jQuery`的插件扩展
* 丰富的事件回调
* 支持自定义右键菜单
* 支持`debug`调试

## 使用

可`clone`项目代码到你理想的目录~

```html
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Demo</title>
</head>
<body>

    <div id="id">loading...</div>
    
    <!-- 引用jQuery -->
    <script src="https://cdn.bootcss.com/jquery/2.2.2/jquery.min.js"></script>
    
    <!-- 引用复制插件 -->
    <script src="/path/copy.js"></script>

    <script>
        // 设置默认swf路径, 方便后续直接使用
        $.fn.copy.defaults.path = '/path/copy.swf';

        $('#id').on('copy.success', function (event, data) {
            alert('复制成功: ' + data.text);
        }).copy('复制内容');
    </script>
</body>
</html>
```

## Api

```js
$('Selector').copy(str || option);
```

### 默认配置

```js
/**
 * 默认参数
 *
 * @type {Object}
 * @param {boolean} [defaults.debug=false] 调试模式
 * @param {string} defaults.path swf所在路径
 * @param {string|Function} defaults.text 复制文本
 * @param {Array} defaults.links 右键链接菜单
 * @param {string} defaults.links[].name 菜单名称
 * @param {string} defaults.links[].url 菜单链接
 * @param {boolean} defaults.links[].disabled 是否禁用
 * @param {boolean} defaults.links[].line 是否需要边框
 */
$.fn.copy.defaults = {
    debug: false,
    path: '',
    text: '',
    links: []
};
```

### 事件

当用户和元素交互时会触发目标元素的`copy.*`事件, 事件列表:

* copy.success - 复制成功
* copy.error - 复制出错
* copy.mouseover - 滑入
* copy.mouseout - 滑出
* copy.mousedown - 按下鼠标
* copy.mouseup - 松开鼠标

事件回调的参数如:

```js
$('Selector').on('copy.success', function (event, data) {
    data = {
        // 事件名
        event:"success",

        // 当前实例标识
        id: "copy_1478185663051_5",

        // 目标内容, 如果是success则是复制的内容, 如果是error则是详细错误信息
        text: "测试内容",
    }
});
```

## 例子

### 普通的复制

```js
$('#demo').on('copy.success', function (event, data) {
    alert('复制成功, 内容是: ' + data.text);
}).copy('我是复制内容');
```

基于天然的选择器优势, 支持多个绑定, 如:

```js
$('.class').copy('我是复制内容');
```

### 定义路径

```js
$('#demo').copy({
    path: '/path/copy.swf',
    text: '我是复制内容'
});
```

### 开启调试模式

开启后会把一些交互信息打印到控制台

```js
$('#demo').copy({
    debug: true,
    text: '我是复制内容'
});
```

### 复制动态的内容

常见于要复制的内容是根据某种条件而实时更新的, 比如文本框输入的值. 回调的`this`是当前被触发的`dom`对象.

```js
$('#demo').copy(function () {
    return $('#input').val();
});
```

或者:

```js
$('#demo').copy({
    text: function () {
        return xxoo ? 'ok' : 'no';
    }
});
```

### 定义右键菜单

支持自定义右键菜单, 并且没有任何默认版权. 对, 是的.

```js
$('#demo').copy({
    text: '复制内容',
    links: [
        {
            name: '我是链接, 可以点击',
            url: 'https://m.baidu.com'
        },
        {
            name: '我上面是不是有个边框?',
            line: true
        },
        {
            name: '被禁用的按钮',
            disabled: true
        }
    ]
});
```

你还可以直接重写了`$.fn.copy.defaults.links`方便直接全局使用.

### 销毁

可以主动的调用`$('#demo').copy('destroy');`来销毁这个实例

### 链式调用

基于伟大的`jQuery`肯定会支持链式的. 后面的会覆盖前面的, 但要注意的是绑定的`事件`最好在前面.

```js
$('#demo').on('copy.success', fn).copy('测试').copy('真的').copy({
    links: [
        {
            name: '被禁用的按钮',
            disabled: true
        }
    ]
});
```

## Develop

使用`flashdevelop`开发, 依赖于`flex SDK 4.6+`编译, 目录说明:

```
# as源码
src/

# github pages依赖样式
lib/

# 插件js
index.js

# 插件swf, 由src/代码编译生成
copy.swf

# github pages演示主页
index.html
```

## todo

- [ ] 发现as的`Sprite`宽高有问题, 居然跟设置的不一样, 应该是缩放比例问题, 目前先写了1000的死值, 接下来找解决方法
- [ ] 开发思路
- [ ] 自动化测试

## Changelog

### 1.0.0

发布版本, 目前只是初始后插入到页面元素, 后续考虑滑入才显示`swf`元素+`resize`, 这样对定位的元素支持较好.