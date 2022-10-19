import 'package:rxdart/rxdart.dart';
import 'package:vtv/models/m3u_categorized.dart';

class MainData {
  MainData._pr();
  static final MainData _instance = MainData._pr();
  static MainData get instance => _instance;

  final BehaviorSubject<List<M3UCategorized>> _subject =
      BehaviorSubject<List<M3UCategorized>>();
  Stream<List<M3UCategorized>> get stream => _subject.stream;
  List<M3UCategorized> get value => _subject.value;

  void populateAll(List<M3UCategorized> data) {
    _subject.add(data);
  }
}
