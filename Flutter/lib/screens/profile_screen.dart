import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desktop_controller/services/firebase_services.dart';
import 'package:desktop_controller/services/local_storage.dart';
import 'package:flutter/material.dart';
import '../models/desktop_model.dart';
import '../models/process_model.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String username = getUserName()!;
    String email = getUserEmail()!;
    String uid = getUniqueId()!;
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Container(
      height: h,
      width: w,
      padding: const EdgeInsets.all(30),
      child: Column(
        children: [
        Container(
          height: 300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 30,
              ),
              const Text(
                'Profile Screen',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  const Text(
                    'Username: ',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    '$username',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  Text(
                    'Email: ',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    '$email',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      const Text(
                        'Your Unique ID ',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        '$uid',
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      const SizedBox(
                        height: 28,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Desktops',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseServices().getDevices(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData &&
                        snapshot.connectionState == ConnectionState.none) {
                      return Container();
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    final data = snapshot.data!;
                    if (data == null) {
                      return Container();
                    }
                    List<Desktop> desktops = [];
                    data.docs.forEach((element) {
                      List<dynamic> processes = element.data()['processes'];
                      List<Process> process = [];
                      processes.forEach((element) {
                        process.add(Process.fromJson(element));
                      });

                      desktops.add(Desktop(
                          ip: element.id,
                          name: element.data()['name'],
                          connected: element.data()['connected'],
                          processes: process));
                    });

                    return SingleChildScrollView(
                      child: Container(
                        child: Column(
                          children: [
                            ...List.generate(desktops.length, (index) {
                              return ListTile(
                                title: Text(desktops[index].name),
                                subtitle: Text(desktops[index].ip),
                                trailing: desktops[index].connected
                                    ? const Text(
                                        'Connected',
                                        style: TextStyle(
                                          color: Colors.green,
                                        ),
                                      )
                                    : TextButton(
                                        onPressed: () async {
                                          await FirebaseServices()
                                              .deviceConnected(
                                                  desktops[index].ip);
                                          setActiveDevice(desktops[index].ip);
                                        },
                                        child: const Text('Connect'),
                                      ),
                              );
                            }),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
