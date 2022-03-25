import 'package:flutter/cupertino.dart';

class TwoColumns extends StatelessWidget {
  late final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    List<Widget> leftSide = [];
    List<Widget> rightSide = [];

    for (var i = 0; i<children.length; i++) {
      if (i % 2==0) {
        leftSide.add(children[i]);
      } else {
        rightSide.add(children[i]);
      }
    }

    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: leftSide,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: rightSide,
          ),
        ],
      ),
    );
  }

  TwoColumns({children}) {
    this.children = children;
  }
}