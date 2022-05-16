class LanguageLocale {
  const LanguageLocale.en()
      : _firstRow = 'QWERTYUIOP',
        _secondRow = 'ASDFGHJKL',
        _thirdRow = 'ZXCVBNM',
        _lang = "en",
        _charCode = 0x7F,
        _alphabet = 'QWERTYUIOPASDFGHJKLZXCVBNM';

  final String _firstRow;
  String get firstRow => _firstRow;

  final String _secondRow;
  String get secondRow => _secondRow;

  final String _thirdRow;
  String get thirdRow => _thirdRow;

  final String _lang;
  String get lang => _lang;

  final int _charCode;
  int get charCode => _charCode;

  final String _alphabet;
  String get alphabet => _alphabet;

  int get secondRowIndex => _firstRow.length;

  int get thirdRowIndex => _firstRow.length + _secondRow.length;
}
