import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:geph_fgui/helpers/address_localization_helper.dart' as h;

void main() {
  test("extractCity works", () {
    const mockAddress = "cz-prg-101.geph.io";
    var city = h.extractCity(mockAddress);
    expect(city, "prg");
    city = h.extractCity("mockWrongAddress");
    expect(city, null);
  });

  test("extractCountry works", () {
    const mockAddress = "cz-prg-101.geph.io";
    var country = h.extractCountry(mockAddress);
    expect(country, "cz");
    country = h.extractCountry("mockWrongAddress");
    expect(country, null);
  });

  testWidgets("getLocalizedCityMap works", (widgetTester) async {
    late AppLocalizations localizations;
    final bodyWidget = MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Builder(builder: (context) {
        localizations = AppLocalizations.of(context)!;
        return Container();
      }),
    );

    await widgetTester.pumpWidget(bodyWidget);
    await widgetTester.pumpAndSettle();

    final localizedCityMap = h.getLocalizedCityMap(localizations);

    expect(localizedCityMap["acc"], localizations.acc);
    expect(localizedCityMap["ams"], localizations.ams);
    expect(localizedCityMap["athens"], localizations.athens);
    expect(localizedCityMap["bkk"], localizations.bkk);
    expect(localizedCityMap["beg"], localizations.beg);
    expect(localizedCityMap["fra"], localizations.fra);
    expect(localizedCityMap["hel"], localizations.hel);
    expect(localizedCityMap["ist"], localizations.ist);
    expect(localizedCityMap["cgk"], localizations.cgk);
    expect(localizedCityMap["jnb"], localizations.jnb);
    expect(localizedCityMap["lom"], localizations.lom);
    expect(localizedCityMap["lca"], localizations.lca);
    expect(localizedCityMap["lfw"], localizations.lfw);
    expect(localizedCityMap["lon"], localizations.lon);
    expect(localizedCityMap["lax"], localizations.lax);
    expect(localizedCityMap["mad"], localizations.mad);
    expect(localizedCityMap["mnl"], localizations.mnl);
    expect(localizedCityMap["mil"], localizations.mil);
    expect(localizedCityMap["mtl"], localizations.mtl);
    expect(localizedCityMap["mow"], localizations.mow);
    expect(localizedCityMap["nbo"], localizations.nbo);
    expect(localizedCityMap["nyc"], localizations.nyc);
    expect(localizedCityMap["oslo"], localizations.oslo);
    expect(localizedCityMap["par"], localizations.par);
    expect(localizedCityMap["pdx"], localizations.pdx);
    expect(localizedCityMap["prg"], localizations.prg);
    expect(localizedCityMap["prn"], localizations.prn);
    expect(localizedCityMap["kef"], localizations.kef);
    expect(localizedCityMap["rom"], localizations.rom);
    expect(localizedCityMap["sfo"], localizations.sfo);
    expect(localizedCityMap["seoul"], localizations.seoul);
    expect(localizedCityMap["sgp"], localizations.sgp);
    expect(localizedCityMap["skp"], localizations.skp);
    expect(localizedCityMap["sto"], localizations.sto);
    expect(localizedCityMap["syd"], localizations.syd);
    expect(localizedCityMap["rmq"], localizations.rmq);
    expect(localizedCityMap["tpe"], localizations.tpe);
    expect(localizedCityMap["tlv"], localizations.tlv);
    expect(localizedCityMap["tyo"], localizations.tyo);
    expect(localizedCityMap["vce"], localizations.vce);
    expect(localizedCityMap["vie"], localizations.vie);
    expect(localizedCityMap["waw"], localizations.waw);
    expect(localizedCityMap["zrh"], localizations.zrh);
    expect(localizedCityMap.length, 43);
  });
}
