import 'process_model.dart';

class Desktop {
  final String name;
  final String ip;
  final bool connected;
  final List<Process> processes;


  Desktop( {required this.processes,required this.name, required this.ip, required this.connected });

  factory Desktop.fromJson(Map<String, dynamic> json) {
    return Desktop(
      name: json['name'],
      ip: json['ip'],
      connected: json['connected'],
      processes: (json['processes'] as List)
          .map((e) => Process.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'ip': ip,
      'connected': connected,
      'processes': processes.map((e) => e.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'Desktop{name: $name, ip: $ip, connected: $connected, processes: $processes}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Desktop &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          connected == other.connected &&
          ip == other.ip &&
          processes == other.processes;

  @override
  int get hashCode =>
      name.hashCode ^ ip.hashCode ^ connected.hashCode ^ processes.hashCode;
      

  
}