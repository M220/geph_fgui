class AccountData {
  const AccountData({
    required this.username,
    required this.password,
  });

  final String username, password;

  @override
  bool operator ==(other) =>
      other is AccountData &&
      other.username == username &&
      other.password == password;

  @override
  int get hashCode => Object.hash(username, password);
}
