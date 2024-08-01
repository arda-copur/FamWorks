enum ImageItems { image1, image2, image3, image4 }

extension ImageItemsExtension on ImageItems {
  String _imagePath() {
    switch (this) {
      case ImageItems.image1:
        return "image1";

      case ImageItems.image2:
        return "image2";

      case ImageItems.image3:
        return "image3";

      case ImageItems.image4:
        return "image4";
    }
  }

  String get imagePath => "assets/${_imagePath()}.jpg";
}