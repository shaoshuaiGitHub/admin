import 'package:flutter/material.dart';
import 'package:youxinbao/res/res_index.dart';
import 'editpwd_page.dart';
import 'forgetpwd_page.dart';

class SetPasswordPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SetPasswordPage();
}

class _SetPasswordPage extends State<SetPasswordPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Color(0xFFFF9B1A),
        centerTitle: true,
        elevation: 0,
        title: Text(
          '密码设置',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeights.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xFFF2F2F2),
        ),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => EditPasswordPage(),
                  ),
                );
              },
              child: Container(
                height: 50,
                padding: const EdgeInsets.only(
                  left: 17,
                  right: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '修改密码',
                      style: TextStyle(
                        fontSize: 15,
                        color: Color(0xFF4C4C4C),
                      ),
                    ),
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/capital/arrow.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => ForgetPasswordPage(),
                  ),
                );
              },
              child: Container(
                height: 50,
                margin: const EdgeInsets.only(
                  top: 10,
                ),
                padding: const EdgeInsets.only(
                  left: 17,
                  right: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '忘记密码',
                      style: TextStyle(
                        fontSize: 15,
                        color: Color(0xFF4C4C4C),
                      ),
                    ),
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/capital/arrow.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
