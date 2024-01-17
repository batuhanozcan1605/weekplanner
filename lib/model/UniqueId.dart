class UniqueId {
  final int id;
  final String uniqueId;

  UniqueId({required this.id, required this.uniqueId});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'uniqueId': uniqueId,
    };
  }

  factory UniqueId.fromMap(Map<String, dynamic> map) {
    return UniqueId(
      id: map['id'],
      uniqueId: map['uniqueId'],
    );
  }
}