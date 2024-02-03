import 'package:crypto_baazar/BLoC/crypto/crypto_event.dart';
import 'package:crypto_baazar/BLoC/crypto/crypto_state.dart';
import 'package:crypto_baazar/data/model/crypto.dart';
import 'package:crypto_baazar/data/repository/crypto_repostory.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CryptoBloc extends Bloc<CryptoEvent, CryptoState> {
  final ICryptoRepository _cryptoRepository;
  CryptoBloc(this._cryptoRepository) : super(CryptoInitState()) {
    on<CryptoDataRequestEvent>(
      (event, emit) async {
        var getCryptoList = await _cryptoRepository.getCryptoList();
        emit(CryptoResponseState(getCryptoList));
      },
    );

    on<RefreshEvent>(
      (event, emit) async {
        emit(CryptoLoadingState());
        var getCryptoList = await _cryptoRepository.getCryptoList();
        emit(CryptoResponseState(getCryptoList));
      },
    );

    on<SearchEvent>(
      (event, emit) async {
        emit(CryptoLoadingState());
        var cryptoList = await _cryptoRepository.getCryptoList();
        List<Crypto> list = [];
        cryptoList.fold(
          (l) {},
          (r) {
            list = r
                .where(
                  (element) => element.id!.toLowerCase().contains(
                        event.keyWord.toLowerCase(),
                      ),
                )
                .toList();
          },
        );
        emit(CryptoSearchState(list));
      },
    );

    on<ClearSearchEvent>(
      (event, emit) async {
        emit(CryptoLoadingState());
        var cryptoList = await _cryptoRepository.getCryptoList();
        List<Crypto> list = [];
        cryptoList.fold(
          (l) {},
          (r) {
            list = r;
          },
        );
        emit(CryptoSearchState(list));
      },
    );
  }
}
