enum ItemSize {
  S(10),
  M(20),
  L(30),
  XL(40),
  XXL(50),
  XXXL(60);

  final int value;

  const ItemSize(this.value);
}

extension ItemSizeExtension on ItemSize {
  String get displayName {
    switch (this) {
      case ItemSize.S:
        return 'S';
      case ItemSize.M:
        return 'M';
      case ItemSize.L:
        return 'L';
      case ItemSize.XL:
        return 'XL';
      case ItemSize.XXL:
        return 'XXL';
      case ItemSize.XXXL:
        return 'XXXL';
      default:
        return '';
    }
  }
}
