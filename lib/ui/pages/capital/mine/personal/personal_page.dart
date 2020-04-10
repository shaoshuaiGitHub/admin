import '../../../../../common/component_index.dart';
import '../../../../../ui/pages/page_index.dart';
import 'personal_head.dart';
import 'personal_middle.dart';
import 'personal_bottom.dart';


class CapitalPersonalPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<PersonalBloc>(
      bloc: PersonalBloc(),
      child: Scaffold(
        backgroundColor: Colours.background_color,
        appBar: AppBar(
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: Colours.capital_color,
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
            CapitalPersonalHead(),
            CapitalPersonalMiddle(),
            CapitalPersonalBottom(),
          ],
        ),
      ),
    );
  }
}
