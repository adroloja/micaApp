import 'package:auto_size_text/auto_size_text.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mica/controller/lottery/GetLotteryNumberController.dart';
import 'package:mica/widget/custom_app_bars/custom_back_bar.dart';

class ListGiftScreen extends StatefulWidget {
  const ListGiftScreen({Key? key}) : super(key: key);

  @override
  _ListGiftScreenState createState() => _ListGiftScreenState();
}

class _ListGiftScreenState extends State<ListGiftScreen> {
  List<Map<String, dynamic>> data = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    GetLotteryNumberController lotteryNumberController =
        GetLotteryNumberController();
    Response response = await lotteryNumberController.getGiftNumbers();

    if (response.statusCode == 200) {
      List<dynamic> responseData = response.data;

      // Agrupar los números de lotería por usernameOwner
      Map<String, List<Map<String, dynamic>>> groupedData = {};
      for (var item in responseData) {
        String usernameOwner = item['usernameOwner'];
        String lotteryNumber = item['number'].toString().padLeft(7, '0');
        DateTime createdDate = DateTime.parse(item['createdDate']);

        if (!groupedData.containsKey(usernameOwner)) {
          groupedData[usernameOwner] = [];
        }
        groupedData[usernameOwner]!.add({
          'number': lotteryNumber,
          'createdDate': createdDate,
        });
      }

      // Convertir el mapa en una lista para ListView.builder
      data = groupedData.entries
          .map((entry) => {
                'usernameOwner': entry.key,
                'numbers': entry.value,
              })
          .toList();

      setState(() {});
    } else {
      // Manejar el caso de error si es necesario
      print('Error fetching data: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomBackBar(
        route: "gift",
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 3,
                child: ExpansionTile(
                  title: Row(
                    children: [
                      const Icon(
                        Icons.people,
                        color: Colors.blue,
                        size: 40,
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            data[index]['usernameOwner'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  children: List.generate(
                    data[index]['numbers'].length,
                    (itemIndex) {
                      var item = data[index]['numbers'][itemIndex];
                      String formattedDate = DateFormat('dd / MM / yyyy')
                          .format(item['createdDate'])
                          .toString();

                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Stack(
                              children: [
                                Image.asset(
                                  'assets/ticket_regalo.png',
                                  fit: BoxFit.cover,
                                ),
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 24.0),
                                    child: Text(
                                      item['number'],
                                      style: const TextStyle(
                                        fontSize: 70,
                                        fontFamily: 'HelveticaCompressed',
                                        color:
                                            Color.fromRGBO(101, 82, 137, 1.0),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 5,
                                  left: 5,
                                  right: 5,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: AutoSizeText(
                                          '  ${data[index]['usernameOwner']}',
                                          style: const TextStyle(
                                            fontSize: 10,
                                            color: Color.fromRGBO(
                                                101, 82, 137, 1.0),
                                            fontFamily: 'HelveticaCompressed',
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(right: 5),
                                          child: AutoSizeText(
                                            'Fecha compra: $formattedDate',
                                            style: const TextStyle(
                                              fontSize: 10,
                                              color: Color.fromRGBO(
                                                  101, 82, 137, 1.0),
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
                          if (itemIndex != data[index]['numbers'].length - 1)
                            const Divider()
                        ],
                      );
                    },
                  ).toList(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
