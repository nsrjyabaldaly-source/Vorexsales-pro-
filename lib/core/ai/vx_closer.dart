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

    if (_isHello(q) && !_wantsPrice(q) && !_wantsBook(q)) return _hello();

    final item = _matchCatalog(q);
    if (_wantsPrice(q)) {
      if (item == null) return _noPrice();
      return _quote(item, q);
    }

    final fact = _matchKnowledge(q);
    if (fact != null) {
      return ar ? 'من معرفة المتجر: ${fact.body}' : 'From this store’s knowledge: ${fact.body}';
    }

    if (item != null && _looksLikeProduct(q, item)) {
      return _quote(item, q);
    }

    if (_wantsBook(q)) {
      return ar
          ? 'تمام. أقرب أوقات عيادة لونا في دبي: الخميس 1:00 م و 4:30 م. أيهما تريد؟ السيرفر يثبت الموعد ويمنع التعارض.'
          : 'Next open slots at Luna Dental, Dubai: Thursday 13:00 and 16:30 Gulf time. Which one should I lock?';
    }

    return _noPrice();
  }

  bool _isHello(String q) =>
      RegExp(r'^(hi|hello|hey|مرحبا|السلام|هلا)\b', caseSensitive: false).hasMatch(q);

  bool _wantsPrice(String q) =>
      RegExp(r'price|cost|how much|كم|سعر|بكم|تكلفة|فلوس|riyal|rial|ريال|دولار|درهم', caseSensitive: false)
          .hasMatch(q);

  bool _wantsBook(String q) =>
      RegExp(r'book|slot|appointment|موعد|حجز|خميس|thursday', caseSensitive: false).hasMatch(q);

  bool _looksLikeProduct(String q, CatalogItem item) {
    final hay = '${item.sku} ${item.name} ${item.nameAr}'.toLowerCase();
    return q.toLowerCase().split(RegExp(r'\s+')).any((w) => w.length > 2 && hay.contains(w));
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
    final locked = ar
        ? 'من الكتالوج فقط: $name (${item.sku}) — $home.'
        : 'Catalog only: $name (${item.sku}) — $home.';

    if (vxRiyalAmbiguous(q)) {
      return ar
          ? '$locked أي ريال تقصد: اليمني أم السعودي أم القطري؟ لن أخمن.'
          : '$locked Which riyal do you mean — Yemeni, Saudi, or Qatari? I will not guess.';
    }

    final extras = vxCompanionQuotes(q, item.currency);
    if (extras.isEmpty) {
      return ar
          ? '$locked المدة ${item.duration} د. أقدر أحجز لك أقرب وقت.'
          : '$locked ${item.duration} min. I can hold the next open slot.';
    }

    final lines = <String>[locked];
    for (final code in extras.take(3)) {
      final converted = vxConvert(item.price, item.currency, code);
      if (converted == null) {
        lines.add(
          ar
              ? 'ما عندي سعر صرف ملزم لـ $code، فما راح أخترع رقماً.'
              : 'I do not have a binding $code rate, so I will not invent one.',
        );
        continue;
      }
      final local = vxFormatMoney(converted, code);
      final cur = vxCurrencyByCode(code);
      if (vxIsPegged(code)) {
        lines.add(
          ar
              ? 'بال${cur.nameAr}: $local (سعر مربوط).'
              : 'In ${cur.nameEn}: $local (pegged rate).',
        );
      } else {
        lines.add(
          ar
              ? 'تقريباً $local (${cur.nameAr}) — سعر تجريبي $vxFxAsOf، ليس سوقاً موازية. الملزم هو سعر الكتالوج.'
              : 'About $local (${cur.nameEn}) — demo rate $vxFxAsOf, not a street rate. The catalog amount is binding.',
        );
      }
    }
    lines.add(
      ar ? 'أقدر أحجز لك أقرب وقت.' : 'I can hold the next open slot.',
    );
    return lines.join('\n');
  }

  String _hello() => ar
      ? 'أهلاً بك في VortexSales. أساعد من الكتالوج والمعرفة فقط. اسأل عن سعر أو موعد — أحول للعملة المحلية بدون ما يكرر التاجر القطعة.'
      : 'Welcome to VortexSales. I only sell from this catalog. Ask a price — I convert to a local currency without duplicating the SKU.';

  String _noPrice() => ar
      ? 'ما لقيت سعراً في الكتالوج، فما راح أخمن. أقدر آخذ اسمك ورقمك ليتابعك الفريق.'
      : 'I don’t have that price in the catalog, so I will not invent one. I can take your name and number.';
}
