import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vortexsales/data/mock/mock_data.dart';

class StoreController extends ChangeNotifier {
  StoreController()
      : catalog = List.of(seedCatalog),
        knowledge = List.of(seedKnowledge),
        bookings = List.of(seedBookings),
        leads = List.of(seedLeads);

  static const _key = 'vx_store_v1';

  List<CatalogItem> catalog;
  List<KnowledgeItem> knowledge;
  List<BookingItem> bookings;
  List<LeadItem> leads;
  bool ready = false;

  String _id(String prefix) =>
      '${prefix}_${DateTime.now().microsecondsSinceEpoch.toRadixString(36)}';

  int chunksOf(String body) =>
      (body.trim().split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length / 8)
          .ceil()
          .clamp(1, 999);

  Future<void> load() async {
    final p = await SharedPreferences.getInstance();
    final raw = p.getString(_key);
    if (raw != null) {
      try {
        final parsed = json.decode(raw) as Map<String, dynamic>;
        catalog = _parseList(parsed['catalog'], CatalogItem.fromJson) ??
            List.of(seedCatalog);
        knowledge = _parseList(parsed['knowledge'], KnowledgeItem.fromJson) ??
            List.of(seedKnowledge);
        bookings = _parseList(parsed['bookings'], BookingItem.fromJson) ??
            List.of(seedBookings);
        leads = _parseList(parsed['leads'], LeadItem.fromJson) ??
            List.of(seedLeads);
      } catch (_) {
        /* keep seed */
      }
    }
    ready = true;
    notifyListeners();
  }

  List<T>? _parseList<T>(
    Object? raw,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    if (raw is! List) return null;
    return [
      for (final row in raw)
        if (row is Map<String, dynamic>) fromJson(row),
    ];
  }

  Future<void> _persist() async {
    final p = await SharedPreferences.getInstance();
    await p.setString(
      _key,
      json.encode({
        'catalog': catalog.map((e) => e.toJson()).toList(),
        'knowledge': knowledge.map((e) => e.toJson()).toList(),
        'bookings': bookings.map((e) => e.toJson()).toList(),
        'leads': leads.map((e) => e.toJson()).toList(),
      }),
    );
  }

  void upsertCatalog(CatalogItem item, {bool isNew = false}) {
    if (isNew) {
      catalog = [item, ...catalog.where((e) => e.sku != item.sku)];
    } else {
      catalog = catalog.map((e) => e.sku == item.sku ? item : e).toList();
    }
    notifyListeners();
    _persist();
  }

  void removeCatalog(String sku) {
    catalog = catalog.where((e) => e.sku != sku).toList();
    notifyListeners();
    _persist();
  }

  void upsertKnowledge(KnowledgeItem item, {bool isNew = false}) {
    if (isNew) {
      item.id = _id('k');
      knowledge = [item, ...knowledge];
    } else {
      knowledge = knowledge.map((e) => e.id == item.id ? item : e).toList();
    }
    notifyListeners();
    _persist();
  }

  void removeKnowledge(String id) {
    knowledge = knowledge.where((e) => e.id != id).toList();
    notifyListeners();
    _persist();
  }

  void upsertBooking(BookingItem item, {bool isNew = false}) {
    if (isNew) {
      item.id = _id('b');
      bookings = [item, ...bookings];
    } else {
      bookings = bookings.map((e) => e.id == item.id ? item : e).toList();
    }
    notifyListeners();
    _persist();
  }

  void removeBooking(String id) {
    bookings = bookings.where((e) => e.id != id).toList();
    notifyListeners();
    _persist();
  }

  void upsertLead(LeadItem item, {bool isNew = false}) {
    if (isNew) {
      item.id = _id('l');
      leads = [item, ...leads];
    } else {
      leads = leads.map((e) => e.id == item.id ? item : e).toList();
    }
    notifyListeners();
    _persist();
  }

  void removeLead(String id) {
    leads = leads.where((e) => e.id != id).toList();
    notifyListeners();
    _persist();
  }
}

class StoreScope extends InheritedNotifier<StoreController> {
  const StoreScope({
    super.key,
    required StoreController store,
    required super.child,
  }) : super(notifier: store);

  static StoreController of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<StoreScope>()!.notifier!;
}
