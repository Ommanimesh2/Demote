import 'package:desktop_controller/services/firebase_services.dart';
import 'package:desktop_controller/services/local_storage.dart';
import 'package:flutter/material.dart';

import '../models/process_model.dart';

class PowerControl extends StatefulWidget {
  const PowerControl({super.key});

  @override
  State<PowerControl> createState() => _PowerControlState();
}

class _PowerControlState extends State<PowerControl> {
  String search = '';
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Container(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            Container(
              height: h * 0.65,
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Processes',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // SearchBar
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            search = value.toLowerCase();
                          });
                        },
                        decoration: const InputDecoration(
                          hintText: 'Search',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: getActiveDevice()==''?Center(
                                        child:
                                            const Text('No Device Selected')): SingleChildScrollView(
                        child: StreamBuilder<List<Process>>(
                            stream: FirebaseServices()
                                .getProcesses(getActiveDevice()!),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                if (snapshot.error.toString() ==
                                    ' Null check operator used on a null value') {
                                  return Container(
                                    child: Center(
                                        child:
                                            const Text('No Processes Running')),
                                  );
                                }
                                if (getActiveDevice()! == '') {
                                  return Container(
                                    child: Center(
                                        child:
                                            const Text('No Device Selected')),
                                  );
                                }
                                return Container(
                                  child: Text(snapshot.error.toString()),
                                );
                              }

                              if (snapshot.connectionState ==
                                      ConnectionState.none &&
                                  !snapshot.hasData) {
                                return Container();
                              }
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              List<Process> processes = snapshot.data!;
                              if (search.isNotEmpty) {
                                processes = processes
                                    .where((element) => element.name
                                        .toLowerCase()
                                        .contains(search))
                                    .toList();
                              }
                              return Column(
                                children: [
                                  ...List.generate(processes.length, (index) {
                                    Process process = processes[index];
                                    return ListTile(
                                      title: Text(process.name),
                                      leading: Text('PID : ${process.pid}'),
                                      trailing: TextButton(
                                        onPressed: () async {
                                          await FirebaseServices().killProcess(
                                              getActiveDevice()!!, process.pid);
                                        },
                                        style: TextButton.styleFrom(
                                          backgroundColor: Colors.red,
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                          ),
                                        ),
                                        child: const Text(
                                          'Kill',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    );
                                  })
                                ],
                              );
                            }),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              child: Column(
                children: [
                  const Text(
                    'Controls',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                          onTap: () async {
                            await FirebaseServices()
                                .powerOff(getActiveDevice()!);
                          },
                          child: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.power_settings_new,
                              size: 30,
                              color: Colors.red,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            final bluetooth = await FirebaseServices()
                                .BluetoothStatus(getActiveDevice()!);
                            if (bluetooth) {
                              await FirebaseServices()
                                  .offBluetooth(getActiveDevice()!);
                            } else {
                              await FirebaseServices()
                                  .onBluetooth(getActiveDevice()!);
                            }
                          },
                          child: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.bluetooth,
                              size: 30,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            await FirebaseServices()
                                .lockUser(getActiveDevice()!);
                          },
                          child: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.lock,
                              size: 30,
                              color: Colors.green,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
