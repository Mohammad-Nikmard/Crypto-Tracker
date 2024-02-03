import 'package:crypto_baazar/DI/service_locator.dart';
import 'package:crypto_baazar/data/model/crypto.dart';
import 'package:crypto_baazar/util/api_exception.dart';
import 'package:dio/dio.dart';

abstract class ICryptoDatasource {
  Future<List<Crypto>> getCryptoList();
}

class CryptoRemoteDatasource extends ICryptoDatasource {
  final Dio _dio = locator.get();
  @override
  Future<List<Crypto>> getCryptoList() async {
    try {
      var response = await _dio.get("https://api.coincap.io/v2/assets");
      return response.data["data"]
          .map<Crypto>((jsonMapObject) => Crypto.withJson(jsonMapObject))
          .toList();
    } on DioException catch (ex) {
      throw APiException(ex.response?.data["message"], ex.response?.statusCode);
    } catch (ex) {
      throw APiException("$ex", 0);
    }
  }
}
