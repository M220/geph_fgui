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

    expect(localizedCityMap.remove("acc"), localizations.acc);
    expect(localizedCityMap.remove("ams"), localizations.ams);
    expect(localizedCityMap.remove("athens"), localizations.athens);
    expect(localizedCityMap.remove("bkk"), localizations.bkk);
    expect(localizedCityMap.remove("beg"), localizations.beg);
    expect(localizedCityMap.remove("fra"), localizations.fra);
    expect(localizedCityMap.remove("hel"), localizations.hel);
    expect(localizedCityMap.remove("ist"), localizations.ist);
    expect(localizedCityMap.remove("cgk"), localizations.cgk);
    expect(localizedCityMap.remove("jnb"), localizations.jnb);
    expect(localizedCityMap.remove("lom"), localizations.lom);
    expect(localizedCityMap.remove("lca"), localizations.lca);
    expect(localizedCityMap.remove("lfw"), localizations.lfw);
    expect(localizedCityMap.remove("lon"), localizations.lon);
    expect(localizedCityMap.remove("lax"), localizations.lax);
    expect(localizedCityMap.remove("mad"), localizations.mad);
    expect(localizedCityMap.remove("mnl"), localizations.mnl);
    expect(localizedCityMap.remove("mil"), localizations.mil);
    expect(localizedCityMap.remove("mtl"), localizations.mtl);
    expect(localizedCityMap.remove("mow"), localizations.mow);
    expect(localizedCityMap.remove("nbo"), localizations.nbo);
    expect(localizedCityMap.remove("nyc"), localizations.nyc);
    expect(localizedCityMap.remove("oslo"), localizations.oslo);
    expect(localizedCityMap.remove("par"), localizations.par);
    expect(localizedCityMap.remove("pdx"), localizations.pdx);
    expect(localizedCityMap.remove("prg"), localizations.prg);
    expect(localizedCityMap.remove("prn"), localizations.prn);
    expect(localizedCityMap.remove("kef"), localizations.kef);
    expect(localizedCityMap.remove("rom"), localizations.rom);
    expect(localizedCityMap.remove("sfo"), localizations.sfo);
    expect(localizedCityMap.remove("seoul"), localizations.seoul);
    expect(localizedCityMap.remove("sgp"), localizations.sgp);
    expect(localizedCityMap.remove("skp"), localizations.skp);
    expect(localizedCityMap.remove("sto"), localizations.sto);
    expect(localizedCityMap.remove("syd"), localizations.syd);
    expect(localizedCityMap.remove("rmq"), localizations.rmq);
    expect(localizedCityMap.remove("tpe"), localizations.tpe);
    expect(localizedCityMap.remove("tlv"), localizations.tlv);
    expect(localizedCityMap.remove("tyo"), localizations.tyo);
    expect(localizedCityMap.remove("vce"), localizations.vce);
    expect(localizedCityMap.remove("vie"), localizations.vie);
    expect(localizedCityMap.remove("waw"), localizations.waw);
    expect(localizedCityMap.remove("zrh"), localizations.zrh);
    expect(localizedCityMap.length, 0);
  });
}
