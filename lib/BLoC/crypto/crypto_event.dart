abstract class CryptoEvent {}

class CryptoDataRequestEvent extends CryptoEvent {}

class RefreshEvent extends CryptoEvent {}

class SearchEvent extends CryptoEvent {
  String keyWord;

  SearchEvent(this.keyWord);
}

class ClearSearchEvent extends CryptoEvent {}
