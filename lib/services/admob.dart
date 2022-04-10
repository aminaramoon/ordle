import 'package:wordle/states/keyboard_provider.dart';

class AdService {
  static final AdService _singleton = AdService._internal();

  factory AdService() {
    return _singleton;
  }

  AdService._internal();

  int _numberOfErrors = 0;

  Future<void> showAd(SubmissionResult status) async {
    if (status == SubmissionResult.correct) {
      _numberOfErrors = 0;
    } else if (status == SubmissionResult.done) {
      _numberOfErrors += 1;
    }
    if (_numberOfErrors == 1) {
      _showShortAd();
    } else if (_numberOfErrors > 1) {
      _showInteractiveAd();
    }
  }

  Future<void> _showInteractiveAd() async {}

  Future<void> _showShortAd() async {}
}
