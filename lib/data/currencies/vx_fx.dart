import 'package:vortexsales/data/currencies/vx_currencies.dart';

/// Demo mid-market units per 1 USD. Pegs are exact; others are a dated snapshot.
/// The closer must never treat these as catalog prices.
const vxFxAsOf = '2026-11-02';

const vxPerUsd = <String, double>{
  'USD': 1,
  'EUR': 0.92,
  'GBP': 0.76,
  'AED': 3.6725,
  'SAR': 3.75,
  'QAR': 3.64,
  'BHD': 0.376,
  'OMR': 0.3845,
  'KWD': 0.307,
  'JOD': 0.709,
  'EGP': 49.5,
  'YER': 250,
  'IQD': 1310,
  'LBP': 89500,
  'SYP': 13000,
  'SDG': 600,
  'SSP': 3000,
  'DZD': 134,
  'TND': 3.12,
  'MAD': 9.9,
  'LYD': 4.82,
  'MRU': 39.8,
  'SOS': 570,
  'ILS': 3.35,
  'TRY': 34.2,
  'IRR': 42000,
  'AFN': 70,
  'PKR': 278,
  'INR': 83.5,
  'BTN': 83.5,
  'BDT': 119,
  'LKR': 300,
  'NPR': 133.6,
  'CNY': 7.12,
  'JPY': 149,
  'KRW': 1355,
  'HKD': 7.78,
  'TWD': 32.1,
  'SGD': 1.34,
  'BND': 1.34,
  'MYR': 4.45,
  'IDR': 15700,
  'THB': 35.2,
  'VND': 25400,
  'PHP': 57.8,
  'KHR': 4100,
  'LAK': 21500,
  'MMK': 2100,
  'AUD': 1.53,
  'NZD': 1.66,
  'CAD': 1.38,
  'CHF': 0.88,
  'SEK': 10.6,
  'NOK': 10.8,
  'DKK': 6.86,
  'PLN': 3.95,
  'CZK': 23.2,
  'HUF': 365,
  'RON': 4.57,
  'RUB': 92,
  'UAH': 41.2,
  'KZT': 480,
  'AZN': 1.7,
  'GEL': 2.72,
  'BRL': 5.45,
  'MXN': 17.2,
  'ARS': 980,
  'CLP': 940,
  'COP': 4100,
  'PEN': 3.75,
  'VES': 42,
  'CUP': 24,
  'PAB': 1,
  'ZAR': 18.2,
  'NAD': 18.2,
  'LSL': 18.2,
  'SZL': 18.2,
  'ZWG': 13.9,
  'ZMW': 27.1,
  'NGN': 1550,
  'GHS': 15.6,
  'KES': 129,
  'UGX': 3750,
  'TZS': 2650,
  'ETB': 120,
  'XOF': 605,
  'XAF': 605,
  'XCD': 2.7,
  'XPF': 110,
  'LRD': 193,
  'ALL': 92,
  'AMD': 390,
  'AOA': 870,
  'AWG': 1.8,
  'BAM': 1.8,
  'BBD': 2,
  'BGN': 1.8,
  'BIF': 2900,
  'BMD': 1,
  'BOB': 6.91,
  'BSD': 1,
  'BWP': 13.6,
  'BYN': 3.27,
  'BZD': 2,
  'CDF': 2850,
  'CRC': 515,
  'CVE': 101,
  'DJF': 178,
  'DOP': 60,
  'ERN': 15,
  'FJD': 2.25,
  'FKP': 0.76,
  'GIP': 0.76,
  'GMD': 70,
  'GNF': 8600,
  'GTQ': 7.75,
  'GYD': 209,
  'HNL': 24.7,
  'HTG': 132,
  'ISK': 138,
  'JMD': 157,
  'KGS': 87,
  'KMF': 454,
  'KPW': 900,
  'KYD': 0.83,
  'MGA': 4500,
  'MDL': 17.8,
  'MKD': 56.5,
  'MNT': 3450,
  'MOP': 8.01,
  'MUR': 46,
  'MVR': 15.4,
  'MWK': 1730,
  'MZN': 63.9,
  'NIO': 36.8,
  'PGK': 3.95,
  'PYG': 7800,
  'RSD': 108,
  'RWF': 1350,
  'SBD': 8.4,
  'SCR': 14.4,
  'SHP': 0.76,
  'SLE': 22.6,
  'SRD': 35,
  'STN': 22.6,
  'TJS': 10.9,
  'TMT': 3.5,
  'TOP': 2.35,
  'TTD': 6.78,
  'UYU': 40.5,
  'UZS': 12700,
  'VUV': 120,
  'WST': 2.75,
  'XCG': 1.8,
};

bool vxIsPegged(String code) => const {
      'AED', 'SAR', 'QAR', 'BHD', 'OMR', 'HKD', 'PAB', 'BSD', 'BMD', 'XCD',
    }.contains(code);

double? vxConvert(double amount, String from, String to) {
  final a = from.toUpperCase();
  final b = to.toUpperCase();
  if (a == b) return amount;
  final perFrom = vxPerUsd[a];
  final perTo = vxPerUsd[b];
  if (perFrom == null || perTo == null || perFrom == 0) return null;
  return amount / perFrom * perTo;
}

String vxFormatMoney(double amount, String code) {
  final c = code.toUpperCase();
  final decimals = const {'BHD', 'KWD', 'OMR', 'JOD'}.contains(c)
      ? 3
      : const {'JPY', 'KRW', 'VND', 'IDR', 'IRR', 'LBP', 'PYG', 'UGX'}.contains(c)
          ? 0
          : 2;
  final n = amount.toStringAsFixed(decimals);
  final cur = vxCurrencyByCode(c);
  return '$n ${cur.code}';
}

/// Ambiguous words must not pick a riyal or pound by guess.
String? vxCurrencyFromQuery(String input) {
  final q = input.toLowerCase();
  final original = input;

  if (RegExp(r'يمني|اليمن|\byer\b|yemeni?').hasMatch(q) || original.contains('اليمن')) {
    return 'YER';
  }
  if (RegExp(r'سعودي|\bsar\b|saudi').hasMatch(q) || original.contains('السعودية')) {
    return 'SAR';
  }
  if (RegExp(r'قطري|\bqar\b|qatari').hasMatch(q) || original.contains('قطر')) {
    return 'QAR';
  }
  if (RegExp(r'عماني|\bomr\b|omani').hasMatch(q) || original.contains('عمان')) {
    return 'OMR';
  }
  if (RegExp(r'إماراتي|اماراتي|درهم|\baed\b|dirham').hasMatch(q) || original.contains('الإمارات')) {
    return 'AED';
  }
  if (RegExp(r'يورو|\beur\b|euro').hasMatch(q)) return 'EUR';
  if (RegExp(r'استرليني|sterling|\bgbp\b').hasMatch(q)) return 'GBP';
  if (RegExp(r'مصري|\begp\b').hasMatch(q) || original.contains('مصر')) return 'EGP';
  if (RegExp(r'كويتي|\bkwd\b').hasMatch(q)) return 'KWD';
  if (RegExp(r'أردني|اردني|\bjod\b').hasMatch(q)) return 'JOD';
  if (RegExp(r'عراقي|\biqd\b').hasMatch(q)) return 'IQD';
  if (RegExp(r'دولار|\busd\b|dollar').hasMatch(q)) return 'USD';

  for (final c in vxCurrencies) {
    if (c.matches(original) && q.contains(c.code.toLowerCase())) return c.code;
  }
  for (final c in vxCurrencies) {
    if (original.contains(c.nameAr) || q.contains(c.nameEn.toLowerCase())) {
      return c.code;
    }
  }
  return null;
}

bool vxRiyalAmbiguous(String input) {
  if (vxCurrencyFromQuery(input) != null) return false;
  return RegExp(r'ريال|riyal|rial').hasMatch(input.toLowerCase());
}

List<String> vxCompanionQuotes(String input, String catalogCode) {
  final out = <String>[];
  final asked = vxCurrencyFromQuery(input);
  if (asked != null && asked != catalogCode) out.add(asked);

  for (final m in vxDualMarkets) {
    if (m.matches(input)) {
      for (final code in m.codes) {
        if (code != catalogCode && !out.contains(code)) out.add(code);
      }
    }
  }
  return out;
}
