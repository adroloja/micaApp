import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:mica/controller/lottery_date/get_lottery_date.dart';
import 'package:mica/controller/lottery_winner/get_winner_controller.dart';
import 'package:mica/dto/LotteryWinerDTO.dart';
import 'package:mica/utils/constants.dart';

class CountdownTimer extends StatefulWidget {
  const CountdownTimer({Key? key}) : super(key: key);

  @override
  _CountdownTimerState createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  Timer? _timer;
  Duration _duration = const Duration();
  LotteryWinnerDTO? lotteryWinnerDTO;
  bool isWinner = false;
  String currentDate = '';

  @override
  void initState() {
    super.initState();
    getWinnerLottery();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<DateTime> getDate() async {
    try {
      GetLotteryDate getLotteryDate = GetLotteryDate();
      Response<dynamic> response = await getLotteryDate.getDate();

      // Verificar si la respuesta es exitosa
      if (response.statusCode == 200) {
        Map<String, dynamic> data = response.data;

        if (data.containsKey("dateTime")) {
          DateTime dateTime = DateTime.parse(data["dateTime"]);
          Credentials.countdown = dateTime;
          return dateTime;
        } else {
          throw Exception(
              "La clave 'dateTime' no está presente en la respuesta.");
        }
      } else {
        throw Exception(
            "Error en la respuesta del servidor: ${response.statusCode}");
      }
    } catch (e) {
      print('Error al obtener la fecha: $e');

      return DateTime.now();
    }
  }

  void getWinnerLottery() async {
    try {
      GetWinnerController getWinnerController = GetWinnerController();
      Response response = await getWinnerController.getWinner();
      if (response.data != null) {
        setState(() {
          lotteryWinnerDTO = LotteryWinnerDTO.fromJson(response.data);
          isWinner = true;
          currentDate =
              DateFormat('dd / MM / yyyy').format(lotteryWinnerDTO!.createdAt);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  void _startTimer() async {
    DateTime targetDate = Credentials.countdown == null
        ? await getDate()
        : Credentials.countdown!;

    const oneSecond = Duration(seconds: 1);
    DateTime now = DateTime.now();
    _duration = targetDate.difference(now);

    _timer = Timer.periodic(oneSecond, (timer) {
      if (_duration.inSeconds <= 0) {
        timer.cancel();
      } else {
        if (mounted) {
          setState(() {
            _duration = _duration - oneSecond;
          });
        }
      }
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');

    String days = twoDigits(duration.inDays);
    String hours = twoDigits(duration.inHours.remainder(24));
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));

    return "  ${days}d ${hours}h ${minutes}m ${seconds}s";
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: isWinner && lotteryWinnerDTO != null
            ? Padding(
                padding: EdgeInsets.only(left: screenWidth * 0.10),
                child: SizedBox(
                  height: 50, // Ajusta la altura según tus necesidades
                  width: 120, // Ajusta el ancho según tus necesidades
                  child: Stack(
                    children: [
                      const Positioned.fill(
                        child: const Image(
                          image: AssetImage('assets/ticket_ganador.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      Center(
                        child: Text(
                          lotteryWinnerDTO!.number.toString().padLeft(7, '0'),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 27,
                            fontFamily: 'HelveticaCompressed',
                            color: Color.fromRGBO(220, 102, 2, 1.0),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 2,
                        left: 2,
                        right: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              lotteryWinnerDTO!.user.email,
                              style: const TextStyle(
                                fontFamily: 'HelveticaCompressed',
                                fontSize: 5,
                                color: Color.fromRGBO(220, 102, 2, 1.0),
                              ),
                              overflow: TextOverflow.visible,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 1),
                              child: Text(
                                "Fecha Compra: $currentDate",
                                style: const TextStyle(
                                  fontFamily: 'HelveticaCompressed',
                                  fontSize: 5,
                                  color: Color.fromRGBO(220, 102, 2, 1.0),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Column(
                children: [
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Tiempo restante para la rifa",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w300,
                        ),
                  ),
                  const SizedBox(
                      height: 3), // Espacio entre el título y el temporizador
                  Text(
                    _formatDuration(_duration),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w400,
                        ),
                  ),
                ],
              ),
      ),
    );
  }
}
