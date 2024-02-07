import 'package:flutter_test/flutter_test.dart';
import 'package:geph_fgui/data/account_data.dart';

void main() {
  test("Test for equality of AccountData", () {
    const mockUsername = "MockUsername";
    const mockPassword = "MockPassword";
    const mockAcc1 =
        AccountData(username: mockUsername, password: mockPassword);
    const mockAcc2 =
        AccountData(username: mockUsername, password: mockPassword);
    expect(identical(mockAcc1, mockAcc2), true);
  });
}
