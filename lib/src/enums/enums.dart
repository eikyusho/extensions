enum PixelDensity {
  x1,
  x2,
  x3;

  (int, int) size(int width, int height) {
    return switch (this) {
      PixelDensity.x3 => (width, height),
      PixelDensity.x2 => (width ~/ 1.5, height ~/ 1.5),
      PixelDensity.x1 => (width ~/ 3, height ~/ 3),
    };
  }
}
