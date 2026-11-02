import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:vortexsales/core/l10n/vx_locales.dart';

class VxL10n {
  const VxL10n({
    required this.locale,
    required this.info,
    required Map<String, dynamic> messages,
    required Map<String, dynamic> fallback,
  })  : _msg = messages,
        _en = fallback;

  final Locale locale;
  final VxLocaleInfo info;
  final Map<String, dynamic> _msg;
  final Map<String, dynamic> _en;

  bool get isAr => info.code == 'ar';
  bool get isRtl => info.isRtl;
  TextDirection get direction => isRtl ? TextDirection.rtl : TextDirection.ltr;

  static VxL10n of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_VxL10nScope>()!.l10n;

  static Future<Map<String, dynamic>> loadMessages(String code) async {
    Future<Map<String, dynamic>> read(String c) async {
      final raw = await rootBundle.loadString('assets/i18n/$c.json');
      return json.decode(raw) as Map<String, dynamic>;
    }

    try {
      return await read(code);
    } catch (_) {
      return read('en');
    }
  }

  String _s(String path, [Map<String, String>? vars]) {
    var value = _lookup(_msg, path) ?? _lookup(_en, path) ?? path;
    if (vars != null) {
      vars.forEach((k, v) => value = value.replaceAll('{$k}', v));
    }
    return value;
  }

  String? _lookup(Map<String, dynamic> map, String path) {
    dynamic cur = map;
    for (final part in path.split('.')) {
      if (cur is Map && cur.containsKey(part)) {
        cur = cur[part];
      } else {
        return null;
      }
    }
    return cur is String ? cur : null;
  }

  String get brandName => _s('brand.name');
  String get company => _s('brand.company');

  String get langTitle => _s('lang.title');
  String get langSubtitle => _s('lang.subtitle');
  String get langSearch => _s('lang.search');
  String get langContinue => _s('lang.continue');
  String get groupEn => _s('lang.groupEn');
  String get groupEu => _s('lang.groupEu');
  String get groupAr => _s('lang.groupAr');
  String get groupWorld => _s('lang.groupWorld');

  String get signInTitle => _s('auth.signInTitle');
  String get signInBody => _s('auth.signInBody');
  String get signUpTitle => _s('auth.signUpTitle');
  String get signUpBody => _s('auth.signUpBody');
  String get email => _s('auth.email');
  String get password => _s('auth.password');
  String get fullName => _s('auth.name');
  String get continueLabel => _s('auth.continue');
  String get demo => _s('auth.demo');
  String get or => _s('auth.or');
  String get noAccount => _s('auth.noAccount');
  String get hasAccount => _s('auth.hasAccount');
  String get createAccount => _s('auth.create');
  String get login => _s('auth.login');
  String get logout => _s('auth.logout');
  String get linkLive =>
      isAr ? 'متصل بالسيرفر' : 'Connected to server';
  String get linkOffline =>
      isAr ? 'أوفلاين — تعرض النسخة المحلية' : 'Offline — showing on-device copy';
  String get linkSession =>
      isAr ? 'انتهت الجلسة — ادخل من جديد' : 'Session expired — sign in again';
  String get suggestReply =>
      isAr ? 'اقترح رداً' : 'Suggest reply';
  String get exportData =>
      isAr ? 'تصدير الكتالوج والعملاء' : 'Export catalog & leads';
  String get openWhatsapp =>
      isAr ? 'افتح واتساب' : 'Open WhatsApp';
  String get demoBadge => isAr ? 'عرض تجريبي' : 'Demo';
  String get previewLocale =>
      isAr ? 'معاينة إنجليزي' : 'Preview Arabic';

  String get onboardTitle => _s('onboarding.title');
  String stepOf(int n) => _s('onboarding.step', {'n': '$n'});
  String get next => _s('onboarding.next');
  String get back => _s('onboarding.back');
  String get finish => _s('onboarding.finish');
  String get sellType => _s('onboarding.type');
  String get profile => _s('onboarding.profile');
  String get hours => _s('onboarding.hours');
  String get goLive => _s('onboarding.goLive');
  String get businessName => _s('onboarding.businessName');
  String get timezone => _s('onboarding.timezone');
  String get snippet => _s('onboarding.snippet');
  String get clinic => isAr ? 'عيادة وعافية' : 'Clinic & wellness';
  String get retail => isAr ? 'تجزئة' : 'Retail & D2C';
  String get services => isAr ? 'خدمات' : 'Agencies & services';
  String get property => isAr ? 'عقار' : 'Property';

  String get overview => _s('app.overview');
  String get inbox => _s('app.inbox');
  String get playground => _s('app.playground');
  String get knowledge => _s('app.knowledge');
  String get catalog => _s('app.catalog');
  String get bookings => _s('app.bookings');
  String get leads => _s('app.leads');
  String get channels => _s('app.channels');
  String get settings => _s('app.settings');
  String get more => isRtl ? 'المزيد' : 'More';
  String get search => _s('app.search');
  String get store => _s('app.store');
  String get online => _s('app.online');
  String get widget => _s('app.widget');
  String quota(int pct) => _s('app.quota', {'pct': '$pct'});
  String quotaUsed(String used, String limit) =>
      _s('app.quotaUsed', {'used': used, 'limit': limit});

  String get hello => _s('dashboard.hello');
  String get dashSub => _s('dashboard.sub');
  String get conversations => _s('dashboard.conversations');
  String get booked => _s('dashboard.booked');
  String get newLeads => _s('dashboard.leads');
  String get closeRate => _s('dashboard.closeRate');
  String get week => _s('dashboard.week');
  String get recent => _s('dashboard.recent');
  String get upcoming => _s('dashboard.upcoming');
  String get topSkus => _s('dashboard.top');

  String get inboxTitle => _s('inbox.title');
  String get openStatus => _s('inbox.open');
  String get bookedStatus => _s('inbox.booked');
  String get needsYou => _s('inbox.needsYou');
  String get intent => _s('inbox.intent');
  String get replyLocked => _s('inbox.replyLocked');
  String get inboxReply => _s('inbox.replyPlaceholder');
  String get inboxTeam => _s('inbox.team');
  String get inboxResume => _s('inbox.resume');
  String get inboxConfirm => _s('inbox.confirmSlot');
  String get inboxCancel => _s('inbox.cancelSlot');
  String get inboxHandedOff => _s('inbox.handedOff');

  String get playgroundTitle => _s('playground.title');
  String get playgroundSub => _s('playground.subtitle');
  String get tone => _s('playground.tone');
  String get language => _s('playground.language');
  String get instructions => _s('playground.instructions');
  String get askPlaceholder => _s('playground.placeholder');
  String get send => _s('playground.send');
  String get warm => _s('playground.warm');
  String get precise => _s('playground.precise');
  String get boldCloser => _s('playground.bold');
  String get localeChip => '${info.native} · ${info.dir.toUpperCase()}';
  String get mockHello => isAr
      ? 'أهلاً، معك مساعد Luna. تبي تنظيف، تبييض، ولا استشارة؟'
      : 'Hi — I’m Luna’s assistant. Cleaning, whitening, or a consult?';
  String get mockInstructions => isAr
      ? 'صوت المتجر: دافئ ومقنع. بع من قائمتنا فقط. إذا وافق الزبون، اطلب الاسم والرقم.'
      : 'Shop voice: warm and persuasive. Sell from our list only. If they agree, ask for name and phone.';

  String get knowledgeTitle => _s('knowledge.title');
  String get knowledgeSub => _s('knowledge.subtitle');
  String get upload => _s('knowledge.upload');
  String get ready => _s('knowledge.ready');
  String get pending => _s('knowledge.pending');
  String chunks(int n) => _s('knowledge.chunks', {'n': '$n'});

  String get catalogTitle => _s('catalog.title');
  String get catalogSub => _s('catalog.subtitle');
  String get sku => _s('catalog.sku');
  String get nameLabel => _s('catalog.name');
  String get price => _s('catalog.price');
  String get duration => _s('catalog.duration');
  String get stock => _s('catalog.stock');
  String get nameAr => _s('store.nameAr');

  String get bookingsTitle => _s('bookings.title');
  String get bookingsSub => _s('bookings.subtitle');
  String get confirmed => _s('bookings.confirmed');
  String get pendingLabel => _s('bookings.pending');

  String get leadsTitle => _s('leads.title');
  String get leadsSub => _s('leads.subtitle');
  String get contact => _s('leads.contact');
  String get stage => _s('leads.stage');
  String get value => _s('leads.value');
  String get stageNew => _s('leads.new');
  String get qualified => _s('leads.qualified');
  String get nurture => _s('leads.nurture');

  String get add => _s('store.add');
  String get save => _s('store.save');
  String get cancel => _s('store.cancel');
  String get remove => _s('store.remove');
  String get empty => _s('store.empty');
  String get storeNote => _s('store.note');
  String get storeOffline => _s('store.offline');
  String storeStatus(bool live) => live ? storeNote : storeOffline;
  String get edit => _s('store.edit');
  String get who => _s('store.who');
  String get service => _s('store.service');
  String get when => _s('store.when');
  String get zone => _s('store.zone');
  String get phone => _s('store.phone');
  String get source => _s('store.source');
  String get body => _s('store.body');
  String get type => _s('store.type');
  String get currency => _s('store.currency');
  String get commonCurrencies => isAr ? 'شائعة' : 'Common';
  String get allCurrencies => isAr ? 'كل العملات' : 'All currencies';
  String get dualMarkets =>
      isAr ? 'أسواق بأكثر من عملة' : 'Markets with more than one currency';
  String get currencySearch =>
      isAr ? 'ابحث بدولة أو عملة' : 'Search country or currency';
  String get titleField => _s('store.title');
  String get status => _s('store.status');

  String get settingsTitle => _s('settings.title');
  String get agent => _s('settings.agent');
  String get team => _s('settings.team');
  String get billing => _s('settings.billing');
  String get server => _s('settings.server');
  String get publicName => _s('settings.publicName');
  String get market => _s('settings.market');
  String get embed => _s('settings.embed');
  String get billingNote => _s('settings.billingNote');
  String get planBlurb => _s('settings.planBlurb');
  String get planName => _s('settings.planName');
  String get serverNote => _s('settings.serverNote');
  String get serverUrl => _s('settings.serverUrl');
  String get database => _s('settings.database');
  String get aiKey => _s('settings.aiKey');
  String get filled => _s('settings.filled');
  String get emptyPlaceholder => _s('settings.empty');
  String get provider => _s('settings.provider');
  String get mode => _s('settings.mode');
  String get checkConnection => isAr ? 'تحقق من الاتصال' : 'Check connection';
  String get keyStaysOnServer => isAr
      ? 'مفتاح الذكاء الاصطناعي يبقى على سيرفر الويب. التطبيق يقرأ الجاهزية من /api/health فقط.'
      : 'The AI key stays on the web server. This app only reads readiness from /api/health.';
  String get howtoSkip => _s('howto.skip');
  String get howtoNext => _s('howto.next');
  String get howtoBack => _s('howto.back');
  String get howtoStart => _s('howto.start');
  String howtoStep(int n, int total) =>
      _s('howto.step', {'n': '$n', 'total': '$total'});
  String howtoTitle(String key) => _s('howto.${key}Title');
  String howtoBody(String key) => _s('howto.${key}Body');
  String get replay => _s('howto.replay');

  String get coachNext => _s('coach.next');
  String get coachSkip => _s('coach.skip');
  String get coachDone => _s('coach.done');
  String coachCopy(String id) => _s('coach.$id');

  String get noMatches =>
      _lookup(_msg, 'app.noMatches') ??
      _lookup(_en, 'app.noMatches') ??
      (isAr ? 'لا نتائج' : 'No matches');

  String get channelsTitle => _s('channels.title');
  String get channelsSub => _s('channels.subtitle');
  String get connected => _s('channels.connected');
  String get later => _s('channels.later');
  String get channelWidget => _s('channels.widget');
  String get whatsapp => _s('channels.whatsapp');
  String get instagram => _s('channels.instagram');
  String get messenger => _s('channels.messenger');
  String get tiktok => _s('channels.tiktok');
  String get telegram => _s('channels.telegram');
  String get widgetBody => _s('channels.widgetBody');
  String get laterBody => _s('channels.laterBody');
  String get isolate => _s('channels.isolate');
  String get brain => _s('channels.brain');
  String get openWidget => _s('channels.openWidget');
  String get connect => _s('channels.connect');
  String get whatsappBody =>
      _lookup(_msg, 'channels.whatsappBody') ??
      _lookup(_en, 'channels.whatsappBody') ??
      (isAr
          ? 'مفاتيح واتساب تبقى على السيرفر. الرسائل تدخل نفس صندوق الويدجت.'
          : 'WhatsApp tokens stay on the server. Threads join the same inbox.');
  String get phoneId => isAr ? 'معرّف رقم واتساب' : 'WhatsApp phone number ID';
  String get accessToken => isAr ? 'رمز Cloud API' : 'Cloud API access token';
  String get verifyToken => isAr ? 'رمز التحقق' : 'Webhook verify token';
  String get webhookHint => isAr
      ? 'الويب هوك: /api/channels/whatsapp'
      : 'Webhook: /api/channels/whatsapp';
  String get saveWhatsapp => isAr ? 'احفظ واتساب' : 'Save WhatsApp';
  String get copySnippet => isAr ? 'انسخ المقطع' : 'Copy snippet';
  String get snippetCopied => isAr ? 'تم النسخ' : 'Copied';

  String get widgetHello => _s('widget.hello');
  String get widgetPlaceholder => _s('widget.placeholder');
  String get widgetOnline => _s('widget.online');
  String get previewKicker => _s('widget.previewKicker');
  String get previewTitle => _s('widget.previewTitle');
  String get previewBody => _s('widget.previewBody');
  String get typing => _s('chat.typing');
  String get moreMenu => isRtl ? 'المزيد من مساحة العمل' : 'More of the workspace';
}

class VxL10nHost extends StatelessWidget {
  const VxL10nHost({super.key, required this.l10n, required this.child});

  final VxL10n l10n;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return _VxL10nScope(l10n: l10n, child: child);
  }
}

class _VxL10nScope extends InheritedWidget {
  const _VxL10nScope({required this.l10n, required super.child});

  final VxL10n l10n;

  @override
  bool updateShouldNotify(_VxL10nScope oldWidget) =>
      l10n.info.code != oldWidget.l10n.info.code;
}
