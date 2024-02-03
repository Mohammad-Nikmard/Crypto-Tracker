import 'package:crypto_baazar/data/datasource/crypto_datasource.dart';
import 'package:crypto_baazar/data/repository/crypto_repostory.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

var locator = GetIt.instance;

void initServiceLocator() {
  locator.registerSingleton<Dio>(Dio());

  locator.registerSingleton<ICryptoDatasource>(CryptoRemoteDatasource());

  locator.registerSingleton<ICryptoRepository>(CryptoRepostiroy());
}
