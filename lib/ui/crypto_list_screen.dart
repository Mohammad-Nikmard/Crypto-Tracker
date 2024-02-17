import 'package:crypto_baazar/BLoC/crypto/crypto_bloc.dart';
import 'package:crypto_baazar/BLoC/crypto/crypto_event.dart';
import 'package:crypto_baazar/BLoC/crypto/crypto_state.dart';
import 'package:crypto_baazar/DI/service_locator.dart';
import 'package:crypto_baazar/constants/constants.dart';
import 'package:crypto_baazar/data/model/crypto.dart';
import 'package:crypto_baazar/ui/search_screen.dart';
import 'package:crypto_baazar/util/extension/double_extention.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CryptoListScreen extends StatelessWidget {
  const CryptoListScreen({super.key, required this.cryptoList});
  final List<Crypto> cryptoList;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CryptoBloc(locator.get()),
      child: MainBody(cryptoList: cryptoList),
    );
  }
}

class MainBody extends StatelessWidget {
  const MainBody({super.key, required this.cryptoList});
  final List<Crypto> cryptoList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 65,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "کریپتو بازار",
          style: TextStyle(
            fontFamily: "MR",
            fontSize: 25,
            color: MyColors.greenColor,
          ),
        ),
      ),
      backgroundColor: MyColors.blackColor,
      body: SafeArea(
        child: BlocBuilder<CryptoBloc, CryptoState>(
          builder: (context, state) {
            if (state is CryptoInitState) {
              return CustomScrollView(
                slivers: [
                  const SearchBox(),
                  CryptoList(cryptoList: cryptoList),
                ],
              );
            }
            if (state is CryptoLoadingState) {
              return const Center(
                child: SpinKitChasingDots(
                  color: Colors.white,
                  size: 50.0,
                ),
              );
            }
            if (state is CryptoResponseState) {
              return state.getCryptoList.fold(
                (l) {
                  return Center(
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<CryptoBloc>().add(RefreshEvent());
                      },
                      child: const Text("تلاش مجدد"),
                    ),
                  );
                },
                (newList) {
                  return CustomScrollView(
                    slivers: [
                      const SearchBox(),
                      CryptoList(cryptoList: newList),
                    ],
                  );
                },
              );
            }
            return const Center(
              child: Text(
                "خطا در دریافت اطلاعات",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class SearchBox extends StatelessWidget {
  const SearchBox({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SearchScreen(),
                ),
              );
            },
            child: Container(
              height: 55,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
                color: MyColors.greenColor,
              ),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "رمزارز مورد نظر خود را سرچ کنید...",
                      style: TextStyle(
                        fontFamily: "MR",
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CryptoList extends StatelessWidget {
  const CryptoList({super.key, required this.cryptoList});
  final List<Crypto> cryptoList;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: RefreshIndicator(
        onRefresh: () async {
          context.read<CryptoBloc>().add(CryptoDataRequestEvent());
        },
        backgroundColor: MyColors.blackColor,
        color: MyColors.greenColor,
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: ListView.builder(
              itemCount: cryptoList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  trailing: SizedBox(
                    width: 135,
                    height: 45,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Text(
                                  cryptoList[index].price!.toStringAsFixed(2),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: MyColors.greyColor,
                                  ),
                                ),
                                const SizedBox(width: 3),
                                const Text(
                                  "\$",
                                  style: TextStyle(
                                    color: MyColors.greenColor,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "${(cryptoList[index].changePercent24Hr!.convertToColor() == MyColors.greenColor) ? "+" : ""}${cryptoList[index].changePercent24Hr!.toStringAsFixed(2)}",
                              style: TextStyle(
                                color: cryptoList[index]
                                    .changePercent24Hr!
                                    .convertToColor(),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 25),
                        cryptoList[index].changePercent24Hr!.convertToIcon(),
                      ],
                    ),
                  ),
                  subtitle: Text(
                    cryptoList[index].symbol!,
                    style: const TextStyle(
                      color: MyColors.greenColor,
                      fontSize: 16,
                    ),
                  ),
                  title: Text(
                    cryptoList[index].id!,
                    style: const TextStyle(
                      color: MyColors.greyColor,
                      fontSize: 18,
                    ),
                  ),
                  leading: Text(
                    cryptoList[index].rank!,
                    style: const TextStyle(
                      color: MyColors.greyColor,
                    ),
                  ),
                );
              }),
        ),
      ),
    );
  }
}
