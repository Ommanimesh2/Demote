class Process {
  final String name;
  final int pid;

  Process({required this.name, required this.pid});

  factory Process.fromJson(Map<String, dynamic> json) {
    return Process(
      name: json['name'],
      pid: json['pid'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'pid': pid,
    };
  }

  @override
  String toString() {
    return 'Process{name: $name, pid: $pid}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Process &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          pid == other.pid;
  
  @override
  int get hashCode => name.hashCode ^ pid.hashCode;

}