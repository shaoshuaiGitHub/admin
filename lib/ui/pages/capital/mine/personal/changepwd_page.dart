// import 'package:flutter/cupertino.dart';
// import '../../../../../common/component_index.dart';

// class ChangePwdPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colours.background_color,
//       appBar: AppBar(
//         centerTitle: true,
//         elevation: 0.0,
//         backgroundColor: Color(0xffff9b1a),
//         actions: <Widget>[
//           Container(
//             width: 70,
//             child: FlatButton(
//               padding: EdgeInsets.all(0),
//               child: Text('完成', style: TextStyles.text16WhiteMediumLabel),
//               onPressed: () {
//                 showDialog(
//                   context: context,
//                   builder: (context) => AlertDialog(
//                         content: Text(('两次密码输入不一致')),
//                         actions: <Widget>[
//                           FlatButton(
//                             child: Text("确定"),
//                             onPressed: () {
//                               Navigator.of(context).pop();
//                             },
//                           ),
//                         ],
//                       ),
//                 );
//               },
//             ),
//           ),
//         ],
//         title: Text(
//           '修改密码',
//           style: TextStyle(
//             fontSize: 18,
//           ),
//         ),
//       ),
//       body: GestureDetector(
//         onTap: () {
//           FocusScope.of(context).requestFocus(FocusNode());
//         },
//         child: Column(
//           children: <Widget>[
//             Container(
//               child: Column(
//                 children: <Widget>[
//                   Container(
//                     height: 49,
//                     width: MediaQuery.of(context).size.width,
//                     margin: EdgeInsets.only(
//                       top: 10,
//                     ),
//                     padding: EdgeInsets.only(
//                       left: 16,
//                       right: 16,
//                     ),
//                     color: Colours.white_color,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//                       children: <Widget>[
//                         Text(
//                           '原密码',
//                           style: TextStyles.text16MediumLabel,
//                         ),
//                         Container(
//                           width: 200,
//                           child: TextField(
//                             obscureText: true,
//                             decoration: InputDecoration(
//                               contentPadding: EdgeInsets.all(0),
//                               border: InputBorder.none,
//                               hintText: '请输入旧密码',
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Container(
//                     width: 343,
//                     height: 1,
//                     color: Colours.background_color2,
//                   ),
//                 ],
//               ),
//             ),
//             Container(
//               child: Column(
//                 children: <Widget>[
//                   Container(
//                     height: 49,
//                     width: MediaQuery.of(context).size.width,
//                     padding: EdgeInsets.only(
//                       left: 16,
//                       right: 16,
//                     ),
//                     color: Colours.white_color,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//                       children: <Widget>[
//                         Text(
//                           '新密码',
//                           style: TextStyles.text16MediumLabel,
//                         ),
//                         Container(
//                           width: 200,
//                           child: TextField(
//                             obscureText: true,
//                             decoration: InputDecoration(
//                               contentPadding: EdgeInsets.all(0),
//                               border: InputBorder.none,
//                               hintText: '请输入新密码',
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Container(
//                     width: 343,
//                     height: 1,
//                     color: Colours.background_color2,
//                   ),
//                 ],
//               ),
//             ),
//             Container(
//               child: Column(
//                 children: <Widget>[
//                   Container(
//                     height: 50,
//                     width: MediaQuery.of(context).size.width,
//                     padding: EdgeInsets.only(
//                       left: 16,
//                       right: 16,
//                     ),
//                     color: Colours.white_color,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//                       children: <Widget>[
//                         Text(
//                           '确认密码',
//                           style: TextStyles.text16MediumLabel,
//                         ),
//                         Container(
//                           width: 206,
//                           child: TextField(
//                             obscureText: true,
//                             decoration: InputDecoration(
//                               contentPadding: EdgeInsets.all(0),
//                               border: InputBorder.none,
//                               hintText: '请再次输入新密码',
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Container(
//               height: 45,
//               alignment: Alignment.center,
//               child: Text('密码必须至少8个字符，而且同时包含字母和数字。',
//                   style: TextStyles.text14MediumLabel),
//             ),
//             Expanded(
//               child:Container(color: Colours.background_color,),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
