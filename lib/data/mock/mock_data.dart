class Conversation {
  const Conversation({
    required this.id,
    required this.name,
    required this.market,
    required this.preview,
    required this.time,
    required this.status,
    required this.intent,
    required this.channel,
  });

  final String id;
  final String name;
  final String market;
  final String preview;
  final String time;
  final String status;
  final int intent;
  final String channel;
}

class CatalogItem {
  CatalogItem({
    required this.sku,
    required this.name,
    required this.nameAr,
    required this.price,
    required this.currency,
    required this.duration,
    required this.stock,
  });

  factory CatalogItem.fromJson(Map<String, dynamic> json) => CatalogItem(
        sku: json['sku'] as String? ?? '',
        name: json['name'] as String? ?? '',
        nameAr: json['nameAr'] as String? ?? '',
        price: (json['price'] as num?)?.toDouble() ?? 0,
        currency: json['currency'] as String? ?? 'USD',
        duration: (json['duration'] as num?)?.toInt() ?? 0,
        stock: json['stock'] as String? ?? '',
      );

  String sku;
  String name;
  String nameAr;
  double price;
  String currency;
  int duration;
  String stock;

  Map<String, dynamic> toJson() => {
        'sku': sku,
        'name': name,
        'nameAr': nameAr,
        'price': price,
        'currency': currency,
        'duration': duration,
        'stock': stock,
      };
}

class KnowledgeItem {
  KnowledgeItem({
    required this.id,
    required this.title,
    required this.type,
    required this.body,
    required this.chunks,
    required this.status,
    required this.updated,
  });

  factory KnowledgeItem.fromJson(Map<String, dynamic> json) => KnowledgeItem(
        id: json['id'] as String? ?? '',
        title: json['title'] as String? ?? '',
        type: json['type'] as String? ?? 'Text',
        body: json['body'] as String? ?? '',
        chunks: (json['chunks'] as num?)?.toInt() ?? 1,
        status: json['status'] as String? ?? 'ready',
        updated: json['updated'] as String? ?? '',
      );

  String id;
  String title;
  String type;
  String body;
  int chunks;
  String status;
  String updated;

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'type': type,
        'body': body,
        'chunks': chunks,
        'status': status,
        'updated': updated,
      };
}

class BookingItem {
  BookingItem({
    required this.id,
    required this.who,
    required this.service,
    required this.when,
    required this.zone,
    required this.status,
  });

  factory BookingItem.fromJson(Map<String, dynamic> json) => BookingItem(
        id: json['id'] as String? ?? '',
        who: json['who'] as String? ?? '',
        service: json['service'] as String? ?? '',
        when: json['when'] as String? ?? '',
        zone: json['zone'] as String? ?? '',
        status: json['status'] as String? ?? 'pending',
      );

  String id;
  String who;
  String service;
  String when;
  String zone;
  String status;

  Map<String, dynamic> toJson() => {
        'id': id,
        'who': who,
        'service': service,
        'when': when,
        'zone': zone,
        'status': status,
      };
}

class LeadItem {
  LeadItem({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.stage,
    required this.source,
    required this.value,
    required this.currency,
  });

  factory LeadItem.fromJson(Map<String, dynamic> json) => LeadItem(
        id: json['id'] as String? ?? '',
        name: json['name'] as String? ?? '',
        email: json['email'] as String? ?? '',
        phone: json['phone'] as String? ?? '',
        stage: json['stage'] as String? ?? 'new',
        source: json['source'] as String? ?? '',
        value: (json['value'] as num?)?.toDouble() ?? 0,
        currency: json['currency'] as String? ?? 'USD',
      );

  String id;
  String name;
  String email;
  String phone;
  String stage;
  String source;
  double value;
  String currency;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'phone': phone,
        'stage': stage,
        'source': source,
        'value': value,
        'currency': currency,
      };
}

class TeamMember {
  const TeamMember({required this.name, required this.role, required this.loc});
  final String name;
  final String role;
  final String loc;
}

abstract final class MockStats {
  static const conversations = 1284;
  static const conversationsDelta = 18.4;
  static const booked = 96;
  static const bookedDelta = 12.1;
  static const leads = 214;
  static const leadsDelta = 9.6;
  static const intent = 41;
  static const intentDelta = 3.2;
  static const weekSeries = [42.0, 58.0, 51.0, 77.0, 69.0, 91.0, 104.0];
}

const mockConversations = [
  Conversation(
    id: 'c1',
    name: 'Amelia Berg',
    market: 'Stockholm',
    preview: 'Do you have the navy coat in 36?',
    time: '2m',
    status: 'open',
    intent: 86,
    channel: 'Widget',
  ),
  Conversation(
    id: 'c2',
    name: 'يوسف الحمادي',
    market: 'Dubai',
    preview: 'أبي موعد تنظيف يوم الخميس بعد العصر',
    time: '11m',
    status: 'booked',
    intent: 94,
    channel: 'Widget',
  ),
  Conversation(
    id: 'c3',
    name: 'Camila Rojas',
    market: 'Lisbon',
    preview: 'Can we tour the riverside loft Saturday?',
    time: '28m',
    status: 'needs_you',
    intent: 71,
    channel: 'Playground',
  ),
  Conversation(
    id: 'c4',
    name: 'Kenji Sato',
    market: 'Osaka',
    preview: "What's included in the annual wellness plan?",
    time: '1h',
    status: 'open',
    intent: 63,
    channel: 'Widget',
  ),
  Conversation(
    id: 'c5',
    name: 'Nora Al-Farsi',
    market: 'Muscat',
    preview: 'Is the whitening session safe during pregnancy?',
    time: '3h',
    status: 'needs_you',
    intent: 58,
    channel: 'Widget',
  ),
];

final seedCatalog = [
  CatalogItem(
    sku: 'CLN-45',
    name: 'Dental cleaning',
    nameAr: 'تنظيف أسنان',
    price: 95,
    currency: 'USD',
    duration: 45,
    stock: 'Bookable',
  ),
  CatalogItem(
    sku: 'WHT-60',
    name: 'Whitening session',
    nameAr: 'جلسة تبييض',
    price: 280,
    currency: 'USD',
    duration: 60,
    stock: 'Bookable',
  ),
  CatalogItem(
    sku: 'COAT-NVY',
    name: 'Navy structured coat',
    nameAr: 'معطف كحلي',
    price: 240,
    currency: 'EUR',
    duration: 0,
    stock: '12',
  ),
  CatalogItem(
    sku: 'LOFT-RIO',
    name: 'Riverside loft tour',
    nameAr: 'معاينة لوفت النهر',
    price: 0,
    currency: 'EUR',
    duration: 20,
    stock: 'Bookable',
  ),
];

final seedKnowledge = [
  KnowledgeItem(
    id: 'k1',
    title: 'Clinic FAQ · Luna Dental',
    type: 'FAQ',
    body: 'Cleaning is 45 minutes. Whitening is not offered in the first trimester.',
    chunks: 42,
    status: 'ready',
    updated: 'Today',
  ),
  KnowledgeItem(
    id: 'k2',
    title: 'Retail catalog 2026',
    type: 'CSV',
    body: 'Navy coat ships in 3 days. Size 36 is in stock this week.',
    chunks: 128,
    status: 'ready',
    updated: 'Yesterday',
  ),
  KnowledgeItem(
    id: 'k3',
    title: 'After-hours policy',
    type: 'Doc',
    body: 'Bookings after 8pm are confirmed the next morning.',
    chunks: 11,
    status: 'pending',
    updated: '2d ago',
  ),
];

final seedBookings = [
  BookingItem(
    id: 'b1',
    who: 'يوسف الحمادي',
    service: 'Dental cleaning · 45m',
    when: '2026-11-06T13:00:00+04:00',
    zone: 'Asia/Dubai',
    status: 'confirmed',
  ),
  BookingItem(
    id: 'b2',
    who: 'Elena Varga',
    service: 'Invisalign consult · 30m',
    when: '2026-11-06T16:30:00+04:00',
    zone: 'Asia/Dubai',
    status: 'confirmed',
  ),
  BookingItem(
    id: 'b3',
    who: 'Camila Rojas',
    service: 'Loft viewing · 20m',
    when: '2026-11-08T11:00:00+00:00',
    zone: 'Europe/Lisbon',
    status: 'pending',
  ),
];

final seedLeads = [
  LeadItem(
    id: 'l1',
    name: 'Amelia Berg',
    email: 'amelia@nordand.co',
    phone: '+46 70 112 90 14',
    stage: 'qualified',
    source: 'Retail widget',
    value: 240,
    currency: 'EUR',
  ),
  LeadItem(
    id: 'l2',
    name: 'Kenji Sato',
    email: 'kenji.sato@mail.co.jp',
    phone: '+81 90 4412 8831',
    stage: 'new',
    source: 'Clinic widget',
    value: 890,
    currency: 'USD',
  ),
  LeadItem(
    id: 'l3',
    name: 'Nora Al-Farsi',
    email: 'nora@oman.net',
    phone: '+968 9112 4400',
    stage: 'nurture',
    source: 'Clinic widget',
    value: 320,
    currency: 'USD',
  ),
];

const mockTeam = [
  TeamMember(name: 'Muhanad Vortex', role: 'Owner', loc: 'Dubai'),
  TeamMember(name: 'Sara Lind', role: 'Admin', loc: 'Stockholm'),
];
