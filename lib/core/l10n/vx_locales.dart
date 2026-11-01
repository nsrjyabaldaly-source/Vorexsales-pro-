class VxLocaleInfo {
  const VxLocaleInfo({
    required this.code,
    required this.native,
    required this.english,
    required this.dir,
    required this.group,
  });

  final String code;
  final String native;
  final String english;
  final String dir;
  final String group;

  bool get isRtl => dir == 'rtl';
}

const vxGroupOrder = ['english', 'europe', 'arabic', 'world'];

const vxGroupLabels = {
  'english': 'English',
  'europe': 'Europe',
  'arabic': 'العربية',
  'world': 'World',
};

/// Same catalog as AMREKA2 `i18n/locales.ts`.
const vxLocales = <VxLocaleInfo>[
  VxLocaleInfo(code: 'en', native: 'English', english: 'English', dir: 'ltr', group: 'english'),
  VxLocaleInfo(code: 'de', native: 'Deutsch', english: 'German', dir: 'ltr', group: 'europe'),
  VxLocaleInfo(code: 'fr', native: 'Français', english: 'French', dir: 'ltr', group: 'europe'),
  VxLocaleInfo(code: 'es', native: 'Español', english: 'Spanish', dir: 'ltr', group: 'europe'),
  VxLocaleInfo(code: 'it', native: 'Italiano', english: 'Italian', dir: 'ltr', group: 'europe'),
  VxLocaleInfo(code: 'pt', native: 'Português', english: 'Portuguese', dir: 'ltr', group: 'europe'),
  VxLocaleInfo(code: 'nl', native: 'Nederlands', english: 'Dutch', dir: 'ltr', group: 'europe'),
  VxLocaleInfo(code: 'pl', native: 'Polski', english: 'Polish', dir: 'ltr', group: 'europe'),
  VxLocaleInfo(code: 'sv', native: 'Svenska', english: 'Swedish', dir: 'ltr', group: 'europe'),
  VxLocaleInfo(code: 'nb', native: 'Norsk', english: 'Norwegian', dir: 'ltr', group: 'europe'),
  VxLocaleInfo(code: 'da', native: 'Dansk', english: 'Danish', dir: 'ltr', group: 'europe'),
  VxLocaleInfo(code: 'fi', native: 'Suomi', english: 'Finnish', dir: 'ltr', group: 'europe'),
  VxLocaleInfo(code: 'el', native: 'Ελληνικά', english: 'Greek', dir: 'ltr', group: 'europe'),
  VxLocaleInfo(code: 'cs', native: 'Čeština', english: 'Czech', dir: 'ltr', group: 'europe'),
  VxLocaleInfo(code: 'sk', native: 'Slovenčina', english: 'Slovak', dir: 'ltr', group: 'europe'),
  VxLocaleInfo(code: 'hu', native: 'Magyar', english: 'Hungarian', dir: 'ltr', group: 'europe'),
  VxLocaleInfo(code: 'ro', native: 'Română', english: 'Romanian', dir: 'ltr', group: 'europe'),
  VxLocaleInfo(code: 'bg', native: 'Български', english: 'Bulgarian', dir: 'ltr', group: 'europe'),
  VxLocaleInfo(code: 'hr', native: 'Hrvatski', english: 'Croatian', dir: 'ltr', group: 'europe'),
  VxLocaleInfo(code: 'sl', native: 'Slovenščina', english: 'Slovenian', dir: 'ltr', group: 'europe'),
  VxLocaleInfo(code: 'sr', native: 'Српски', english: 'Serbian', dir: 'ltr', group: 'europe'),
  VxLocaleInfo(code: 'bs', native: 'Bosanski', english: 'Bosnian', dir: 'ltr', group: 'europe'),
  VxLocaleInfo(code: 'mk', native: 'Македонски', english: 'Macedonian', dir: 'ltr', group: 'europe'),
  VxLocaleInfo(code: 'sq', native: 'Shqip', english: 'Albanian', dir: 'ltr', group: 'europe'),
  VxLocaleInfo(code: 'lt', native: 'Lietuvių', english: 'Lithuanian', dir: 'ltr', group: 'europe'),
  VxLocaleInfo(code: 'lv', native: 'Latviešu', english: 'Latvian', dir: 'ltr', group: 'europe'),
  VxLocaleInfo(code: 'et', native: 'Eesti', english: 'Estonian', dir: 'ltr', group: 'europe'),
  VxLocaleInfo(code: 'uk', native: 'Українська', english: 'Ukrainian', dir: 'ltr', group: 'europe'),
  VxLocaleInfo(code: 'ru', native: 'Русский', english: 'Russian', dir: 'ltr', group: 'europe'),
  VxLocaleInfo(code: 'is', native: 'Íslenska', english: 'Icelandic', dir: 'ltr', group: 'europe'),
  VxLocaleInfo(code: 'ga', native: 'Gaeilge', english: 'Irish', dir: 'ltr', group: 'europe'),
  VxLocaleInfo(code: 'mt', native: 'Malti', english: 'Maltese', dir: 'ltr', group: 'europe'),
  VxLocaleInfo(code: 'cy', native: 'Cymraeg', english: 'Welsh', dir: 'ltr', group: 'europe'),
  VxLocaleInfo(code: 'ca', native: 'Català', english: 'Catalan', dir: 'ltr', group: 'europe'),
  VxLocaleInfo(code: 'eu', native: 'Euskara', english: 'Basque', dir: 'ltr', group: 'europe'),
  VxLocaleInfo(code: 'gl', native: 'Galego', english: 'Galician', dir: 'ltr', group: 'europe'),
  VxLocaleInfo(code: 'tr', native: 'Türkçe', english: 'Turkish', dir: 'ltr', group: 'europe'),
  VxLocaleInfo(code: 'ar', native: 'العربية', english: 'Arabic', dir: 'rtl', group: 'arabic'),
  VxLocaleInfo(code: 'zh', native: '简体中文', english: 'Chinese (Simplified)', dir: 'ltr', group: 'world'),
  VxLocaleInfo(code: 'zh-TW', native: '繁體中文', english: 'Chinese (Traditional)', dir: 'ltr', group: 'world'),
  VxLocaleInfo(code: 'ja', native: '日本語', english: 'Japanese', dir: 'ltr', group: 'world'),
  VxLocaleInfo(code: 'ko', native: '한국어', english: 'Korean', dir: 'ltr', group: 'world'),
  VxLocaleInfo(code: 'hi', native: 'हिन्दी', english: 'Hindi', dir: 'ltr', group: 'world'),
  VxLocaleInfo(code: 'bn', native: 'বাংলা', english: 'Bengali', dir: 'ltr', group: 'world'),
  VxLocaleInfo(code: 'id', native: 'Bahasa Indonesia', english: 'Indonesian', dir: 'ltr', group: 'world'),
  VxLocaleInfo(code: 'ms', native: 'Bahasa Melayu', english: 'Malay', dir: 'ltr', group: 'world'),
  VxLocaleInfo(code: 'th', native: 'ไทย', english: 'Thai', dir: 'ltr', group: 'world'),
  VxLocaleInfo(code: 'vi', native: 'Tiếng Việt', english: 'Vietnamese', dir: 'ltr', group: 'world'),
  VxLocaleInfo(code: 'fil', native: 'Filipino', english: 'Filipino', dir: 'ltr', group: 'world'),
  VxLocaleInfo(code: 'ta', native: 'தமிழ்', english: 'Tamil', dir: 'ltr', group: 'world'),
  VxLocaleInfo(code: 'te', native: 'తెలుగు', english: 'Telugu', dir: 'ltr', group: 'world'),
  VxLocaleInfo(code: 'mr', native: 'मराठी', english: 'Marathi', dir: 'ltr', group: 'world'),
  VxLocaleInfo(code: 'gu', native: 'ગુજરાતી', english: 'Gujarati', dir: 'ltr', group: 'world'),
  VxLocaleInfo(code: 'kn', native: 'ಕನ್ನಡ', english: 'Kannada', dir: 'ltr', group: 'world'),
  VxLocaleInfo(code: 'ml', native: 'മലയാളം', english: 'Malayalam', dir: 'ltr', group: 'world'),
  VxLocaleInfo(code: 'pa', native: 'ਪੰਜਾਬੀ', english: 'Punjabi', dir: 'ltr', group: 'world'),
  VxLocaleInfo(code: 'si', native: 'සිංහල', english: 'Sinhala', dir: 'ltr', group: 'world'),
  VxLocaleInfo(code: 'ne', native: 'नेपाली', english: 'Nepali', dir: 'ltr', group: 'world'),
  VxLocaleInfo(code: 'km', native: 'ខ្មែរ', english: 'Khmer', dir: 'ltr', group: 'world'),
  VxLocaleInfo(code: 'lo', native: 'ລາວ', english: 'Lao', dir: 'ltr', group: 'world'),
  VxLocaleInfo(code: 'my', native: 'မြန်မာ', english: 'Burmese', dir: 'ltr', group: 'world'),
  VxLocaleInfo(code: 'mn', native: 'Монгол', english: 'Mongolian', dir: 'ltr', group: 'world'),
  VxLocaleInfo(code: 'ka', native: 'ქართული', english: 'Georgian', dir: 'ltr', group: 'world'),
  VxLocaleInfo(code: 'hy', native: 'Հայերեն', english: 'Armenian', dir: 'ltr', group: 'world'),
  VxLocaleInfo(code: 'az', native: 'Azərbaycan', english: 'Azerbaijani', dir: 'ltr', group: 'world'),
  VxLocaleInfo(code: 'kk', native: 'Қазақ', english: 'Kazakh', dir: 'ltr', group: 'world'),
  VxLocaleInfo(code: 'uz', native: 'Oʻzbek', english: 'Uzbek', dir: 'ltr', group: 'world'),
  VxLocaleInfo(code: 'he', native: 'עברית', english: 'Hebrew', dir: 'rtl', group: 'world'),
  VxLocaleInfo(code: 'fa', native: 'فارسی', english: 'Persian', dir: 'rtl', group: 'world'),
  VxLocaleInfo(code: 'ur', native: 'اردو', english: 'Urdu', dir: 'rtl', group: 'world'),
  VxLocaleInfo(code: 'sw', native: 'Kiswahili', english: 'Swahili', dir: 'ltr', group: 'world'),
  VxLocaleInfo(code: 'af', native: 'Afrikaans', english: 'Afrikaans', dir: 'ltr', group: 'world'),
  VxLocaleInfo(code: 'am', native: 'አማርኛ', english: 'Amharic', dir: 'ltr', group: 'world'),
  VxLocaleInfo(code: 'ha', native: 'Hausa', english: 'Hausa', dir: 'ltr', group: 'world'),
  VxLocaleInfo(code: 'yo', native: 'Yorùbá', english: 'Yoruba', dir: 'ltr', group: 'world'),
  VxLocaleInfo(code: 'zu', native: 'isiZulu', english: 'Zulu', dir: 'ltr', group: 'world'),
];

VxLocaleInfo vxLocaleInfo(String code) {
  return vxLocales.firstWhere(
    (l) => l.code == code,
    orElse: () => vxLocales.first,
  );
}

String vxLocaleCodeFromParts(String languageCode, String? countryCode) {
  if (languageCode == 'zh' && countryCode == 'TW') return 'zh-TW';
  return languageCode;
}
