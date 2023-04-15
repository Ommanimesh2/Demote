import 'package:desktop_controller/services/firebase_services.dart';
import 'package:flutter/material.dart';

import '../services/local_storage.dart';

class MusicControl extends StatelessWidget {
  const MusicControl({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Volume',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        await FirebaseServices().volumeDown(getActiveDevice()!);
                      },
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(55, 55),
                        backgroundColor:
                            const Color.fromARGB(255, 141, 135, 255),
                        shape: const CircleBorder(),
                      ),
                      child: const Icon(Icons.volume_down),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await FirebaseServices().volumeUp(getActiveDevice()!);
                      },
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(55, 55),
                        backgroundColor:
                            const Color.fromARGB(255, 141, 135, 255),
                        shape: const CircleBorder(),
                      ),
                      child: const Icon(Icons.volume_up),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Music',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        await FirebaseServices().backSong(getActiveDevice()!);
                      },
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(55, 55),
                        backgroundColor:
                            const Color.fromARGB(255, 141, 135, 255),
                        shape: const CircleBorder(),
                      ),
                      child: const Icon(Icons.fast_rewind),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await FirebaseServices().skipSong(getActiveDevice()!);
                      },
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(55, 55),
                        backgroundColor:
                            const Color.fromARGB(255, 141, 135, 255),
                        shape: const CircleBorder(),
                      ),
                      child: const Icon(Icons.fast_forward),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        await FirebaseServices().prevSong(getActiveDevice()!);
                      },
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(55, 55),
                        backgroundColor:
                            const Color.fromARGB(255, 141, 135, 255),
                        shape: const CircleBorder(),
                      ),
                      child: const Icon(Icons.skip_previous),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await FirebaseServices()
                            .playPauseSong(getActiveDevice()!);
                      },
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(65, 65),
                        backgroundColor:
                            const Color.fromARGB(255, 141, 135, 255),
                        shape: const CircleBorder(),
                      ),
                      child: const Icon(Icons.play_arrow),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await FirebaseServices().nextSong(getActiveDevice()!);
                      },
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(55, 55),
                        backgroundColor:
                            const Color.fromARGB(255, 141, 135, 255),
                        shape: const CircleBorder(),
                      ),
                      child: const Icon(Icons.skip_next),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
