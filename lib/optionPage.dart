import 'package:flutter/material.dart';
import 'main.dart';

class NextPage extends StatelessWidget{

  //値の受け渡し
  NextPage(this.name,this.countTime,this.nameColor);
  final name;
  final nameColor;
  List<int> countTime;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 31, 31, 31),
      appBar: AppBar(
        title: Text('説明ページ'),
        backgroundColor: Colors.black,
      ),
      body : SingleChildScrollView(
        child: Column(
          children: [
            for(int i = 0;i < countTime.length;i++)PikaButton(name[i],countTime[i],nameColor[i]),
          ]
        ),
      ),
    );
  }
}


class PikaButton extends StatelessWidget {
  //値の受け渡し
  PikaButton(this.name,this.countTime,this.nameColor);
  final name;
  final nameColor;
  int countTime;

  //分秒チェック
  String timeCheck(){
    if((countTime / 60).floor() <= 0){
      return countTime.toString() + "秒";
    }else{
      return (countTime / 60).floor().toString() + "分";
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Row(
      children :[
        Container(
          width: MediaQuery.of(context).size.width * 0.4,
          height: 70,
          alignment: Alignment.center,
          child:Text(
            name,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 25,
              fontFamily: 'SawarabiMincho',
              color: Color(nameColor),
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.6,
          alignment: Alignment.center,
          child:Text(
            timeCheck(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 25,
              fontFamily: 'SawarabiMincho',
              color: Colors.white,
            ),
          ),
        ),
      ]
    );
  }
}