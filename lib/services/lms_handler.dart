// import 'package:m3u_z_parser/extension/extension.dart';
// import 'package:m3u_z_parser/mixin/mixin.dart';
// import 'package:m3u_z_parser/src/models/m3u_entry.dart';
import "package:m3u_z_parser/src/models/m3u_entry.dart";
import 'package:vtv/models/m3u_categorized.dart';

///LIVE MOVIE SERIES
class LMSHelper {
  // final RegExp finalRegex = RegExp(
  //     "((season|SEASON|Season)( \\d+|\\d+))|((episode|EPISODE|Episode)((\\d+)|(( \\d+))))|(\\b(s|S)(\\d+))|((((e|E)(\\d+))|((ep|Ep|EP|eP))(\\d+)))");
  final RegExp season = RegExp(
    r"((\b(s|S))(\d+))|((\b(season|SEASON|Season))((\d+)|( \d+)))",
    multiLine: true,
  );

  final RegExp episode = RegExp(
      r"((\b(e|E))(\d+))|((\b(episode|EPISODE|Episode|ep|EP|Ep))((\d+)|( \d+)))");
  final epAndSe = RegExp(
    r"\b(s|S|SEASON|season|Season)(\d+(E|e|EPISODE|episode|Episode(\d+)))",
  );
  final RegExp yearReg = RegExp(r"\b(18|19|20)\d{2}\b", multiLine: true);

  bool isLive(String text) =>
      (text.toLowerCase().contains("live") ||
          text.toLowerCase().contains("hdtv") ||
          text.toLowerCase().contains("live") ||
          searchPerWord(text)) &&
      !text.contains(yearReg);
  bool hasMatchedAll(String text) =>
      season.hasMatch(text) || episode.hasMatch(text) || epAndSe.hasMatch(text);
  bool isYear(String t) => yearReg.hasMatch(t);
  Map<String, List<M3uEntry>> folder(List<M3uEntry> data) {
    return data.fold(<String, List<M3uEntry>>{}, (previousValue, element) {
      final prp = element.attributes['title-clean'] ?? "tvg-id";
      if (!previousValue.containsKey(prp)) {
        previousValue[prp] = [element];
      } else {
        previousValue[prp]!.add(element);
      }
      return previousValue;
    });
  }

  List<M3uParsedEntry> parseM3u(List<M3uEntry> data) {
    return data.map((e) => M3uParsedEntry.fromJson(e.toJson())).toList();
  }

  List<Map<String, List<M3uEntry>>> categorizeBy(List<M3uEntry> data) {
    final Map<String, List<M3uEntry>> series =
        folder(data.where((element) => element.type.toInt() == 3).toList());
    final Map<String, List<M3uEntry>> movies = folder(
      data.where((element) => element.type.toInt() == 2).toList(),
    );
    final Map<String, List<M3uEntry>> lives = folder(
      data
          .where((element) =>
              element.type.toInt() != 2 && element.type.toInt() != 3)
          .toList(),
    );
    return [
      series,
      movies,
      lives,
    ];
  }

  // List<Map<String, List<M3uEntry>>> categorizeByTitle(List<M3uEntry> data) {
  //   Map<String, List<M3uEntry>> movie = <String, List<M3uEntry>>{};
  //   Map<String, List<M3uEntry>> live = <String, List<M3uEntry>>{};
  //   Map<String, List<M3uEntry>> series =
  //       data.fold(<String, List<M3uEntry>>{}, (old, current) {
  //     final prp = current.attributes['title-clean'] ?? "tvg-id";
  //     Map<String, List<M3uEntry>> mov = <String, List<M3uEntry>>{};
  //     Map<String, List<M3uEntry>> live = <String, List<M3uEntry>>{};
  //     if (hasMatchedAll(current.title) && !isLive(current.title)) {
  //       if (!old.containsKey(prp)) {
  //         old[prp] = [current];
  //       } else {
  //         old[prp]!.add(current);
  //       }
  //     } else {
  //       if (isLive(current.title)) {
  //         if (!live.keys.contains(prp)) {
  //           live[prp] = [current];
  //         } else {
  //           live[prp]!.add(current);
  //         }
  //       } else {
  //         if (!mov.keys.contains(prp)) {
  //           mov[prp] = [current];
  //         } else {
  //           mov[prp]!.add(current);
  //         }
  //       }
  //     }
  //     old.map((key, value) {
  //       final MapEntry entry = MapEntry(key, value);
  //       if (value.length == 1) {
  //         if (isLive(value[0].title)) {
  //           live.addAll({key: value});
  //         } else {
  //           mov.addAll({key: value});
  //         }
  //       }
  //       return entry;
  //     }).removeWhere((key, value) => value.length <= 1);
  //     return old;
  //   });

  //   // data.fold(initialValue, (previousValue, element) => null)
  //   // Map<String, List<M3uEntry>> movie =
  //   //     data.fold(<String, List<M3uEntry>>{}, (old, current) {
  //   //   final prp = current.attributes['title-clean'] ?? "tvg-id";
  //   //   if (!hasMatchedAll(current.title)) {
  //   //     if (!old.containsKey(prp) &&
  //   // !((current.title.toLowerCase().contains("live") ||
  //   //     current.title.toLowerCase().contains("hdtv") ||
  //   //     current.title.toLowerCase().contains("live") ||
  //   //             searchPerWord(current.title)))) {
  //   //       old[prp] = [current];
  //   //     } else {
  //   //       old[prp]!.add(current);
  //   //     }
  //   //   }
  //   //   return old;
  //   // });
  //   // Map<String, List<M3uEntry>> lives =
  //   //     data.fold(<String, List<M3uEntry>>{}, (old, current) {
  //   //   final prp = current.attributes['title-clean'] ?? "tvg-id";
  //   //   if (!hasMatchedAll(current.title) &&
  //   //       (current.title.toLowerCase().contains("live") ||
  //   //           current.title.toLowerCase().contains("hdtv") ||
  //   //           current.title.toLowerCase().contains("live") ||
  //   //           searchPerWord(current.title))) {
  //   //     if (!old.containsKey(prp)) {
  //   //       old[prp] = [current];
  //   //     } else {
  //   //       old[prp]!.add(current);
  //   //     }
  //   //   }
  //   //   return old;
  //   // });
  //   return [
  //     series,
  //     movie,
  //     live,
  //   ];
  //   // return
  // }

  bool searchPerWord(String title) {
    bool result = false;
    for (Map<String, String> country in CountryList.list) {
      for (String delimited in title.split(" ")) {
        if (country.values.contains(delimited) ||
            delimited.toUpperCase() == "CH" ||
            delimited.toUpperCase() == "TV" ||
            delimited.toUpperCase() == "F4HD") {
          return true;
        }
      }
    }
    return result;
  }
}

abstract class Polydata {
  final String title;
  final dynamic data;
  const Polydata({required this.title, required this.data});
}

class CountryList {
  static List<Map<String, String>> list = [
    {"name": "Afghanistan", "code": "AF"},
    {"name": "land Islands", "code": "AX"},
    {"name": "Albania", "code": "AL"},
    {"name": "Algeria", "code": "DZ"},
    {"name": "American Samoa", "code": "AS"},
    {"name": "AndorrA", "code": "AD"},
    {"name": "Angola", "code": "AO"},
    {"name": "Anguilla", "code": "AI"},
    {"name": "Antarctica", "code": "AQ"},
    {"name": "Antigua and Barbuda", "code": "AG"},
    {"name": "Argentina", "code": "AR"},
    {"name": "Armenia", "code": "AM"},
    {"name": "Aruba", "code": "AW"},
    {"name": "Australia", "code": "AU"},
    {"name": "Austria", "code": "AT"},
    {"name": "Azerbaijan", "code": "AZ"},
    {"name": "Bahamas", "code": "BS"},
    {"name": "Bahrain", "code": "BH"},
    {"name": "Bangladesh", "code": "BD"},
    {"name": "Barbados", "code": "BB"},
    {"name": "Belarus", "code": "BY"},
    {"name": "Belgium", "code": "BE"},
    {"name": "Belize", "code": "BZ"},
    {"name": "Benin", "code": "BJ"},
    {"name": "Bermuda", "code": "BM"},
    {"name": "Bhutan", "code": "BT"},
    {"name": "Bolivia", "code": "BO"},
    {"name": "Bosnia and Herzegovina", "code": "BA"},
    {"name": "Botswana", "code": "BW"},
    {"name": "Bouvet Island", "code": "BV"},
    {"name": "Brazil", "code": "BR"},
    {"name": "British Indian Ocean Territory", "code": "IO"},
    {"name": "Brunei Darussalam", "code": "BN"},
    {"name": "Bulgaria", "code": "BG"},
    {"name": "Burkina Faso", "code": "BF"},
    {"name": "Burundi", "code": "BI"},
    {"name": "Cambodia", "code": "KH"},
    {"name": "Cameroon", "code": "CM"},
    {"name": "Canada", "code": "CA"},
    {"name": "Cape Verde", "code": "CV"},
    {"name": "Cayman Islands", "code": "KY"},
    {"name": "Central African Republic", "code": "CF"},
    {"name": "Chad", "code": "TD"},
    {"name": "Chile", "code": "CL"},
    {"name": "China", "code": "CN"},
    {"name": "Christmas Island", "code": "CX"},
    {"name": "Cocos (Keeling) Islands", "code": "CC"},
    {"name": "Colombia", "code": "CO"},
    {"name": "Comoros", "code": "KM"},
    {"name": "Congo", "code": "CG"},
    {"name": "Congo, The Democratic Republic of the", "code": "CD"},
    {"name": "Cook Islands", "code": "CK"},
    {"name": "Costa Rica", "code": "CR"},
    {"name": "Cote D\"Ivoire", "code": "CI"},
    {"name": "Croatia", "code": "HR"},
    {"name": "Cuba", "code": "CU"},
    {"name": "Cyprus", "code": "CY"},
    {"name": "Czech Republic", "code": "CZ"},
    {"name": "Denmark", "code": "DK"},
    {"name": "Djibouti", "code": "DJ"},
    {"name": "Dominica", "code": "DM"},
    {"name": "Dominican Republic", "code": "DO"},
    {"name": "Ecuador", "code": "EC"},
    {"name": "Egypt", "code": "EG"},
    {"name": "El Salvador", "code": "SV"},
    {"name": "Equatorial Guinea", "code": "GQ"},
    {"name": "Eritrea", "code": "ER"},
    {"name": "Estonia", "code": "EE"},
    {"name": "Ethiopia", "code": "ET"},
    {"name": "Falkland Islands (Malvinas)", "code": "FK"},
    {"name": "Faroe Islands", "code": "FO"},
    {"name": "Fiji", "code": "FJ"},
    {"name": "Finland", "code": "FI"},
    {"name": "France", "code": "FR"},
    {"name": "French Guiana", "code": "GF"},
    {"name": "French Polynesia", "code": "PF"},
    {"name": "French Southern Territories", "code": "TF"},
    {"name": "Gabon", "code": "GA"},
    {"name": "Gambia", "code": "GM"},
    {"name": "Georgia", "code": "GE"},
    {"name": "Germany", "code": "DE"},
    {"name": "Ghana", "code": "GH"},
    {"name": "Gibraltar", "code": "GI"},
    {"name": "Greece", "code": "GR"},
    {"name": "Greenland", "code": "GL"},
    {"name": "Grenada", "code": "GD"},
    {"name": "Guadeloupe", "code": "GP"},
    {"name": "Guam", "code": "GU"},
    {"name": "Guatemala", "code": "GT"},
    {"name": "Guernsey", "code": "GG"},
    {"name": "Guinea", "code": "GN"},
    {"name": "Guinea-Bissau", "code": "GW"},
    {"name": "Guyana", "code": "GY"},
    {"name": "Haiti", "code": "HT"},
    {"name": "Heard Island and Mcdonald Islands", "code": "HM"},
    {"name": "Holy See (Vatican City State)", "code": "VA"},
    {"name": "Honduras", "code": "HN"},
    {"name": "Hong Kong", "code": "HK"},
    {"name": "Hungary", "code": "HU"},
    {"name": "Iceland", "code": "IS"},
    {"name": "India", "code": "IN"},
    {"name": "Indonesia", "code": "ID"},
    {"name": "Iran, Islamic Republic Of", "code": "IR"},
    {"name": "Iraq", "code": "IQ"},
    {"name": "Ireland", "code": "IE"},
    {"name": "Isle of Man", "code": "IM"},
    {"name": "Israel", "code": "IL"},
    {"name": "Italy", "code": "IT"},
    {"name": "Jamaica", "code": "JM"},
    {"name": "Japan", "code": "JP"},
    {"name": "Jersey", "code": "JE"},
    {"name": "Jordan", "code": "JO"},
    {"name": "Kazakhstan", "code": "KZ"},
    {"name": "Kenya", "code": "KE"},
    {"name": "Kiribati", "code": "KI"},
    {"name": "Korea, Democratic People's Republic of", "code": "KP"},
    {"name": "Korea, Republic of", "code": "KR"},
    {"name": "Kuwait", "code": "KW"},
    {"name": "Kyrgyzstan", "code": "KG"},
    {"name": "Lao People's Democratic Republic", "code": "LA"},
    {"name": "Latvia", "code": "LV"},
    {"name": "Lebanon", "code": "LB"},
    {"name": "Lesotho", "code": "LS"},
    {"name": "Liberia", "code": "LR"},
    {"name": "Libyan Arab Jamahiriya", "code": "LY"},
    {"name": "Liechtenstein", "code": "LI"},
    {"name": "Lithuania", "code": "LT"},
    {"name": "Luxembourg", "code": "LU"},
    {"name": "Macao", "code": "MO"},
    {"name": "Macedonia, The Former Yugoslav Republic of", "code": "MK"},
    {"name": "Madagascar", "code": "MG"},
    {"name": "Malawi", "code": "MW"},
    {"name": "Malaysia", "code": "MY"},
    {"name": "Maldives", "code": "MV"},
    {"name": "Mali", "code": "ML"},
    {"name": "Malta", "code": "MT"},
    {"name": "Marshall Islands", "code": "MH"},
    {"name": "Martinique", "code": "MQ"},
    {"name": "Mauritania", "code": "MR"},
    {"name": "Mauritius", "code": "MU"},
    {"name": "Mayotte", "code": "YT"},
    {"name": "Mexico", "code": "MX"},
    {"name": "Micronesia, Federated States of", "code": "FM"},
    {"name": "Moldova, Republic of", "code": "MD"},
    {"name": "Monaco", "code": "MC"},
    {"name": "Mongolia", "code": "MN"},
    {"name": "Montenegro", "code": "ME"},
    {"name": "Montserrat", "code": "MS"},
    {"name": "Morocco", "code": "MA"},
    {"name": "Mozambique", "code": "MZ"},
    {"name": "Myanmar", "code": "MM"},
    {"name": "Namibia", "code": "NA"},
    {"name": "Nauru", "code": "NR"},
    {"name": "Nepal", "code": "NP"},
    {"name": "Netherlands", "code": "NL"},
    {"name": "Netherlands Antilles", "code": "AN"},
    {"name": "New Caledonia", "code": "NC"},
    {"name": "New Zealand", "code": "NZ"},
    {"name": "Nicaragua", "code": "NI"},
    {"name": "Niger", "code": "NE"},
    {"name": "Nigeria", "code": "NG"},
    {"name": "Niue", "code": "NU"},
    {"name": "Norfolk Island", "code": "NF"},
    {"name": "Northern Mariana Islands", "code": "MP"},
    {"name": "Norway", "code": "NO"},
    {"name": "Oman", "code": "OM"},
    {"name": "Pakistan", "code": "PK"},
    {"name": "Palau", "code": "PW"},
    {"name": "Palestinian Territory, Occupied", "code": "PS"},
    {"name": "Panama", "code": "PA"},
    {"name": "Papua New Guinea", "code": "PG"},
    {"name": "Paraguay", "code": "PY"},
    {"name": "Peru", "code": "PE"},
    {"name": "Philippines", "code": "PH"},
    {"name": "Pitcairn", "code": "PN"},
    {"name": "Poland", "code": "PL"},
    {"name": "Portugal", "code": "PT"},
    {"name": "Puerto Rico", "code": "PR"},
    {"name": "Qatar", "code": "QA"},
    {"name": "Reunion", "code": "RE"},
    {"name": "Romania", "code": "RO"},
    {"name": "Russian Federation", "code": "RU"},
    {"name": "RWANDA", "code": "RW"},
    {"name": "Saint Helena", "code": "SH"},
    {"name": "Saint Kitts and Nevis", "code": "KN"},
    {"name": "Saint Lucia", "code": "LC"},
    {"name": "Saint Pierre and Miquelon", "code": "PM"},
    {"name": "Saint Vincent and the Grenadines", "code": "VC"},
    {"name": "Samoa", "code": "WS"},
    {"name": "San Marino", "code": "SM"},
    {"name": "Sao Tome and Principe", "code": "ST"},
    {"name": "Saudi Arabia", "code": "SA"},
    {"name": "Senegal", "code": "SN"},
    {"name": "Serbia", "code": "RS"},
    {"name": "Seychelles", "code": "SC"},
    {"name": "Sierra Leone", "code": "SL"},
    {"name": "Singapore", "code": "SG"},
    {"name": "Slovakia", "code": "SK"},
    {"name": "Slovenia", "code": "SI"},
    {"name": "Solomon Islands", "code": "SB"},
    {"name": "Somalia", "code": "SO"},
    {"name": "South Africa", "code": "ZA"},
    {"name": "South Georgia and the South Sandwich Islands", "code": "GS"},
    {"name": "Spain", "code": "ES"},
    {"name": "Sri Lanka", "code": "LK"},
    {"name": "Sudan", "code": "SD"},
    {"name": "Suriname", "code": "SR"},
    {"name": "Svalbard and Jan Mayen", "code": "SJ"},
    {"name": "Swaziland", "code": "SZ"},
    {"name": "Sweden", "code": "SE"},
    {"name": "Switzerland", "code": "CH"},
    {"name": "Syrian Arab Republic", "code": "SY"},
    {"name": "Taiwan, Province of China", "code": "TW"},
    {"name": "Tajikistan", "code": "TJ"},
    {"name": "Tanzania, United Republic of", "code": "TZ"},
    {"name": "Thailand", "code": "TH"},
    {"name": "Timor-Leste", "code": "TL"},
    {"name": "Togo", "code": "TG"},
    {"name": "Tokelau", "code": "TK"},
    {"name": "Tonga", "code": "TO"},
    {"name": "Trinidad and Tobago", "code": "TT"},
    {"name": "Tunisia", "code": "TN"},
    {"name": "Turkey", "code": "TR"},
    {"name": "Turkmenistan", "code": "TM"},
    {"name": "Turks and Caicos Islands", "code": "TC"},
    {"name": "Tuvalu", "code": "TV"},
    {"name": "Uganda", "code": "UG"},
    {"name": "Ukraine", "code": "UA"},
    {"name": "United Arab Emirates", "code": "AE"},
    {"name": "United Kingdom", "code": "GB"},
    {"name": "United States", "code": "US"},
    {"name": "United States Minor Outlying Islands", "code": "UM"},
    {"name": "Uruguay", "code": "UY"},
    {"name": "Uzbekistan", "code": "UZ"},
    {"name": "Vanuatu", "code": "VU"},
    {"name": "Venezuela", "code": "VE"},
    {"name": "Viet Nam", "code": "VN"},
    {"name": "Virgin Islands, British", "code": "VG"},
    {"name": "Virgin Islands, U.S.", "code": "VI"},
    {"name": "Wallis and Futuna", "code": "WF"},
    {"name": "Western Sahara", "code": "EH"},
    {"name": "Yemen", "code": "YE"},
    {"name": "Zambia", "code": "ZM"},
    {"name": "Zimbabwe", "code": "ZW"}
  ];
}
