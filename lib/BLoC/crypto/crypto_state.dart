import 'package:crypto_baazar/data/model/crypto.dart';
import 'package:dartz/dartz.dart';

abstract class CryptoState {}

class CryptoInitState extends CryptoState {}

class CryptoLoadingState extends CryptoState {}

class CryptoResponseState extends CryptoState {
  Either<String, List<Crypto>> getCryptoList;

  CryptoResponseState(this.getCryptoList);
}

class CryptoSearchState extends CryptoState {
  List<Crypto> list;

  CryptoSearchState(this.list);
}
