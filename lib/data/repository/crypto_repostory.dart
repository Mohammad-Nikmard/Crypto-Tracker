import 'package:crypto_baazar/DI/service_locator.dart';
import 'package:crypto_baazar/data/datasource/crypto_datasource.dart';
import 'package:crypto_baazar/data/model/crypto.dart';
import 'package:crypto_baazar/util/api_exception.dart';
import 'package:dartz/dartz.dart';

abstract class ICryptoRepository {
  Future<Either<String, List<Crypto>>> getCryptoList();
}

class CryptoRepostiroy extends ICryptoRepository {
  final ICryptoDatasource _datasource = locator.get();

  @override
  Future<Either<String, List<Crypto>>> getCryptoList() async {
    try {
      var response = await _datasource.getCryptoList();
      return right(response);
    } on APiException catch (ex) {
      return left(ex.message);
    }
  }
}
