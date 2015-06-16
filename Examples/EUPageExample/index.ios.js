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

var styles = StyleSheet.create({
  eupage: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
  },
});

AppRegistry.registerComponent('EUPageExample', () => EUPageExample);
