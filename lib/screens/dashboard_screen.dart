import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iot_firestore_flutter_app/auth_helper.dart';
import 'package:iot_firestore_flutter_app/const/custom_styles.dart';
import 'package:iot_firestore_flutter_app/model/sensor.dart';
import 'package:iot_firestore_flutter_app/route/routing_constants.dart';
import 'package:iot_firestore_flutter_app/widgets/my_sensor_card.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<double>? dbList;
  List<double>? db1List;

  static String collectionName = 'House1';
  final sensorRef = FirebaseFirestore.instance
      .collection(collectionName)
      .withConverter<Sensor>(
        fromFirestore: (snapshots, _) => Sensor.fromJson(snapshots.data()!),
        toFirestore: (movie, _) => movie.toJson(),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<QuerySnapshot<Sensor>>(
      stream: sensorRef.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        }

        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        // else {
        //   final data = snapshot.requireData;
        //   if (data != null) {
        //     return Center(child: Text("data tersedia => ${data.docs.first.data().Sensor1}", style: TextStyle(color: Colors.white),),);
        //   } else {
        //     return const Center(child: Text("no data", style: TextStyle(color: Colors.white),),);
        //   }

        // }

        final data = snapshot.requireData;

        // debugPrint("test");
        // print("test => ${data.docs.first.data()}");

        double sensor1 = data.docs.first.data().Sensor1.toDouble();
        double sensor2 = data.docs.first.data().Sensor2.toDouble();

        if (dbList == null) {
          dbList = List.filled(5, sensor1, growable: true);
        } else {
          dbList!.add(sensor1);
          dbList!.removeAt(0);
        }

        if (db1List == null) {
          db1List = List.filled(5, sensor2, growable: true);
        } else {
          db1List!.add(sensor2);
          db1List!.removeAt(0);
        }

        return Padding(
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 40, bottom: 30),
          child: CustomScrollView(slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            collectionName,
                            style: kHeadline,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            data.docs.first.id,
                            style: kHeadline,
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              MySensorCard(
                                value: sensor1,
                                unit: 'dB',
                                name: 'Sensor1',
                                assetImage: AssetImage(
                                  'assets/images/volume.png',
                                ),
                                trendData: dbList!,
                                linePoint: Color.fromARGB(255, 163, 165, 169),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              MySensorCard(
                                value: sensor2,
                                unit: 'dB',
                                name: 'Sensor2',
                                assetImage: AssetImage(
                                  'assets/images/volume.png',
                                ),
                                trendData: db1List!,
                                linePoint: Colors.redAccent,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Sign out of Firebase? ",
                        style: kBodyText,
                      ),
                      GestureDetector(
                        onTap: _signOut,
                        child: Text(
                          "Sign Out",
                          style: kBodyText.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ]),
        );
      },
    ));
  }

  _signOut() async {
    await AuthHelper.signOut();
    Navigator.pushNamedAndRemoveUntil(
        context, SplashScreenRoute, (Route<dynamic> route) => false);
  }
}
