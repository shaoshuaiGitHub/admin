import '../../../../common/component_index.dart';
import 'mine_index.dart';

class MyInformationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<PersonalBloc>(
      bloc: PersonalBloc(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colours.background_color,
        appBar: AppBar(
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: Colours.orange_72,
          title: Text(
            '个人信息',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
        ),
        body: ListView(
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            MyInformationHead(),
            MyInformationMiddle(),
            MyInformationBottom(),
          ],
        ),
      ),
      );
  }
}
