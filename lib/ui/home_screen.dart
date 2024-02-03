import 'package:crypto_baazar/BLoC/crypto/crypto_bloc.dart';
import 'package:crypto_baazar/BLoC/crypto/crypto_event.dart';
import 'package:crypto_baazar/BLoC/crypto/crypto_state.dart';
import 'package:crypto_baazar/DI/service_locator.dart';
import 'package:crypto_baazar/constants/constants.dart';
import 'package:crypto_baazar/ui/crypto_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        var bloc = CryptoBloc(locator.get());
        bloc.add(CryptoDataRequestEvent());
        return bloc;
      },
      child: const MainBody(),
    );
  }
}

class MainBody extends StatelessWidget {
  const MainBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.blackColor,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BlocConsumer<CryptoBloc, CryptoState>(
                builder: (context, state) {
                  if (state is CryptoInitState ||
                      state is CryptoResponseState) {
                    return Column(
                      children: [
                        Image.asset("images/logo.png"),
                        const SizedBox(height: 20),
                        const SpinKitChasingDots(
                          color: Colors.white,
                          size: 50.0,
                        ),
                      ],
                    );
                  }
                  return const Text("خطا در دریافت اطلاعات");
                },
                listener: (context, state) {
                  if (state is CryptoResponseState) {
                    state.getCryptoList.fold(
                      (exceptionMessage) {
                        return const Text(
                          "خطا",
                          style: TextStyle(
                            fontFamily: "MR",
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        );
                      },
                      (cryptoList) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CryptoListScreen(cryptoList: cryptoList),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
