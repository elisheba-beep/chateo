  import 'package:flutter/widgets.dart';

extension SizeBoxes on num{
  Widget get heightBox{
    return SizedBox(height: toDouble(),);
  }

  Widget get widthBox{
    return SizedBox(width: toDouble(),);
  }
}