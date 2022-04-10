class LanguageLocale {
  const LanguageLocale.en()
      : _firstRow = 'QWERTYUIOP',
        _secondRow = 'ASDFGHJKL',
        _thirdRow = 'ZXCVBNM',
        _charCode = 0x7F;

  final String _firstRow;
  String get firstRow => _firstRow;

  final String _secondRow;
  String get secondRow => _secondRow;

  final String _thirdRow;
  String get thirdRow => _thirdRow;

  final int _charCode;
  int get charCode => _charCode;
}
