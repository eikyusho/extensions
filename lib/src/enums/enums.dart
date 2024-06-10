/// Pixel density enum
enum PixelDensity {
  /// 1x
  x1,

  /// 2x
  x2,

  /// 3x
  x3;

  /// Get the size of the image based on the pixel density
  (int, int) size(int width, int height) {
    return switch (this) {
      PixelDensity.x3 => (width, height),
      PixelDensity.x2 => (width ~/ 1.5, height ~/ 1.5),
      PixelDensity.x1 => (width ~/ 3, height ~/ 3),
    };
  }
}

/// Discover list type enum
enum DiscoverListType {
  /// Source trending novels
  trending('trending'),

  /// Source most popular novels
  mostPopular('most-popular'),

  /// Source recently updated novels
  recentlyUpdated('recently-updated');

  const DiscoverListType(this.value);

  /// The value of the enum
  final String value;
}
