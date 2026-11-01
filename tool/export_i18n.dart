import 'dart:convert';
import 'dart:io';

const amreka = r'D:\AMREKA2';
const outDir = r'D:\vorex mibile\assets\i18n';

const coreMap = {
  'langTitle': 'lang.title',
  'langSubtitle': 'lang.subtitle',
  'langSearch': 'lang.search',
  'langContinue': 'lang.continue',
  'skip': 'howto.skip',
  'next': 'howto.next',
  'back': 'howto.back',
  'start': 'howto.start',
  'replay': 'howto.replay',
  's1Title': 'howto.s1Title',
  's1Body': 'howto.s1Body',
  's2Title': 'howto.s2Title',
  's2Body': 'howto.s2Body',
  's3Title': 'howto.s3Title',
  's3Body': 'howto.s3Body',
  's4Title': 'howto.s4Title',
  's4Body': 'howto.s4Body',
  's5Title': 'howto.s5Title',
  's5Body': 'howto.s5Body',
  'overview': 'app.overview',
  'inbox': 'app.inbox',
  'playground': 'app.playground',
  'knowledge': 'app.knowledge',
  'catalog': 'app.catalog',
  'bookings': 'app.bookings',
  'leads': 'app.leads',
  'settings': 'app.settings',
  'search': 'app.search',
  'signIn': 'nav.signIn',
  'startNav': 'nav.start',
};

const screenMap = {
  'channels': 'app.channels',
  'sub': 'channels.subtitle',
  'ready': 'channels.connected',
  'later': 'channels.later',
  'widget': 'channels.widget',
  'widgetBody': 'channels.widgetBody',
  'laterBody': 'channels.laterBody',
  'isolate': 'channels.isolate',
  'brain': 'channels.brain',
  'open': 'channels.openWidget',
  'connect': 'channels.connect',
  'hello': 'dashboard.hello',
  'dashSub': 'dashboard.sub',
  'conv': 'dashboard.conversations',
  'booked': 'dashboard.booked',
  'newLeads': 'dashboard.leads',
  'intent': 'dashboard.closeRate',
  'week': 'dashboard.week',
  'recent': 'dashboard.recent',
  'upcoming': 'dashboard.upcoming',
  'top': 'dashboard.top',
  'publicName': 'settings.publicName',
  'market': 'settings.market',
  'embed': 'settings.embed',
  'billingNote': 'settings.billingNote',
  'planBlurb': 'settings.planBlurb',
  'inboxTitle': 'inbox.title',
  'catalogTitle': 'catalog.title',
};

const restMap = {
  'name': 'catalog.name',
  'price': 'catalog.price',
  'duration': 'catalog.duration',
  'stock': 'catalog.stock',
  'contact': 'leads.contact',
  'stage': 'leads.stage',
  'value': 'leads.value',
  'intent': 'inbox.intent',
  'reply': 'inbox.replyLocked',
  'chunks': 'knowledge.chunks',
  'confirmed': 'bookings.confirmed',
  'pending': 'bookings.pending',
  'quota': 'app.quota',
  'used': 'app.quotaUsed',
  'widget': 'app.widget',
  'plan': 'settings.planName',
  'next': 'coach.next',
  'skip': 'coach.skip',
  'done': 'coach.done',
  'inbox': 'coach.inbox',
  'channels': 'coach.channels',
  'catalog': 'coach.catalog',
};

const storeMap = {
  'add': 'store.add',
  'save': 'store.save',
  'cancel': 'store.cancel',
  'remove': 'store.remove',
  'empty': 'store.empty',
  'note': 'store.note',
  'edit': 'store.edit',
  'who': 'store.who',
  'service': 'store.service',
  'when': 'store.when',
  'zone': 'store.zone',
  'email': 'store.email',
  'phone': 'store.phone',
  'source': 'store.source',
  'body': 'store.body',
  'type': 'store.type',
  'currency': 'store.currency',
  'title': 'store.title',
  'status': 'store.status',
  'nameAr': 'store.nameAr',
  'neu': 'leads.new',
  'qualified': 'leads.qualified',
  'nurture': 'leads.nurture',
};

void main() {
  Directory(outDir).createSync(recursive: true);
  final en = jsonDecode(File('$amreka\\messages\\en.json').readAsStringSync()) as Map<String, dynamic>;
  final ar = jsonDecode(File('$amreka\\messages\\ar.json').readAsStringSync()) as Map<String, dynamic>;

  final packs = <String, Map<String, String>>{};
  void add(String code, Map<String, String> flat) {
    packs.putIfAbsent(code, () => {});
    packs[code]!.addAll(flat);
  }

  for (final e in parseCalls('$amreka\\i18n\\core-packs.ts', 'pack').entries) {
    final flat = mapKeys(e.value, coreMap);
    flat['nav.playground'] = e.value['playground'] ?? flat['nav.playground'] ?? '';
    flat.removeWhere((_, v) => v.isEmpty);
    add(e.key, flat);
  }
  for (final e in parseCalls('$amreka\\i18n\\screen-packs.ts', 'ui').entries) {
    final flat = mapKeys(e.value, screenMap);
    if (e.value['channels'] != null) {
      flat['channels.title'] = e.value['channels']!;
      flat['settings.channels'] = e.value['channels']!;
    }
    add(e.key, flat);
  }
  for (final e in parseCalls('$amreka\\i18n\\rest-packs.ts', 'rest').entries) {
    final flat = mapKeys(e.value, restMap);
    if (e.value['name'] != null) flat['leads.name'] = e.value['name']!;
    add(e.key, flat);
  }
  for (final e in parseCalls('$amreka\\i18n\\store-packs.ts', 'pack').entries) {
    add(e.key, mapKeys(e.value, storeMap));
  }
  for (final e in parseSettingsTabs('$amreka\\i18n\\screen-packs.ts').entries) {
    add(e.key, e.value);
  }

  final codes = RegExp(r'code: "([^"]+)"')
      .allMatches(File('$amreka\\i18n\\locales.ts').readAsStringSync())
      .map((m) => m.group(1)!)
      .toList();

  for (final code in codes) {
    Map<String, dynamic> base = jsonDecode(jsonEncode(en)) as Map<String, dynamic>;
    if (code == 'ar') base = deepMerge(base, ar);
    final overlay = packs[code];
    if (overlay != null && overlay.isNotEmpty) {
      base = deepMerge(base, unflatten(overlay));
    }
    File('$outDir\\$code.json').writeAsStringSync(jsonEncode(base));
    stdout.writeln('wrote $code');
  }
}

Map<String, String> mapKeys(Map<String, String> input, Map<String, String> mapping) {
  final out = <String, String>{};
  mapping.forEach((from, to) {
    final v = input[from];
    if (v != null) out[to] = v;
  });
  return out;
}

Map<String, Map<String, String>> parseCalls(String path, String fn) {
  final src = File(path).readAsStringSync();
  final re = RegExp('(?:^|\\n)  ([a-z]{2}(?:-TW)?):\\s*$fn\\(\\{', multiLine: true);
  final out = <String, Map<String, String>>{};
  for (final m in re.allMatches(src)) {
    final code = m.group(1)!;
    final start = m.end;
    final end = findMatching(src, start - 1);
    if (end < 0) continue;
    out[code] = parseProps(src.substring(start, end));
  }
  return out;
}

Map<String, Map<String, String>> parseSettingsTabs(String path) {
  final src = File(path).readAsStringSync();
  final block = RegExp(r'export const SETTINGS_TABS[\s\S]*?\n\};').firstMatch(src)?.group(0) ?? '';
  final re = RegExp(r'  ([a-z]{2}(?:-TW)?):\s*\["([^"]*)",\s*"([^"]*)",\s*"([^"]*)",\s*"([^"]*)"\]');
  final out = <String, Map<String, String>>{};
  for (final m in re.allMatches(block)) {
    out[m.group(1)!] = {
      'settings.agent': m.group(2)!,
      'settings.widget': m.group(3)!,
      'settings.team': m.group(4)!,
      'settings.billing': m.group(5)!,
    };
  }
  return out;
}

int findMatching(String src, int openBrace) {
  var depth = 0;
  for (var i = openBrace; i < src.length; i++) {
    final c = src[i];
    if (c == '{') depth++;
    if (c == '}') {
      depth--;
      if (depth == 0) return i;
    }
  }
  return -1;
}

Map<String, String> parseProps(String body) {
  final out = <String, String>{};
  final re = RegExp(r'(\w+)\s*:\s*"((?:\\.|[^"\\])*)"');
  for (final m in re.allMatches(body)) {
    out[m.group(1)!] = jsonDecode('"${m.group(2)!}"') as String;
  }
  return out;
}

Map<String, dynamic> unflatten(Map<String, String> flat) {
  final tree = <String, dynamic>{};
  flat.forEach((path, value) {
    final parts = path.split('.');
    Map<String, dynamic> node = tree;
    for (var i = 0; i < parts.length; i++) {
      final part = parts[i];
      if (i == parts.length - 1) {
        node[part] = value;
      } else {
        node[part] = (node[part] as Map<String, dynamic>?) ?? <String, dynamic>{};
        node = node[part] as Map<String, dynamic>;
      }
    }
  });
  return tree;
}

Map<String, dynamic> deepMerge(Map<String, dynamic> base, Map<String, dynamic> overlay) {
  final out = Map<String, dynamic>.from(base);
  overlay.forEach((key, value) {
    final existing = out[key];
    if (value is Map<String, dynamic> && existing is Map<String, dynamic>) {
      out[key] = deepMerge(existing, value);
    } else {
      out[key] = value;
    }
  });
  return out;
}
