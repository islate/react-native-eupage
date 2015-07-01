/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 */
'use strict';

var React = require('react-native');
var {
  AppRegistry,
  StyleSheet,
  Text,
  View,
} = React;

// 获取自定义组件
var EUPageView = require('react-native-eupage');

var EUPageExample = React.createClass({
  getInitialState: function() 
  {
    return {
      data:[{"url":"http://www.bing.com", "type":"html"},
          {"url":"http://www.yahoo.com", "type":"html"},
          {"url":"http://s.cn.bing.net/az/hprichbg/rb/WaterliliesYuanmingyuan_ZH-CN10533925188_1920x1080.jpg", "type":"image"},
          {"url":"http://7b1gcw.com1.z0.glb.clouddn.com/20150529120500960.mp4", "type":"video"}]

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

var styles = StyleSheet.create({
  eupage: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
  },
});

AppRegistry.registerComponent('EUPageExample', () => EUPageExample);
