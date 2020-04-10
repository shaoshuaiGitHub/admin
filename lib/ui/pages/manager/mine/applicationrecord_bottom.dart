import '../../../../common/component_index.dart';
import '../../../../ui/pages/page_index.dart';

class ApplicationRecordBottom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20, bottom: 20),
      child: FlatButton(
        child: Image.asset(
          'assets/images/manager/addcapital_icon.png',
          width: 50,
          height: 50,
        ),
        // child: Container(
        //     margin: EdgeInsets.only(bottom: 20,top: 20),
        //     child: Center(
        //       child: Container(
        //         width: 50.0,
        //         height: 50.0,
        //         decoration: BoxDecoration(
        //           border:
        //               Border.all(color: Colours.orange_72, width: 0.5), // 边色与边宽度
        //           color: Colors.transparent, // 底色
        //           borderRadius: BorderRadius.circular((90.0)), // 圆角度
        //           // borderRadius: new BorderRadius.vertical(top: Radius.elliptical(20, 50)), // 也可控件一边圆角大小
        //         ),
        //         child: Center(
        //           child: Text(
        //             '＋',
        //             style: TextStyle(
        //               fontSize: 30,
        //               color: Colours.orange_72,
        //             ),
        //           ),
        //         ),
        //       ),
        //     )),
        onPressed: () {
          final ApplicationBloc applocationBloc =
              BlocProvider.of<ApplicationBloc>(context);
          applocationBloc.backType = 0;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => ApplicationPage(),
            ),
          );
        },
      ),
    );
  }
}
