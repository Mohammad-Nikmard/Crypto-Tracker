import 'package:crypto_baazar/BLoC/crypto/crypto_bloc.dart';
import 'package:crypto_baazar/BLoC/crypto/crypto_event.dart';
import 'package:crypto_baazar/BLoC/crypto/crypto_state.dart';
import 'package:crypto_baazar/DI/service_locator.dart';
import 'package:crypto_baazar/constants/constants.dart';
import 'package:crypto_baazar/data/model/crypto.dart';
import 'package:crypto_baazar/util/extension/double_extention.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CryptoBloc(locator.get()),
      child: const MainBody(),
    );
  }
}

class MainBody extends StatelessWidget {
  const MainBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: MyColors.greenColor),
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
              return const CustomScrollView(
                slivers: [
                  SearchBar(),
                ],
              );
            }
            if (state is CryptoLoadingState) {
              return const CustomScrollView(
                slivers: [
                  SearchBar(),
                  SliverToBoxAdapter(
                    child: SpinKitChasingDots(
                      color: Colors.white,
                      size: 20.0,
                    ),
                  ),
                ],
              );
            }
            if (state is CryptoSearchState) {
              return CustomScrollView(
                slivers: [
                  const SearchBar(),
                  CryptoList(cryptoList: state.list),
                ],
              );
            }
            return const Center(
              child: Text(
                "خطا",
                style: TextStyle(
                  fontFamily: "MR",
                  fontSize: 25,
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

class SearchBar extends StatelessWidget {
  const SearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: TextField(
            onChanged: (keyWord) {
              if (keyWord.isNotEmpty) {
                context.read<CryptoBloc>().add(SearchEvent(keyWord));
              } else {
                context.read<CryptoBloc>().add(ClearSearchEvent());
              }
            },
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            decoration: const InputDecoration(
              filled: true,
              contentPadding: EdgeInsets.only(top: 30, right: 10),
              fillColor: MyColors.greenColor,
              hintText: "رمزارز مورد نظر خودت را سرچ کن...",
              hintStyle: TextStyle(
                fontFamily: "MR",
                fontSize: 18,
                color: Colors.white,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
                borderSide: BorderSide(style: BorderStyle.none, width: 0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
                borderSide: BorderSide(style: BorderStyle.none, width: 0),
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
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: ListView.builder(
          itemCount: cryptoList.length,
          itemBuilder: (context, index) {
            return ListTile(
              trailing: SizedBox(
                width: 122,
                height: 45,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          cryptoList[index].price!.toStringAsFixed(2),
                          style: const TextStyle(
                            fontSize: 16,
                            color: MyColors.greyColor,
                          ),
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
          },
        ),
      ),
    );
  }
}
