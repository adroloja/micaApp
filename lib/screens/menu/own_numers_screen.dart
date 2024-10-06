import 'package:auto_size_text/auto_size_text.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mica/controller/lottery/GetLotteryNumberController.dart';
import 'package:mica/dto/LotteryNumberDTO.dart';
import 'package:intl/intl.dart';

class OwnNumersScreen extends StatefulWidget {
  const OwnNumersScreen({Key? key}) : super(key: key);

  @override
  State<OwnNumersScreen> createState() => _OwnNumersScreenState();
}

class _OwnNumersScreenState extends State<OwnNumersScreen> {
  List<LotteryNumberDTO> lotteryNumbers = [];
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    GetLotteryNumberController numberController = GetLotteryNumberController();
    Response response = await numberController.getOwnNumbers();
    lotteryNumbers = (response.data as List)
        .map((json) => LotteryNumberDTO.fromJson(json))
        .toList();

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   if (_scrollController.hasClients) {
    //     _scrollController.animateTo(
    //       _scrollController.position.maxScrollExtent,
    //       duration: const Duration(milliseconds: 3000),
    //       curve: Curves.easeInOut,
    //     );
    //   }
    // });

    setState(() {});
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 20),
          child: ListView.builder(
            itemCount: lotteryNumbers.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              String formattedDate = DateFormat('dd / MM / yyyy')
                  .format(lotteryNumbers[index].createdDate);

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset(
                          !lotteryNumbers[index].gift
                              ? 'assets/ticket.png'
                              : 'assets/ticket_regalo.png',
                          fit: BoxFit.cover,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              lotteryNumbers[index]
                                  .number
                                  .toString()
                                  .padLeft(7, '0'),
                              style: TextStyle(
                                fontSize: 70,
                                fontFamily: 'HelveticaCompressed',
                                color: lotteryNumbers[index].gift
                                    ? const Color.fromRGBO(101, 82, 137, 1.0)
                                    : const Color.fromRGBO(47, 87, 112, 1.0),
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                          bottom: 5,
                          left: 10,
                          right: 10,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: AutoSizeText(
                                  lotteryNumbers[index].usernameOwner,
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: lotteryNumbers[index].gift
                                        ? const Color.fromRGBO(
                                            101, 82, 137, 1.0)
                                        : const Color.fromRGBO(
                                            47, 87, 112, 1.0),
                                    fontFamily: 'HelveticaCompressed',
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 1),
                                  child: AutoSizeText(
                                    'Fecha compra: $formattedDate',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: lotteryNumbers[index].gift
                                          ? const Color.fromRGBO(
                                              101, 82, 137, 1.0)
                                          : const Color.fromRGBO(
                                              47, 87, 112, 1.0),
                                      fontFamily: 'HelveticaCompressed',
                                    ),
                                    maxLines: 1,
                                    textAlign: TextAlign.right,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (index < lotteryNumbers.length)
                    const Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
