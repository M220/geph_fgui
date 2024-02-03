class ServerInfo {
  const ServerInfo({
    required this.address,
    required this.plus,
    required this.p2pAllowed,
    this.rating,
  });

  final String address;
  final bool p2pAllowed;
  final bool plus;
  final int? rating;
}
