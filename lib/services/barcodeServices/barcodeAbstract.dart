import 'package:notz/services/barcodeServices/barcodeStub.dart'
if (dart.library.io) 'package:notz/services/barcodeServices/androidFunctions.dart'
if (dart.library.js) 'package:notz/services/barcodeServices/webFunctions.dart';

abstract class BarcodeAbs {
  static BarcodeAbs _instance;


  static BarcodeAbs get instance {
    _instance ??=  getBarcodeAbs();
    return _instance;
  }


  /*static BarcodeAbs get instance {
    if (_instance == null) {
      if (kIsWeb) {
        _instance = WebFunctions();
      } else {
        _instance = AndroidFunctions();
      }
    }
    return _instance;
  }*/

  void downloadBarcode(String data,{double w,double h});

}