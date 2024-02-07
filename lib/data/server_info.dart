class ServerInfo {
  const ServerInfo({
    required this.address,
    required this.plus,
    required this.p2pAllowed,
    this.rating,
  });

  final String address;
  final bool plus, p2pAllowed;
  final int? rating;

  @override
  bool operator ==(other) =>
      other is ServerInfo &&
      other.address == address &&
      other.plus == plus &&
      other.p2pAllowed &&
      p2pAllowed &&
      other.rating == rating;

  @override
  int get hashCode => Object.hash(address, plus, p2pAllowed, rating);
}
