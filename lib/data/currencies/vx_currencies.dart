class VxCurrency {
  const VxCurrency({
    required this.code,
    required this.symbol,
    required this.nameEn,
    required this.nameAr,
    this.countries = const [],
  });

  final String code;
  final String symbol;
  final String nameEn;
  final String nameAr;
  final List<String> countries;

  String name(bool ar) => ar ? nameAr : nameEn;

  bool matches(String q) {
    final n = q.trim().toLowerCase();
    if (n.isEmpty) return true;
    if (code.toLowerCase().contains(n)) return true;
    if (nameEn.toLowerCase().contains(n)) return true;
    if (nameAr.contains(q.trim())) return true;
    if (symbol.toLowerCase().contains(n)) return true;
    for (final c in countries) {
      if (c.toLowerCase().contains(n)) return true;
    }
    return false;
  }
}

class VxCurrencyMarket {
  const VxCurrencyMarket({
    required this.id,
    required this.nameEn,
    required this.nameAr,
    required this.codes,
  });

  final String id;
  final String nameEn;
  final String nameAr;
  final List<String> codes;

  String name(bool ar) => ar ? nameAr : nameEn;

  bool matches(String q) {
    final n = q.toLowerCase();
    return id == n ||
        nameEn.toLowerCase().contains(n) ||
        nameAr.contains(q);
  }
}

VxCurrency vxCurrencyByCode(String code) {
  final upper = code.toUpperCase();
  for (final c in vxCurrencies) {
    if (c.code == upper) return c;
  }
  return VxCurrency(code: upper, symbol: upper, nameEn: upper, nameAr: upper);
}

List<VxCurrency> vxCurrenciesUsdFirst(Iterable<VxCurrency> input) {
  final list = [...input];
  final i = list.indexWhere((c) => c.code == 'USD');
  if (i > 0) {
    list.insert(0, list.removeAt(i));
  }
  return list;
}

const vxCommonCurrencyCodes = [
  'USD',
  'EUR',
  'SAR',
  'AED',
  'YER',
  'EGP',
  'GBP',
  'KWD',
  'QAR',
  'JOD',
  'IQD',
  'TRY',
];

/// Official or widely circulating set in one market.
const vxDualMarkets = [
  VxCurrencyMarket(id: 'ye', nameEn: 'Yemen', nameAr: 'اليمن', codes: ['YER', 'SAR', 'USD']),
  VxCurrencyMarket(id: 'ps', nameEn: 'Palestine', nameAr: 'فلسطين', codes: ['ILS', 'JOD', 'USD']),
  VxCurrencyMarket(id: 'lb', nameEn: 'Lebanon', nameAr: 'لبنان', codes: ['LBP', 'USD']),
  VxCurrencyMarket(id: 'sy', nameEn: 'Syria', nameAr: 'سوريا', codes: ['SYP', 'TRY', 'USD']),
  VxCurrencyMarket(id: 'iq', nameEn: 'Iraq', nameAr: 'العراق', codes: ['IQD', 'USD']),
  VxCurrencyMarket(id: 'so', nameEn: 'Somalia', nameAr: 'الصومال', codes: ['SOS', 'USD']),
  VxCurrencyMarket(id: 'sd', nameEn: 'Sudan', nameAr: 'السودان', codes: ['SDG', 'USD', 'SAR']),
  VxCurrencyMarket(id: 'ss', nameEn: 'South Sudan', nameAr: 'جنوب السودان', codes: ['SSP', 'USD']),
  VxCurrencyMarket(id: 'af', nameEn: 'Afghanistan', nameAr: 'أفغانستان', codes: ['AFN', 'USD']),
  VxCurrencyMarket(id: 'kh', nameEn: 'Cambodia', nameAr: 'كمبوديا', codes: ['KHR', 'USD']),
  VxCurrencyMarket(id: 'zw', nameEn: 'Zimbabwe', nameAr: 'زيمبابوي', codes: ['USD', 'ZAR', 'ZWG']),
  VxCurrencyMarket(id: 've', nameEn: 'Venezuela', nameAr: 'فنزويلا', codes: ['VES', 'USD']),
  VxCurrencyMarket(id: 'pa', nameEn: 'Panama', nameAr: 'بنما', codes: ['PAB', 'USD']),
  VxCurrencyMarket(id: 'lr', nameEn: 'Liberia', nameAr: 'ليبيريا', codes: ['LRD', 'USD']),
  VxCurrencyMarket(id: 'cu', nameEn: 'Cuba', nameAr: 'كوبا', codes: ['CUP', 'USD', 'EUR']),
  VxCurrencyMarket(id: 'ls', nameEn: 'Lesotho', nameAr: 'ليسوتو', codes: ['LSL', 'ZAR']),
  VxCurrencyMarket(id: 'na', nameEn: 'Namibia', nameAr: 'ناميبيا', codes: ['NAD', 'ZAR']),
  VxCurrencyMarket(id: 'sz', nameEn: 'Eswatini', nameAr: 'إسواتيني', codes: ['SZL', 'ZAR']),
  VxCurrencyMarket(id: 'bt', nameEn: 'Bhutan', nameAr: 'بوتان', codes: ['BTN', 'INR']),
  VxCurrencyMarket(id: 'bn', nameEn: 'Brunei', nameAr: 'بروناي', codes: ['BND', 'SGD']),
];

/// Active ISO 4217 national and regional currencies, searchable by country.
const vxCurrencies = [
  VxCurrency(code: 'USD', symbol: r'$', nameEn: 'US Dollar', nameAr: 'دولار أمريكي', countries: ['United States', 'USA', 'America', 'الولايات المتحدة', 'أمريكا', 'Ecuador', 'الإكوادور', 'El Salvador', 'السلفادور', 'Timor-Leste', 'تيمور الشرقية', 'Marshall Islands', 'Micronesia', 'Palau']),
  VxCurrency(code: 'AED', symbol: 'د.إ', nameEn: 'UAE Dirham', nameAr: 'درهم إماراتي', countries: ['United Arab Emirates', 'UAE', 'الإمارات', 'دبي', 'أبوظبي']),
  VxCurrency(code: 'AFN', symbol: '؋', nameEn: 'Afghan Afghani', nameAr: 'أفغاني', countries: ['Afghanistan', 'أفغانستان']),
  VxCurrency(code: 'ALL', symbol: 'L', nameEn: 'Albanian Lek', nameAr: 'ليك ألباني', countries: ['Albania', 'ألبانيا']),
  VxCurrency(code: 'AMD', symbol: '֏', nameEn: 'Armenian Dram', nameAr: 'درام أرمني', countries: ['Armenia', 'أرمينيا']),
  VxCurrency(code: 'ANG', symbol: 'ƒ', nameEn: 'Netherlands Antillean Guilder', nameAr: 'غيلدر أنتيلي', countries: ['Curaçao', 'Sint Maarten', 'كوراساو']),
  VxCurrency(code: 'AOA', symbol: 'Kz', nameEn: 'Angolan Kwanza', nameAr: 'كوانزا أنغولي', countries: ['Angola', 'أنغولا']),
  VxCurrency(code: 'ARS', symbol: r'$', nameEn: 'Argentine Peso', nameAr: 'بيزو أرجنتيني', countries: ['Argentina', 'الأرجنتين']),
  VxCurrency(code: 'AUD', symbol: r'A$', nameEn: 'Australian Dollar', nameAr: 'دولار أسترالي', countries: ['Australia', 'أستراليا', 'Kiribati', 'كيريباتي', 'Nauru', 'ناورو', 'Tuvalu', 'توفالو', 'Christmas Island', 'Cocos Islands', 'Norfolk Island']),
  VxCurrency(code: 'AWG', symbol: 'ƒ', nameEn: 'Aruban Florin', nameAr: 'فلورن أروبي', countries: ['Aruba', 'أروبا']),
  VxCurrency(code: 'AZN', symbol: '₼', nameEn: 'Azerbaijani Manat', nameAr: 'مانات أذربيجاني', countries: ['Azerbaijan', 'أذربيجان']),
  VxCurrency(code: 'BAM', symbol: 'KM', nameEn: 'Bosnia-Herzegovina Mark', nameAr: 'مارك البوسنة', countries: ['Bosnia', 'Herzegovina', 'البوسنة', 'الهرسك']),
  VxCurrency(code: 'BBD', symbol: r'$', nameEn: 'Barbadian Dollar', nameAr: 'دولار بربادوسي', countries: ['Barbados', 'بربادوس']),
  VxCurrency(code: 'BDT', symbol: '৳', nameEn: 'Bangladeshi Taka', nameAr: 'تاكا بنغلاديشي', countries: ['Bangladesh', 'بنغلاديش']),
  VxCurrency(code: 'BGN', symbol: 'лв', nameEn: 'Bulgarian Lev', nameAr: 'ليف بلغاري', countries: ['Bulgaria', 'بلغاريا']),
  VxCurrency(code: 'BHD', symbol: 'د.ب', nameEn: 'Bahraini Dinar', nameAr: 'دينار بحريني', countries: ['Bahrain', 'البحرين']),
  VxCurrency(code: 'BIF', symbol: 'FBu', nameEn: 'Burundian Franc', nameAr: 'فرنك بوروندي', countries: ['Burundi', 'بوروندي']),
  VxCurrency(code: 'BMD', symbol: r'$', nameEn: 'Bermudian Dollar', nameAr: 'دولار برمودي', countries: ['Bermuda', 'برمودا']),
  VxCurrency(code: 'BND', symbol: r'B$', nameEn: 'Brunei Dollar', nameAr: 'دولار بروناي', countries: ['Brunei', 'بروناي']),
  VxCurrency(code: 'BOB', symbol: 'Bs', nameEn: 'Bolivian Boliviano', nameAr: 'بوليفيانو', countries: ['Bolivia', 'بوليفيا']),
  VxCurrency(code: 'BRL', symbol: r'R$', nameEn: 'Brazilian Real', nameAr: 'ريال برازيلي', countries: ['Brazil', 'البرازيل']),
  VxCurrency(code: 'BSD', symbol: r'$', nameEn: 'Bahamian Dollar', nameAr: 'دولار باهامي', countries: ['Bahamas', 'الباهاما']),
  VxCurrency(code: 'BTN', symbol: 'Nu', nameEn: 'Bhutanese Ngultrum', nameAr: 'نغولترم بوتاني', countries: ['Bhutan', 'بوتان']),
  VxCurrency(code: 'BWP', symbol: 'P', nameEn: 'Botswana Pula', nameAr: 'بولا بوتسواني', countries: ['Botswana', 'بوتسوانا']),
  VxCurrency(code: 'BYN', symbol: 'Br', nameEn: 'Belarusian Ruble', nameAr: 'روبل بيلاروسي', countries: ['Belarus', 'بيلاروسيا']),
  VxCurrency(code: 'BZD', symbol: r'$', nameEn: 'Belize Dollar', nameAr: 'دولار بليزي', countries: ['Belize', 'بليز']),
  VxCurrency(code: 'CAD', symbol: r'C$', nameEn: 'Canadian Dollar', nameAr: 'دولار كندي', countries: ['Canada', 'كندا']),
  VxCurrency(code: 'CDF', symbol: 'FC', nameEn: 'Congolese Franc', nameAr: 'فرنك كونغولي', countries: ['Congo', 'DRC', 'الكونغو', 'كينشاسا']),
  VxCurrency(code: 'CHF', symbol: 'CHF', nameEn: 'Swiss Franc', nameAr: 'فرنك سويسري', countries: ['Switzerland', 'سويسرا', 'Liechtenstein', 'ليختنشتاين']),
  VxCurrency(code: 'CLP', symbol: r'$', nameEn: 'Chilean Peso', nameAr: 'بيزو تشيلي', countries: ['Chile', 'تشيلي']),
  VxCurrency(code: 'CNY', symbol: '¥', nameEn: 'Chinese Yuan', nameAr: 'يوان صيني', countries: ['China', 'الصين']),
  VxCurrency(code: 'COP', symbol: r'$', nameEn: 'Colombian Peso', nameAr: 'بيزو كولومبي', countries: ['Colombia', 'كولومبيا']),
  VxCurrency(code: 'CRC', symbol: '₡', nameEn: 'Costa Rican Colón', nameAr: 'كولون كوستاريكي', countries: ['Costa Rica', 'كوستاريكا']),
  VxCurrency(code: 'CUP', symbol: r'$', nameEn: 'Cuban Peso', nameAr: 'بيزو كوبي', countries: ['Cuba', 'كوبا']),
  VxCurrency(code: 'CVE', symbol: r'$', nameEn: 'Cape Verdean Escudo', nameAr: 'إسكودو الرأس الأخضر', countries: ['Cape Verde', 'الرأس الأخضر']),
  VxCurrency(code: 'CZK', symbol: 'Kč', nameEn: 'Czech Koruna', nameAr: 'كرونة تشيكية', countries: ['Czechia', 'Czech Republic', 'التشيك']),
  VxCurrency(code: 'DJF', symbol: 'Fdj', nameEn: 'Djiboutian Franc', nameAr: 'فرنك جيبوتي', countries: ['Djibouti', 'جيبوتي']),
  VxCurrency(code: 'DKK', symbol: 'kr', nameEn: 'Danish Krone', nameAr: 'كرونة دنماركية', countries: ['Denmark', 'الدنمارك', 'Greenland', 'غرينلاند', 'Faroe Islands', 'فارو']),
  VxCurrency(code: 'DOP', symbol: r'RD$', nameEn: 'Dominican Peso', nameAr: 'بيزو دومينيكاني', countries: ['Dominican Republic', 'جمهورية الدومينيكان']),
  VxCurrency(code: 'DZD', symbol: 'د.ج', nameEn: 'Algerian Dinar', nameAr: 'دينار جزائري', countries: ['Algeria', 'الجزائر']),
  VxCurrency(code: 'EGP', symbol: 'ج.م', nameEn: 'Egyptian Pound', nameAr: 'جنيه مصري', countries: ['Egypt', 'مصر']),
  VxCurrency(code: 'ERN', symbol: 'Nfk', nameEn: 'Eritrean Nakfa', nameAr: 'ناكفا إريتري', countries: ['Eritrea', 'إريتريا']),
  VxCurrency(code: 'ETB', symbol: 'Br', nameEn: 'Ethiopian Birr', nameAr: 'بير إثيوبي', countries: ['Ethiopia', 'إثيوبيا']),
  VxCurrency(code: 'EUR', symbol: '€', nameEn: 'Euro', nameAr: 'يورو', countries: ['Euro', 'Eurozone', 'Germany', 'France', 'Italy', 'Spain', 'Netherlands', 'Belgium', 'Austria', 'Portugal', 'Ireland', 'Greece', 'Finland', 'Slovakia', 'Slovenia', 'Lithuania', 'Latvia', 'Estonia', 'Luxembourg', 'Malta', 'Cyprus', 'Croatia', 'ألمانيا', 'فرنسا', 'إيطاليا', 'إسبانيا', 'هولندا', 'بلجيكا', 'النمسا', 'البرتغال', 'أيرلندا', 'اليونان', 'فنلندا', 'كرواتيا', 'قبرص', 'مالطا', 'Andorra', 'Monaco', 'Montenegro', 'Kosovo']),
  VxCurrency(code: 'FJD', symbol: r'$', nameEn: 'Fijian Dollar', nameAr: 'دولار فيجي', countries: ['Fiji', 'فيجي']),
  VxCurrency(code: 'FKP', symbol: '£', nameEn: 'Falkland Islands Pound', nameAr: 'جنيه جزر فوكلاند', countries: ['Falkland Islands', 'فوكلاند']),
  VxCurrency(code: 'GBP', symbol: '£', nameEn: 'Pound Sterling', nameAr: 'جنيه إسترليني', countries: ['United Kingdom', 'UK', 'Britain', 'England', 'Britain', 'المملكة المتحدة', 'بريطانيا', 'إنجلترا', 'Scotland', 'Wales', 'Isle of Man', 'Jersey', 'Guernsey']),
  VxCurrency(code: 'GEL', symbol: '₾', nameEn: 'Georgian Lari', nameAr: 'لاري جورجي', countries: ['Georgia', 'جورجيا']),
  VxCurrency(code: 'GHS', symbol: 'GH₵', nameEn: 'Ghanaian Cedi', nameAr: 'سيدي غاني', countries: ['Ghana', 'غانا']),
  VxCurrency(code: 'GIP', symbol: '£', nameEn: 'Gibraltar Pound', nameAr: 'جنيه جبل طارق', countries: ['Gibraltar', 'جبل طارق']),
  VxCurrency(code: 'GMD', symbol: 'D', nameEn: 'Gambian Dalasi', nameAr: 'دالاسي غامبي', countries: ['Gambia', 'غامبيا']),
  VxCurrency(code: 'GNF', symbol: 'FG', nameEn: 'Guinean Franc', nameAr: 'فرنك غيني', countries: ['Guinea', 'غينيا']),
  VxCurrency(code: 'GTQ', symbol: 'Q', nameEn: 'Guatemalan Quetzal', nameAr: 'كتزال غواتيمالي', countries: ['Guatemala', 'غواتيمالا']),
  VxCurrency(code: 'GYD', symbol: r'$', nameEn: 'Guyanese Dollar', nameAr: 'دولار غياني', countries: ['Guyana', 'غيانا']),
  VxCurrency(code: 'HKD', symbol: r'HK$', nameEn: 'Hong Kong Dollar', nameAr: 'دولار هونغ كونغ', countries: ['Hong Kong', 'هونغ كونغ']),
  VxCurrency(code: 'HNL', symbol: 'L', nameEn: 'Honduran Lempira', nameAr: 'لمبيرة هندوراسية', countries: ['Honduras', 'هندوراس']),
  VxCurrency(code: 'HTG', symbol: 'G', nameEn: 'Haitian Gourde', nameAr: 'جورد هايتي', countries: ['Haiti', 'هايتي']),
  VxCurrency(code: 'HUF', symbol: 'Ft', nameEn: 'Hungarian Forint', nameAr: 'فورنت مجري', countries: ['Hungary', 'المجر', 'هنغاريا']),
  VxCurrency(code: 'IDR', symbol: 'Rp', nameEn: 'Indonesian Rupiah', nameAr: 'روبية إندونيسية', countries: ['Indonesia', 'إندونيسيا']),
  VxCurrency(code: 'ILS', symbol: '₪', nameEn: 'Shekel', nameAr: 'شيكل', countries: ['Palestine', 'فلسطين', 'Israel', 'إسرائيل']),
  VxCurrency(code: 'INR', symbol: '₹', nameEn: 'Indian Rupee', nameAr: 'روبية هندية', countries: ['India', 'الهند', 'Bhutan', 'بوتان']),
  VxCurrency(code: 'IQD', symbol: 'د.ع', nameEn: 'Iraqi Dinar', nameAr: 'دينار عراقي', countries: ['Iraq', 'العراق']),
  VxCurrency(code: 'IRR', symbol: '﷼', nameEn: 'Iranian Rial', nameAr: 'ريال إيراني', countries: ['Iran', 'إيران']),
  VxCurrency(code: 'ISK', symbol: 'kr', nameEn: 'Icelandic Króna', nameAr: 'كرونة آيسلندية', countries: ['Iceland', 'آيسلندا']),
  VxCurrency(code: 'JMD', symbol: r'$', nameEn: 'Jamaican Dollar', nameAr: 'دولار جامايكي', countries: ['Jamaica', 'جامايكا']),
  VxCurrency(code: 'JOD', symbol: 'د.أ', nameEn: 'Jordanian Dinar', nameAr: 'دينار أردني', countries: ['Jordan', 'الأردن', 'Palestine', 'فلسطين']),
  VxCurrency(code: 'JPY', symbol: '¥', nameEn: 'Japanese Yen', nameAr: 'ين ياباني', countries: ['Japan', 'اليابان']),
  VxCurrency(code: 'KES', symbol: 'KSh', nameEn: 'Kenyan Shilling', nameAr: 'شلن كيني', countries: ['Kenya', 'كينيا']),
  VxCurrency(code: 'KGS', symbol: 'с', nameEn: 'Kyrgyzstani Som', nameAr: 'سوم قيرغيزستاني', countries: ['Kyrgyzstan', 'قيرغيزستان']),
  VxCurrency(code: 'KHR', symbol: '៛', nameEn: 'Cambodian Riel', nameAr: 'ريال كمبودي', countries: ['Cambodia', 'كمبوديا']),
  VxCurrency(code: 'KMF', symbol: 'CF', nameEn: 'Comorian Franc', nameAr: 'فرنك قمري', countries: ['Comoros', 'جزر القمر']),
  VxCurrency(code: 'KPW', symbol: '₩', nameEn: 'North Korean Won', nameAr: 'وون كوري شمالي', countries: ['North Korea', 'كوريا الشمالية']),
  VxCurrency(code: 'KRW', symbol: '₩', nameEn: 'South Korean Won', nameAr: 'وون كوري جنوبي', countries: ['South Korea', 'كوريا الجنوبية']),
  VxCurrency(code: 'KWD', symbol: 'د.ك', nameEn: 'Kuwaiti Dinar', nameAr: 'دينار كويتي', countries: ['Kuwait', 'الكويت']),
  VxCurrency(code: 'KYD', symbol: r'$', nameEn: 'Cayman Islands Dollar', nameAr: 'دولار جزر كايمان', countries: ['Cayman Islands', 'كايمان']),
  VxCurrency(code: 'KZT', symbol: '₸', nameEn: 'Kazakhstani Tenge', nameAr: 'تينغ كازاخستاني', countries: ['Kazakhstan', 'كازاخستان']),
  VxCurrency(code: 'LAK', symbol: '₭', nameEn: 'Lao Kip', nameAr: 'كيب لاوسي', countries: ['Laos', 'لاوس']),
  VxCurrency(code: 'LBP', symbol: 'ل.ل', nameEn: 'Lebanese Pound', nameAr: 'ليرة لبنانية', countries: ['Lebanon', 'لبنان']),
  VxCurrency(code: 'LKR', symbol: 'Rs', nameEn: 'Sri Lankan Rupee', nameAr: 'روبية سريلانكية', countries: ['Sri Lanka', 'سريلانكا']),
  VxCurrency(code: 'LRD', symbol: r'L$', nameEn: 'Liberian Dollar', nameAr: 'دولار ليبيري', countries: ['Liberia', 'ليبيريا']),
  VxCurrency(code: 'LSL', symbol: 'L', nameEn: 'Lesotho Loti', nameAr: 'لوتي ليسوتو', countries: ['Lesotho', 'ليسوتو']),
  VxCurrency(code: 'LYD', symbol: 'د.ل', nameEn: 'Libyan Dinar', nameAr: 'دينار ليبي', countries: ['Libya', 'ليبيا']),
  VxCurrency(code: 'MAD', symbol: 'د.م', nameEn: 'Moroccan Dirham', nameAr: 'درهم مغربي', countries: ['Morocco', 'المغرب', 'Western Sahara', 'الصحراء الغربية']),
  VxCurrency(code: 'MDL', symbol: 'L', nameEn: 'Moldovan Leu', nameAr: 'ليو مولدوفي', countries: ['Moldova', 'مولدوفا']),
  VxCurrency(code: 'MGA', symbol: 'Ar', nameEn: 'Malagasy Ariary', nameAr: 'أرياري مدغشقري', countries: ['Madagascar', 'مدغشقر']),
  VxCurrency(code: 'MKD', symbol: 'ден', nameEn: 'Macedonian Denar', nameAr: 'دينار مقدوني', countries: ['North Macedonia', 'مقدونيا']),
  VxCurrency(code: 'MMK', symbol: 'K', nameEn: 'Myanmar Kyat', nameAr: 'كيات ميانماري', countries: ['Myanmar', 'Burma', 'ميانمار', 'بورما']),
  VxCurrency(code: 'MNT', symbol: '₮', nameEn: 'Mongolian Tögrög', nameAr: 'توغروغ منغولي', countries: ['Mongolia', 'منغوليا']),
  VxCurrency(code: 'MOP', symbol: r'MOP$', nameEn: 'Macanese Pataca', nameAr: 'باتاكا ماكاوية', countries: ['Macau', 'ماكاو']),
  VxCurrency(code: 'MRU', symbol: 'UM', nameEn: 'Mauritanian Ouguiya', nameAr: 'أوقية موريتانية', countries: ['Mauritania', 'موريتانيا']),
  VxCurrency(code: 'MUR', symbol: '₨', nameEn: 'Mauritian Rupee', nameAr: 'روبية موريشيوسية', countries: ['Mauritius', 'موريشيوس']),
  VxCurrency(code: 'MVR', symbol: 'Rf', nameEn: 'Maldivian Rufiyaa', nameAr: 'روفيا مالديفية', countries: ['Maldives', 'المالديف']),
  VxCurrency(code: 'MWK', symbol: 'MK', nameEn: 'Malawian Kwacha', nameAr: 'كواشا ملاوية', countries: ['Malawi', 'ملاوي']),
  VxCurrency(code: 'MXN', symbol: r'MX$', nameEn: 'Mexican Peso', nameAr: 'بيزو مكسيكي', countries: ['Mexico', 'المكسيك']),
  VxCurrency(code: 'MYR', symbol: 'RM', nameEn: 'Malaysian Ringgit', nameAr: 'رينغيت ماليزي', countries: ['Malaysia', 'ماليزيا']),
  VxCurrency(code: 'MZN', symbol: 'MT', nameEn: 'Mozambican Metical', nameAr: 'متكال موزمبيقي', countries: ['Mozambique', 'موزمبيق']),
  VxCurrency(code: 'NAD', symbol: r'$', nameEn: 'Namibian Dollar', nameAr: 'دولار ناميبي', countries: ['Namibia', 'ناميبيا']),
  VxCurrency(code: 'NGN', symbol: '₦', nameEn: 'Nigerian Naira', nameAr: 'نيرة نيجيرية', countries: ['Nigeria', 'نيجيريا']),
  VxCurrency(code: 'NIO', symbol: r'C$', nameEn: 'Nicaraguan Córdoba', nameAr: 'كوردوبا نيكاراغوي', countries: ['Nicaragua', 'نيكاراغوا']),
  VxCurrency(code: 'NOK', symbol: 'kr', nameEn: 'Norwegian Krone', nameAr: 'كرونة نرويجية', countries: ['Norway', 'النرويج']),
  VxCurrency(code: 'NPR', symbol: 'Rs', nameEn: 'Nepalese Rupee', nameAr: 'روبية نيبالية', countries: ['Nepal', 'نيبال']),
  VxCurrency(code: 'NZD', symbol: r'NZ$', nameEn: 'New Zealand Dollar', nameAr: 'دولار نيوزيلندي', countries: ['New Zealand', 'نيوزيلندا', 'Cook Islands', 'Niue', 'Pitcairn', 'Tokelau']),
  VxCurrency(code: 'OMR', symbol: 'ر.ع', nameEn: 'Omani Rial', nameAr: 'ريال عماني', countries: ['Oman', 'عُمان', 'عمان']),
  VxCurrency(code: 'PAB', symbol: 'B/.', nameEn: 'Panamanian Balboa', nameAr: 'بالبوا بنمي', countries: ['Panama', 'بنما']),
  VxCurrency(code: 'PEN', symbol: 'S/', nameEn: 'Peruvian Sol', nameAr: 'سول بيروفي', countries: ['Peru', 'بيرو']),
  VxCurrency(code: 'PGK', symbol: 'K', nameEn: 'Papua New Guinean Kina', nameAr: 'كينا بابوا', countries: ['Papua New Guinea', 'بابوا غينيا الجديدة']),
  VxCurrency(code: 'PHP', symbol: '₱', nameEn: 'Philippine Peso', nameAr: 'بيزو فلبيني', countries: ['Philippines', 'الفلبين']),
  VxCurrency(code: 'PKR', symbol: '₨', nameEn: 'Pakistani Rupee', nameAr: 'روبية باكستانية', countries: ['Pakistan', 'باكستان']),
  VxCurrency(code: 'PLN', symbol: 'zł', nameEn: 'Polish Zloty', nameAr: 'زلوتي بولندي', countries: ['Poland', 'بولندا']),
  VxCurrency(code: 'PYG', symbol: '₲', nameEn: 'Paraguayan Guaraní', nameAr: 'غواراني باراغواي', countries: ['Paraguay', 'باراغواي']),
  VxCurrency(code: 'QAR', symbol: 'ر.ق', nameEn: 'Qatari Riyal', nameAr: 'ريال قطري', countries: ['Qatar', 'قطر']),
  VxCurrency(code: 'RON', symbol: 'lei', nameEn: 'Romanian Leu', nameAr: 'ليو روماني', countries: ['Romania', 'رومانيا']),
  VxCurrency(code: 'RSD', symbol: 'дин', nameEn: 'Serbian Dinar', nameAr: 'دينار صربي', countries: ['Serbia', 'صربيا']),
  VxCurrency(code: 'RUB', symbol: '₽', nameEn: 'Russian Ruble', nameAr: 'روبل روسي', countries: ['Russia', 'روسيا']),
  VxCurrency(code: 'RWF', symbol: 'FRw', nameEn: 'Rwandan Franc', nameAr: 'فرنك رواندي', countries: ['Rwanda', 'رواندا']),
  VxCurrency(code: 'SAR', symbol: '﷼', nameEn: 'Saudi Riyal', nameAr: 'ريال سعودي', countries: ['Saudi Arabia', 'السعودية', 'اليمن']),
  VxCurrency(code: 'SBD', symbol: r'$', nameEn: 'Solomon Islands Dollar', nameAr: 'دولار جزر سليمان', countries: ['Solomon Islands', 'جزر سليمان']),
  VxCurrency(code: 'SCR', symbol: '₨', nameEn: 'Seychellois Rupee', nameAr: 'روبية سيشلية', countries: ['Seychelles', 'سيشل']),
  VxCurrency(code: 'SDG', symbol: 'ج.س', nameEn: 'Sudanese Pound', nameAr: 'جنيه سوداني', countries: ['Sudan', 'السودان']),
  VxCurrency(code: 'SEK', symbol: 'kr', nameEn: 'Swedish Krona', nameAr: 'كرونة سويدية', countries: ['Sweden', 'السويد']),
  VxCurrency(code: 'SGD', symbol: r'S$', nameEn: 'Singapore Dollar', nameAr: 'دولار سنغافوري', countries: ['Singapore', 'سنغافورة', 'Brunei', 'بروناي']),
  VxCurrency(code: 'SHP', symbol: '£', nameEn: 'Saint Helena Pound', nameAr: 'جنيه سانت هيلينا', countries: ['Saint Helena', 'سانت هيلينا']),
  VxCurrency(code: 'SLE', symbol: 'Le', nameEn: 'Sierra Leonean Leone', nameAr: 'ليون سيراليوني', countries: ['Sierra Leone', 'سيراليون']),
  VxCurrency(code: 'SOS', symbol: 'S', nameEn: 'Somali Shilling', nameAr: 'شلن صومالي', countries: ['Somalia', 'الصومال']),
  VxCurrency(code: 'SRD', symbol: r'$', nameEn: 'Surinamese Dollar', nameAr: 'دولار سورينامي', countries: ['Suriname', 'سورينام']),
  VxCurrency(code: 'SSP', symbol: '£', nameEn: 'South Sudanese Pound', nameAr: 'جنيه جنوب السودان', countries: ['South Sudan', 'جنوب السودان']),
  VxCurrency(code: 'STN', symbol: 'Db', nameEn: 'São Tomé Dobra', nameAr: 'دوبرا ساو تومي', countries: ['Sao Tome', 'ساو تومي']),
  VxCurrency(code: 'SYP', symbol: 'ل.س', nameEn: 'Syrian Pound', nameAr: 'ليرة سورية', countries: ['Syria', 'سوريا']),
  VxCurrency(code: 'SZL', symbol: 'L', nameEn: 'Swazi Lilangeni', nameAr: 'ليلانغيني إسواتيني', countries: ['Eswatini', 'Swaziland', 'إسواتيني']),
  VxCurrency(code: 'THB', symbol: '฿', nameEn: 'Thai Baht', nameAr: 'بات تايلاندي', countries: ['Thailand', 'تايلاند']),
  VxCurrency(code: 'TJS', symbol: 'ЅМ', nameEn: 'Tajikistani Somoni', nameAr: 'سوموني طاجيكي', countries: ['Tajikistan', 'طاجيكستان']),
  VxCurrency(code: 'TMT', symbol: 'm', nameEn: 'Turkmenistani Manat', nameAr: 'مانات تركماني', countries: ['Turkmenistan', 'تركمانستان']),
  VxCurrency(code: 'TND', symbol: 'د.ت', nameEn: 'Tunisian Dinar', nameAr: 'دينار تونسي', countries: ['Tunisia', 'تونس']),
  VxCurrency(code: 'TOP', symbol: r'T$', nameEn: 'Tongan Paʻanga', nameAr: 'بانغا تونغي', countries: ['Tonga', 'تونغا']),
  VxCurrency(code: 'TRY', symbol: '₺', nameEn: 'Turkish Lira', nameAr: 'ليرة تركية', countries: ['Turkey', 'تركيا', 'Northern Cyprus', 'قبرص الشمالية']),
  VxCurrency(code: 'TTD', symbol: r'TT$', nameEn: 'Trinidad and Tobago Dollar', nameAr: 'دولار ترينيداد', countries: ['Trinidad', 'Tobago', 'ترينيداد']),
  VxCurrency(code: 'TWD', symbol: r'NT$', nameEn: 'New Taiwan Dollar', nameAr: 'دولار تايواني', countries: ['Taiwan', 'تايوان']),
  VxCurrency(code: 'TZS', symbol: 'TSh', nameEn: 'Tanzanian Shilling', nameAr: 'شلن تنزاني', countries: ['Tanzania', 'تنزانيا']),
  VxCurrency(code: 'UAH', symbol: '₴', nameEn: 'Ukrainian Hryvnia', nameAr: 'هريفنيا أوكرانية', countries: ['Ukraine', 'أوكرانيا']),
  VxCurrency(code: 'UGX', symbol: 'USh', nameEn: 'Ugandan Shilling', nameAr: 'شلن أوغندي', countries: ['Uganda', 'أوغندا']),
  VxCurrency(code: 'UYU', symbol: r'$U', nameEn: 'Uruguayan Peso', nameAr: 'بيزو أوروغواي', countries: ['Uruguay', 'أوروغواي']),
  VxCurrency(code: 'UZS', symbol: 'soʻm', nameEn: 'Uzbekistani Som', nameAr: 'سوم أوزبكستاني', countries: ['Uzbekistan', 'أوزبكستان']),
  VxCurrency(code: 'VES', symbol: 'Bs', nameEn: 'Venezuelan Bolívar', nameAr: 'بوليفار فنزويلي', countries: ['Venezuela', 'فنزويلا']),
  VxCurrency(code: 'VND', symbol: '₫', nameEn: 'Vietnamese Dong', nameAr: 'دونغ فيتنامي', countries: ['Vietnam', 'فيتنام']),
  VxCurrency(code: 'VUV', symbol: 'Vt', nameEn: 'Vanuatu Vatu', nameAr: 'فاتو فانواتو', countries: ['Vanuatu', 'فانواتو']),
  VxCurrency(code: 'WST', symbol: r'T', nameEn: 'Samoan Tala', nameAr: 'تالا ساموا', countries: ['Samoa', 'ساموا']),
  VxCurrency(code: 'XAF', symbol: 'FCFA', nameEn: 'Central African CFA franc', nameAr: 'فرنك وسط أفريقي', countries: ['Cameroon', 'الكاميرون', 'Chad', 'تشاد', 'Gabon', 'الغابون', 'Congo', 'Equatorial Guinea', 'Central African Republic', 'أفريقيا الوسطى']),
  VxCurrency(code: 'XCD', symbol: r'$', nameEn: 'East Caribbean Dollar', nameAr: 'دولار شرق الكاريبي', countries: ['Antigua', 'Dominica', 'Grenada', 'Saint Lucia', 'Saint Kitts', 'Saint Vincent', 'أنتيغوا', 'دومينيكا', 'غرينادا']),
  VxCurrency(code: 'XCG', symbol: 'Cg', nameEn: 'Caribbean Guilder', nameAr: 'غيلدر كاريبي', countries: ['Curaçao', 'Sint Maarten']),
  VxCurrency(code: 'XOF', symbol: 'CFA', nameEn: 'West African CFA franc', nameAr: 'فرنك غرب أفريقي', countries: ['Senegal', 'السنغال', 'Mali', 'مالي', 'Ivory Coast', 'كوت ديفوار', 'Burkina Faso', 'بوركينا فاسو', 'Benin', 'بنين', 'Niger', 'النيجر', 'Togo', 'توغو', 'Guinea-Bissau']),
  VxCurrency(code: 'XPF', symbol: '₣', nameEn: 'CFP Franc', nameAr: 'فرنك سي إف بي', countries: ['French Polynesia', 'بولينيزيا الفرنسية', 'New Caledonia', 'كاليدونيا الجديدة', 'Wallis']),
  VxCurrency(code: 'YER', symbol: '﷼', nameEn: 'Yemeni Rial', nameAr: 'ريال يمني', countries: ['Yemen', 'اليمن']),
  VxCurrency(code: 'ZAR', symbol: 'R', nameEn: 'South African Rand', nameAr: 'راند جنوب أفريقي', countries: ['South Africa', 'جنوب أفريقيا', 'Lesotho', 'Namibia', 'Eswatini', 'ناميبيا', 'ليسوتو']),
  VxCurrency(code: 'ZMW', symbol: 'ZK', nameEn: 'Zambian Kwacha', nameAr: 'كواشا زامبي', countries: ['Zambia', 'زامبيا']),
  VxCurrency(code: 'ZWG', symbol: 'ZiG', nameEn: 'Zimbabwe Gold', nameAr: 'ذهبي زيمبابوي', countries: ['Zimbabwe', 'زيمبابوي']),
];
