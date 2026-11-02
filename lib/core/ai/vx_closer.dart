import 'package:vortexsales/data/currencies/vx_currencies.dart';
import 'package:vortexsales/data/currencies/vx_fx.dart';
import 'package:vortexsales/data/mock/mock_data.dart';

class VxCloser {
  const VxCloser({
    required this.catalog,
    required this.knowledge,
    required this.ar,
  });

  final List<CatalogItem> catalog;
  final List<KnowledgeItem> knowledge;
  final bool ar;

  String reply(String input) {
    final q = input.trim();
    if (q.isEmpty) return _hello();

    if (_isHello(q) && !_wantsPrice(q) && !_wantsBook(q) && _matchCatalog(q) == null) {
      return _hello();
    }

    final item = _matchCatalog(q);
    final hasPhone = RegExp(r'(?:\+|00)?[1-9][\d\s\-()]{7,16}\d').hasMatch(q);
    final hasName = RegExp(r'اسمي\s+\p{L}+|my name is\s+\w+', unicode: true, caseSensitive: false)
        .hasMatch(q);
    final slot = _slot(q);
    if (slot != null) {
      return ar
          ? 'تمام، ثبّتّ الخميس $slot مبدئياً. الفريق يؤكد الموعد من الصندوق.'
          : 'Locked Thursday $slot tentatively. The team will confirm it from the inbox.';
    }
    if (item != null && _wantsBook(q) && hasName && hasPhone) {
      final name = ar ? (item.nameAr.isEmpty ? item.name : item.nameAr) : item.name;
      return ar
          ? 'تمام، ثبّتّ $name مبدئياً الخميس 1 الظهر. تبي 1:00 ولا 4:30؟ الفريق يتصل على الرقم اللي بعثته.'
          : 'Locked $name tentatively for Thursday 13:00. Prefer 13:00 or 16:30? The team will call the number you sent.';
    }
    if (item != null) return _quote(item, q);

    final fact = _matchKnowledge(q);
    if (fact != null) {
      return ar
          ? '${fact.body} تبي نرتّب أقرب وقت يناسبك؟'
          : '${fact.body} Want me to hold the next open slot?';
    }

    if (_wantsBook(q)) {
      if (hasName && hasPhone) {
        return ar
            ? 'تمام، ثبّتّ الزيارة مبدئياً الخميس 1 الظهر. تبي 1:00 ولا 4:30؟ الفريق يتصل على الرقم اللي بعثته.'
            : 'Locked the visit tentatively for Thursday 13:00. Prefer 13:00 or 16:30? The team will call the number you sent.';
      }
      return ar
          ? 'تمام. عندي الخميس 1:00 م و 4:30 م. أيهما أثبت؟ اكتب اسمك ورقم إذا حاب يتأكد الفريق.'
          : 'Thursday 13:00 or 16:30 — which should I lock? Send your name and number and I’ll confirm.';
    }

    if (catalog.isNotEmpty) {
      final a = catalog.first;
      final b = catalog.length > 1 ? catalog[1] : null;
      final aName = ar ? (a.nameAr.isEmpty ? a.name : a.nameAr) : a.name;
      final bName = b == null
          ? ''
          : (ar ? (b.nameAr.isEmpty ? b.name : b.nameAr) : b.name);
      return ar
          ? 'من قائمتنا الآن: $aName بـ ${a.price} ${a.currency}${b != null ? '، و$bName بـ ${b.price} ${b.currency}' : ''}. أيهم أقرب للي تبيه؟'
          : 'On our list: $aName at ${a.price} ${a.currency}${b != null ? ', and $bName at ${b.price} ${b.currency}' : ''}. Which is closer to what you need?';
    }

    return ar
        ? 'أبي أجاوبك من قائمتنا صح. تبحث عن ماذا؟ وإذا حاب الفريق يتابعك، اترك اسمك ورقم.'
        : 'I want to answer from our list, not guess. What are you looking for? Or leave a name and number.';
  }

  bool _isHello(String q) =>
      RegExp(r'^(hi|hello|hey|مرحبا|السلام|هلا|مساء|صباح)', caseSensitive: false)
          .hasMatch(q);

  bool _wantsPrice(String q) =>
      RegExp(
        r'price|cost|how much|كم|سعر|بكم|تكلفة|فلوس|riyal|rial|ريال|دولار|درهم',
        caseSensitive: false,
      ).hasMatch(q);

  bool _wantsBook(String q) =>
      RegExp(
        r'book|slot|appointment|موعد|حجز|خميس|thursday|lock',
        caseSensitive: false,
      ).hasMatch(q);

  String? _slot(String q) {
    final late = RegExp(r'4:30|16:30|العصر|الرابعة', caseSensitive: false).hasMatch(q);
    final early = RegExp(r'1:00|13:00|1 الظهر|الواحدة|الأولى', caseSensitive: false).hasMatch(q);
    if (late && !early) return ar ? '4:30 م' : '16:30';
    if (early && !late) return ar ? '1 الظهر' : '13:00';
    if (RegExp(r'^الظهر$').hasMatch(q.trim())) return ar ? '1 الظهر' : '13:00';
    return null;
  }

  CatalogItem? _matchCatalog(String q) {
    final n = q.toLowerCase();
    CatalogItem? best;
    var bestScore = 0;
    for (final item in catalog) {
      var score = 0;
      final fields = [item.sku, item.name, item.nameAr];
      for (final f in fields) {
        final t = f.toLowerCase();
        if (t.isNotEmpty && n.contains(t)) score += 5;
        for (final w in t.split(RegExp(r'[^a-z0-9\u0600-\u06ff]+'))) {
          if (w.length > 2 && n.contains(w)) score += 2;
        }
      }
      if (score > bestScore) {
        bestScore = score;
        best = item;
      }
    }
    return bestScore >= 2 ? best : null;
  }

  KnowledgeItem? _matchKnowledge(String q) {
    final n = q.toLowerCase();
    for (final doc in knowledge) {
      final hay = '${doc.title} ${doc.body}'.toLowerCase();
      if (n.split(RegExp(r'\s+')).any((w) => w.length > 3 && hay.contains(w))) {
        return doc;
      }
    }
    return null;
  }

  String _quote(CatalogItem item, String q) {
    final name = ar ? (item.nameAr.isEmpty ? item.name : item.nameAr) : item.name;
    final home = vxFormatMoney(item.price, item.currency);
    final mins = item.duration == 0
        ? ''
        : ar
            ? '، الجلسة ${item.duration} دقيقة'
            : ', ${item.duration} min';
    final lead = ar ? '$name بـ $home$mins.' : '$name is $home$mins.';

    if (vxRiyalAmbiguous(q)) {
      return ar
          ? '$lead أي ريال تقصد: اليمني، السعودي، ولا القطري؟'
          : '$lead Which riyal — Yemeni, Saudi, or Qatari?';
    }

    final extras = vxCompanionQuotes(q, item.currency);
    if (extras.isEmpty) {
      return ar
          ? '$lead تبي أحجز لك الخميس 1 الظهر أو 4:30؟'
          : '$lead Shall I hold Thursday 13:00 or 16:30?';
    }

    final lines = <String>[lead];
    for (final code in extras.take(3)) {
      final converted = vxConvert(item.price, item.currency, code);
      if (converted == null) {
        lines.add(
          ar
              ? 'ما عندي سعر صرف ثابت لـ $code، فالملزم يبقى $home.'
              : 'I don’t have a firm $code rate, so $home stays the binding price.',
        );
        continue;
      }
      final local = vxFormatMoney(converted, code);
      final cur = vxCurrencyByCode(code);
      if (vxIsPegged(code)) {
        lines.add(
          ar ? 'بال${cur.nameAr} تقريباً $local.' : 'In ${cur.nameEn} that’s about $local.',
        );
      } else {
        lines.add(
          ar
              ? 'تقريباً $local (${cur.nameAr}) — تحويل تقريبي، والملزم $home.'
              : 'About $local (${cur.nameEn}) — approximate FX; $home is binding.',
        );
      }
    }
    lines.add(
      ar ? 'تبي أحجز لك أقرب وقت؟' : 'Want me to hold the next slot?',
    );
    return lines.join('\n');
  }

  String _hello() {
    if (catalog.isEmpty) {
      return ar
          ? 'أهلاً، معك مساعد المتجر. كيف أقدر أساعدك؟'
          : 'Hi — I’m the shop assistant. How can I help?';
    }
    final a = catalog.first;
    final b = catalog.length > 1 ? catalog[1] : null;
    final aName = ar ? (a.nameAr.isEmpty ? a.name : a.nameAr) : a.name;
    final bName = b == null
        ? ''
        : (ar ? (b.nameAr.isEmpty ? b.name : b.nameAr) : b.name);
    return ar
        ? 'أهلاً، معك مساعد المتجر. تبي $aName${b != null ? ' ولا $bName' : ''}، ولا شيء ثاني؟'
        : 'Hi — I’m the shop assistant. Looking for $aName${b != null ? ' or $bName' : ''}, or something else?';
  }
}
