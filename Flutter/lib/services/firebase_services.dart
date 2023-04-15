import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desktop_controller/services/local_storage.dart';

import '../models/process_model.dart';
import '../models/user_model.dart';

class FirebaseServices {
  // Path: lib\services\firebase_services.dart
  CollectionReference<Map<String, dynamic>> userCollection =
      FirebaseFirestore.instance.collection('USERS');

  // Function: getUserById
  Future<UserModel?> getUserById(String id) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> _docSnapshot =
          await userCollection.doc(id).get();
      return UserModel.fromMap(_docSnapshot.data()!);
    } catch (e) {
      return null;
    }
  }

  // Function: getDevices
  Stream<QuerySnapshot<Map<String, dynamic>>> getDevices() {
    return userCollection.doc(getUniqueId()).collection('DEVICES').snapshots();
  }

  // Function: createUser
  Future<void> createUser(String username, String email) async {
    var rng = Random();
    var code = rng.nextInt(900000) + 100000;
    setUniqueId('$code');
    setUserEmail(email);
    setUserName(username);
    setIsLoggedIn(true);
    await userCollection
        .doc('$code')
        .set(UserModel(email: email, name: username, id: '$code').toMap());
    await Future.delayed(const Duration(seconds: 5));
  }

  // Function: getUser
  Future<UserModel?> getUser(String email) async {
    try {
      QuerySnapshot<Map<String, dynamic>> _querySnapshot =
          await userCollection.where('email', isEqualTo: email).get();
      setUserName(_querySnapshot.docs[0].data()['name']);
      setUserEmail(_querySnapshot.docs[0].data()['email']);
      setUniqueId(_querySnapshot.docs[0].id);
      setIsLoggedIn(true);
      await Future.delayed(const Duration(seconds: 5));
      return UserModel(
          id: _querySnapshot.docs[0].id,
          name: _querySnapshot.docs[0].data()['name'],
          email: _querySnapshot.docs[0].data()['email']);
    } catch (e) {
      return null;
    }
  }

  // Function: getProcesses
  Stream<List<Process>> getProcesses(String ip) {
    return userCollection
        .doc(getUniqueId())
        .collection('DEVICES')
        .doc(ip)
        .snapshots()
        .map((event) {
      List<Process> _processes = [];
      for (var item in event.data()!['processes']) {
        _processes.add(Process.fromJson(item));
      }
      return _processes;
    });
  }

  // Function: powerOff
  Future<void> powerOff(String ip) async {
    await userCollection
        .doc(getUniqueId())
        .collection('DEVICES')
        .doc(ip)
        .update({
      'power': true,
    });
  }

  // Function: killProcess
  Future<void> killProcess(String ip, int pid) async {
    await userCollection
        .doc(getUniqueId())
        .collection('DEVICES')
        .doc(ip)
        .update({
      'kill': '$pid',
    });
  }

  // Function: onBluetooth
  Future<void> onBluetooth(String ip) async {
    await userCollection
        .doc(getUniqueId())
        .collection('DEVICES')
        .doc(ip)
        .update({
      'bluetooth': true,
    });
  }

  // Function: offBluetooth
  Future<void> offBluetooth(String ip) async {
    await userCollection
        .doc(getUniqueId())
        .collection('DEVICES')
        .doc(ip)
        .update({
      'bluetooth': false,
    });
  }

  // Function: DeviceConnected
  Future<void> deviceConnected(String ip) async {
    QuerySnapshot<Map<String, dynamic>> _snapshot =
        await userCollection.doc(getUniqueId()).collection('DEVICES').get();
    for (var element in _snapshot.docs) {
      if (element.id == ip) {
        userCollection
            .doc(getUniqueId())
            .collection('DEVICES')
            .doc(ip)
            .update({'connected': true});
      } else {
        userCollection
            .doc(getUniqueId())
            .collection('DEVICES')
            .doc(element.id)
            .update({'connected': false});
      }
    }
  }

  // Function: BluetoothStatus
  Future<bool> BluetoothStatus(String ip) async {
    DocumentSnapshot<Map<String, dynamic>> _docSnapshot = await userCollection
        .doc(getUniqueId())
        .collection('DEVICES')
        .doc(ip)
        .get();
    return _docSnapshot.data()!['bluetooth'];
  }

  // Function: lockUser
  Future<void> lockUser(String ip) async {
    await userCollection
        .doc(getUniqueId())
        .collection('DEVICES')
        .doc(ip)
        .update({
      'lock': true,
    });
  }

  // Function: playSong
  Future<void> playPauseSong(String ip) async {
    await userCollection
        .doc(getUniqueId())
        .collection('DEVICES')
        .doc(ip)
        .update({
      'play': true,
    });
  }

  // Function: nextSong
  Future<void> nextSong(String ip) async {
    await userCollection
        .doc(getUniqueId())
        .collection('DEVICES')
        .doc(ip)
        .update({
      'next': true,
    });
  }

  // Function: prevSong
  Future<void> prevSong(String ip) async {
    await userCollection
        .doc(getUniqueId())
        .collection('DEVICES')
        .doc(ip)
        .update({
      'prev': true,
    });
  }

  // Function: skipSong
  Future<void> skipSong(String ip) async {
    await userCollection
        .doc(getUniqueId())
        .collection('DEVICES')
        .doc(ip)
        .update({
      'skip': true,
    });
  }

  // Function: backSong
  Future<void> backSong(String ip) async {
    await userCollection
        .doc(getUniqueId())
        .collection('DEVICES')
        .doc(ip)
        .update({
      'back': true,
    });
  }

  // Function: volumeUp
  Future<void> volumeUp(String ip) async {
    await userCollection
        .doc(getUniqueId())
        .collection('DEVICES')
        .doc(ip)
        .update({
      'volumeUp': true,
    });
  }

  // Function: volumeDown
  Future<void> volumeDown(String ip) async {
    await userCollection
        .doc(getUniqueId())
        .collection('DEVICES')
        .doc(ip)
        .update({
      'volumeDown': true,
    });
  }
}
