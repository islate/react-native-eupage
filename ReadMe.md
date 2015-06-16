## react-native-eupage
---
A component for react-native ,Requires react-native >= 0.4.4

## Add to your project 
1. run `npm install react-native-eupage --save`
2. Open your project in XCode, right click on Libraries and click Add eupage project  Files to "Your Project Name"
3. copy Podfile to your project  then run 'pod install' to install framework it dependent on.

## usage

```
/*
*   a base page  model is formt with a url and type ,
*   the type current support html,image,video
*/
var EUPageExample = React.createClass({
getInitialState: function() 
{
return {
data:[{"url":"http://www.baidu.com", "type":"html"},
{"url":"http://www.163.com", "type":"html"},
{"url":"http://www.sina.com", "type":"html"}, 
{"url":"http://www.sohu.com", "type":"html"}]
}
},

render: function() 
{
console.log(this.state.data);
return (
<EUPageView style={styles.eupage} dataArray={this.state.data}>
</EUPageView>
);
} 
});
```

## Example
Try the included eupage example yourself

1. git clone https://github.com/2005wangliqun/react-native-eupage
2. cd react-native-eupage/Examples/EUPageExample
3. pod install
4. npm install
5. open EUPageExample.xcworkspace 
6. Cmd+R to start the React Packager, build and run the project in the simulator.



License
---
MIT Licensed
