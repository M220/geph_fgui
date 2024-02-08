import 'package:flutter_gen/gen_l10n/app_localizations.dart';

String? extractCountry(String address) {
  for (final subString in address.split(".")) {
    if (subString.length == 2) return subString;

    for (final part in subString.split("-")) {
      if (part.length == 2) return part;
    }
  }
  return null;
}

String? extractCity(String address) {
  for (final subString in address.split(".")) {
    if (subString.length == 3) return subString;

    for (final part in subString.split("-")) {
      if (part.length == 3) return part;
    }
  }

  return null;
}

Map<String, String> getLocalizedCityMap(AppLocalizations localizations) {
  return {
    "acc": localizations.acc,
    "ams": localizations.ams,
    "athens": localizations.athens,
    "bkk": localizations.bkk,
    "beg": localizations.beg,
    "fra": localizations.fra,
    "hel": localizations.hel,
    "ist": localizations.ist,
    "cgk": localizations.cgk,
    "jnb": localizations.jnb,
    "lom": localizations.lom,
    "lca": localizations.lca,
    "lfw": localizations.lfw,
    "lon": localizations.lon,
    "lax": localizations.lax,
    "mad": localizations.mad,
    "mnl": localizations.mnl,
    "mil": localizations.mil,
    "mtl": localizations.mtl,
    "mow": localizations.mow,
    "nbo": localizations.nbo,
    "nyc": localizations.nyc,
    "oslo": localizations.oslo,
    "par": localizations.par,
    "pdx": localizations.pdx,
    "prg": localizations.prg,
    "prn": localizations.prn,
    "kef": localizations.kef,
    "rom": localizations.rom,
    "sfo": localizations.sfo,
    "seoul": localizations.seoul,
    "sgp": localizations.sgp,
    "skp": localizations.skp,
    "sto": localizations.sto,
    "syd": localizations.syd,
    "rmq": localizations.rmq,
    "tpe": localizations.tpe,
    "tlv": localizations.tlv,
    "tyo": localizations.tyo,
    "vce": localizations.vce,
    "vie": localizations.vie,
    "waw": localizations.waw,
    "zrh": localizations.zrh,
  };
}
