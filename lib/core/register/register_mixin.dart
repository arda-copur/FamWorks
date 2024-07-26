import 'package:flutter/material.dart';

mixin RegisterPasswordMixin on StatefulWidget { //statefullwidget yerine direk ilgili textfieldsı kullanalım
  final String nullPassword = "Lütfen doldurunuz";
  final String wrongPassword = "Geçersiz email";
  final String weakPassword = "Zayıf parola";
}

mixin RegisterInputTypes on StatefulWidget {
  // textfieldların açıldığı an gelecek klavye tiplerini bunda tutmayı deneyelim
}

//ve ayrıca bir de  controller.lengthleri, textfieldlarda olması gereken veya olmaması gereken karakterlerin kontrollerini tutup tutamayacağımıza bakalım


//EĞER BU YAPI OLMAYACAKSA HER TEXTFIELDWIDGETI İÇİN BİR MIXIN OLUŞTURUP KARIŞIK TÜM YAPILARI İÇİNE YAZ.