## react-native-eupage
---
A react-native component to show html/image/video fullscreen pages.

## Screenshots
---
This is a screencapture of a demo. 
![Screenshots](http://7fvh6h.com1.z0.glb.clouddn.com/blogdebug3.gif)

## Add to your project 
1. run `npm install react-native-eupage --save`
2. Open your project in XCode, right click on Libraries and click Add eupage project  Files to "Your Project Name"
3. copy Podfile to your project then run 'pod install' to install needed pods.

## Usage

```
/*
*   A base page model is format with a "url" and "type".
*   Current supported types are "html", "image" and "video".
*/
var EUPageExample = React.createClass({
getInitialState: function() 
{
  return {
    data:[{"url":"http://www.bing.com", "type":"html"},
          {"url":"http://s.cn.bing.net/az/hprichbg/rb/WaterliliesYuanmingyuan_ZH-CN10533925188_1920x1080.jpg", "type":"image"},
          {"url":"http://www.yahoo.com", "type":"html"}, 
          {"url":"http://debug.bbwc.cn/uploadfile/video/iweekly_android/2015/05/29/20150529120500960/20150529120500960.mp4", "type":"video"}]
  }
},

render: function() 
{
    return (
      <EUPageView style={styles.eupage} dataArray={this.state.data}>
      </EUPageView>
    );
  } 
});
```

## Example

1. git clone https://github.com/mmslate/react-native-eupage
2. cd react-native-eupage/Examples/EUPageExample
3. pod install
4. npm install
5. npm start
6. Open EUPageExample.xcworkspace, build and run the project in the simulator.


## License
---
MIT Licensed
