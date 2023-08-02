import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

import 'dart:math';

import 'optionPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.light(

      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>  with SingleTickerProviderStateMixin {
  
  //トップテキストロゴの値を決定するメソッド
  void openImg(){
    //ランダムに値を生成
    var random = Random().nextInt(8) + 1;
    //最終日なら中央寄せ、ほかは右端
    if(random == 8){
      topLogoPosition = Alignment.topCenter;
      topLogoMargin = 0;
    }else{
      topLogoPosition = Alignment.topRight;
      topLogoMargin = 40;
    }
    //テキストに与える
    topLogoText = random.toString();
  }
  var animationCheck = false;
  //キリンアイコンを回転させるメソッド
  void _animationChange() {
    _controller.forward();
  }
  void _animationStop() {
    _controller.stop();
  }

  //タイマーの切替
  int countSet(onID){
    int returnCount = 0;

    countTime.asMap().forEach((int index,int time){
      if(index == onID){
        returnCount = time;
      }
    });

    return returnCount;
  }

  //ループを起動
  Future<void> mainLoop() async{
    count = countSet(nameID);
    while(countif){
      //1秒ごとに起動
      await Future<void>.delayed(const Duration (seconds:1));

      if(count <= 0){//カウントが0以上の場合
        countif = false;
        timerOn();
      }else{//カウントが終わった場合
        setState(() {
          count--;
          if((count / 60).floor() <= 0){
            todaysBattleText = count.toString() + "秒";
          }else{
            todaysBattleText = (count / 60).floor().toString() + "分" + (count % 60).floor().toString()+ "秒";
          }
          todaysBattleTextEng = "during startup";
        });
      } 
    }
  }

  //タイマーが起動しているかどうか
  void todaysBattleTringer(){
    if(todaysBattle){
      todaysBattleText = "時間です";
      todaysBattleTextEng = 'Time\'s up';
    }else{
      todaysBattleText = 'お休み';
      todaysBattleTextEng = 'No participation today';
    }
  }

  //クロちゃん用
  void nameHeightChange(){
    if(nameID == 6){
      nameHeight = 150;
    }else{
      nameHeight = 70;
    }
  }

  //アラームを止める
  void timerOff(){
    animationCheck = false;
    _animationStop();
    setState(() {
      todaysBattle = false;
      todaysBattleTringer();
      nowTelephoneIcon = telephoneIcon[1];
      count = countSet(nameID);
    });

    //音声を止める
    audioPlayer.stop();
  }

  //アラームが鳴る
  void timerOn(){
    animationCheck = true;
    _animationChange();//アニメーション初期実行
    setState(() {
      todaysBattle = true;
      todaysBattleTringer();
      nowTelephoneIcon = telephoneIcon[0];
    });

    //音声を鳴らす
    audioPlayer.play(AssetSource("se/Ki-ringtone.mp3"));
    audioPlayer.setReleaseMode(ReleaseMode.loop);
  }

  //初回実行時に行われる内容
  @override 
  void initState() {
    super.initState();

    //トップテキストロゴの値を決定するメソッドを実行
    openImg();

    //アニメーションコントローラーを設定
    _controller = AnimationController(
      duration: Duration(seconds: 12), //アニメーションが実行される秒数
      vsync: this,//よくわかってない
    );

    //イベント実行時の操作
    _controller.addListener(() {
      setState(() {});//画面を更新
    });

    //回転の計算（詳しいことはよくわかってない）
    _rotateAnimation = Tween<double>(
      begin: 0,
      end: -2 * pi,
    ).animate(_controller);

    //アニメーションの状態確認
    _controller.addStatusListener((status) {
      //アニメーション終了時の処理
      if (status == AnimationStatus.completed) {
        _controller.reset();//アニメーションステータスのリセット
        _animationChange();//アニメーション再実行
      }
    });

    //本日の～の切り替え
    todaysBattleTringer();

    //お問い合わせボタンの最初の状態を設定
    nowTelephoneIcon = telephoneIcon[1];
    
    count = countSet(nameID);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }


   //トップテキストロゴ用の変数
  var topLogoText;
  var topLogoPosition;
  double topLogoMargin = 0;

  //キリンアイコン用のコライダー系
  late AnimationController _controller;
  late Animation<double> _rotateAnimation;

  
  //名前
  final name = ['愛城 華恋','神楽ひかり','天堂 真矢','星見 純那','露崎まひる','大場 なな','西條\nクロディーヌ','花柳 香子','石動 双葉'];
  //色
  final nameColor = [0xffff0000,0xff0000ff,0xffffffff,0xff80c0ff,0xff90ee90,0xffffff00,0xffff7f00,0xffffc0cb,0xff9b72b0];
  //名前の高さ
  double nameHeight = 70;
  //今保存されている番号
  int nameID = 0;//変数に変更する

  //タイマーの時間
  List<int> countTime = [10,30,60,120,180,300,600,1800,3600];
  //タイマーが起動しているか
  bool todaysBattle = false;
  String todaysBattleText = '',todaysBattleTextEng = '';
  //タイマーを実行する関数
  int count = 0;
  bool countif = false;

  //お問い合わせアイコンの画像を設定
  List<String>  telephoneIcon =  ['telephone-blue.png','telephone-red.png','telephone-green.png'];
  var nowTelephoneIcon;

  //音声再生用
  final audioPlayer = AudioPlayer();


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: [
            //トップロゴ
            Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: 80),
                  height: 100,
                  
                  child:Image.asset('assets/images/sozai/TopLogo.png'),
                ),
                //n日目
                
                Container(
                    margin: EdgeInsets.only(right: topLogoMargin),
                    padding: EdgeInsets.only(top: 10),
                    alignment: topLogoPosition,
                    child:Image.asset(
                      width: 100,
                      'assets/images/sozai/day/' + topLogoText + '.png',
                    ),
                ),
              ],
            ),
            //キリンアイコン
            GestureDetector(
              onTap: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NextPage(name,countTime,nameColor)),
                )
              },
              child: Container(
              margin: EdgeInsets.only(top: 50),
              child: AnimatedBuilder(
                animation: _controller,
                builder: (BuildContext context, child) => child!,
                child:Transform.rotate(
                  angle: _rotateAnimation.value,
                  alignment: Alignment.center,
                  child:Image.asset('assets/images/sozai/icon.png'),
                  
                ),
              ),
            ),
            ),
            
            Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  height: 150,
                  child:Text(
                    "お持ちなさい\nあなたの望んだその星を",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'SawarabiMincho',
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  child:Image.asset('assets/images/sozai/flower.png'),
                ),
                Container(
                  alignment: Alignment.center,
                  height: 80,
                  child:Text(
                    "And it shall be bestowed upon you,\nthe Star which you have loged for －",
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 16,
                      fontFamily: 'lora',
                      color: Colors.white,
                    ),
                  )
                ),
              ],
            ),
            //タワー
            Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 50),
                  height: 250,
                  alignment: Alignment.center,
                  child:Image.asset('assets/images/sozai/tower.png'),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 50),
                  alignment: Alignment.center,
                  child:Text(
                    "The Starlight Gatherer",
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 16,
                      fontFamily: 'lora',
                      color: Colors.white,
                    ),
                  )
                ),
              ],
            ),   
            //お知らせ
            Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  child:Text(
                    "お知らせ",
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontSize: 25,
                      fontFamily: 'HinaMincho',
                      color: Colors.white,
                    ),
                  ),
                ),
                //○○さん
                GestureDetector(
                  //メンバーリストを右に移動
                  onTap: () => {
                    setState(() {
                      if(nameID < 8){
                        nameID++;
                      }else{
                        nameID = 0;
                      }

                      nameHeightChange();
                      
                    })
                  },
                  //メンバーリストを左に移動
                  onDoubleTap: () {
                    setState(() {
                      if(nameID == 0){
                        nameID = 8;
                      }else{
                        nameID--;
                      }

                      nameHeightChange();
                    });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: nameHeight,
                    child:Text(
                      name[nameID],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 50,
                        fontFamily: 'HinaMincho',
                        color: Color(nameColor[nameID]),
                      ),
                    ),
                  ),
                ),
                
                Container(
                  margin: EdgeInsets.only(bottom: 50),
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(right: 50),
                  child:Text(
                    "さん",
                    style: TextStyle(
                      fontSize: 25,
                      fontFamily: 'HinaMincho',
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            //本日
            Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  child:Text(
                    "本日",
                    style: TextStyle(
                      fontSize: 35,
                      fontFamily: 'HinaMincho',
                      color: Colors.white,
                    ),
                  ),
                ),
                //○○さん
                Container(
                  alignment: Alignment.center,
                  height: 60,
                  child:Text(
                    todaysBattleText,
                    style: TextStyle(
                      fontSize: 50,
                      fontFamily: 'SawarabiMincho',
                      color: Colors.white,
                    ),
                  ),
                ),         
                Container(
                  margin: EdgeInsets.only(bottom: 50),
                  alignment: Alignment.center,
                  height: 40,
                  child:Text(
                    todaysBattleTextEng,
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 16,
                      fontFamily: 'lora',
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  height: 1,
                  width: 120,
                  color: Colors.white,
                ),
              ],
            ),
            //お問い合わせ
            Container(
              margin: EdgeInsets.only(top: 50),
              alignment: Alignment.center,
              height: 80,
              padding: EdgeInsets.only(bottom: 20),
              child:GestureDetector(              
                onTap: () {
                  
                  if(animationCheck){
                    timerOff();
                  }else if(!countif){
                    countif = true;
                    setState(() {
                      nowTelephoneIcon = telephoneIcon[2];
                    });
                    mainLoop();
                  }else{
                    countif = false;
                    
                    setState(() {
                      nowTelephoneIcon = telephoneIcon[1];
                    });
                  }

                },
                child:Image.asset('assets/images/sozai/' + nowTelephoneIcon),
              ),
            ),
             Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  child:Text(
                    "お問い合わせはこちら",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'SawarabiMincho',
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 100),
                  alignment: Alignment.center,
                  child:Text(
                    "Enquiry",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 16,
                      fontFamily: 'lora',
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

