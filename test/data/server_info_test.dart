import 'package:flutter_test/flutter_test.dart';
import 'package:geph_fgui/data/server_info.dart';

void main() {
  test("Test for equality of ServerInfo", () {
    const serverAddress = "cz-prg-101.geph.io";
    const serverIsPlus = true;
    const serverIsP2P = true;
    const serverRating = 20;
    const mockInfo1 = ServerInfo(
        address: serverAddress,
        plus: serverIsPlus,
        p2pAllowed: serverIsP2P,
        rating: serverRating);
    const mockInfo2 = ServerInfo(
        address: serverAddress,
        plus: serverIsPlus,
        p2pAllowed: serverIsP2P,
        rating: serverRating);

    expect(identical(mockInfo1, mockInfo2), true);
  });
}
