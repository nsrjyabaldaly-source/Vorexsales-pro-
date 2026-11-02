import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vortexsales/core/api/vx_api_client.dart';
import 'package:vortexsales/core/api/vx_api_config.dart';
import 'package:vortexsales/core/api/vx_store_api.dart';
import 'package:vortexsales/core/notify/vx_notify.dart';
import 'package:vortexsales/data/mock/mock_data.dart';

class StoreController extends ChangeNotifier {
  StoreController({VxStoreApi? api, this.onSessionExpired})
      : _api = api ?? VxStoreApi(),
        catalog = List.of(seedCatalog),
        knowledge = List.of(seedKnowledge),
        bookings = List.of(seedBookings),
        leads = List.of(seedLeads),
        conversations = seedConversations.map((e) => Conversation.fromJson(e.toJson())).toList();

  static const _key = 'vx_store_v1';
  static const _demoKey = 'vx_store_demo_v1';

  final VxStoreApi _api;
  final Future<void> Function()? onSessionExpired;
  bool demoMode = false;
  List<CatalogItem> catalog;
  List<KnowledgeItem> knowledge;
  List<BookingItem> bookings;
  List<LeadItem> leads;
  List<Conversation> conversations;
  bool ready = false;
  bool live = false;
  bool ar = false;

  String _id(String prefix) =>
      '${prefix}_${DateTime.now().microsecondsSinceEpoch.toRadixString(36)}';

  int chunksOf(String body) =>
      (body.trim().split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length / 8)
          .ceil()
          .clamp(1, 999);

  Future<void> load({bool demo = false}) async {
    demoMode = demo;
    await _readCache();
    ready = true;
    notifyListeners();
    await refresh();
  }

  Future<void> refresh() async {
    if (!VxApiConfig.configured) {
      live = false;
      notifyListeners();
      return;
    }
    try {
      final prefs = await SharedPreferences.getInstance();
      ar = (prefs.getString('vx.locale') ?? '').startsWith('ar');
      final remote = await Future.wait([
        _api.catalog(),
        _api.knowledge(),
        _api.bookings(),
        _api.leads(),
        _api.inbox(),
      ]);
      catalog = remote[0] as List<CatalogItem>;
      knowledge = remote[1] as List<KnowledgeItem>;
      bookings = remote[2] as List<BookingItem>;
      leads = remote[3] as List<LeadItem>;
      conversations = remote[4] as List<Conversation>;
      live = true;
      await _persist();
      try {
        await VxNotify.sync(
          conversations: conversations,
          bookings: bookings,
          ar: ar,
        );
      } catch (_) {}
      notifyListeners();
    } on VxApiException catch (e) {
      live = false;
      if (e.status == 401) {
        await onSessionExpired?.call();
      }
      notifyListeners();
    } catch (_) {
      live = false;
      notifyListeners();
    }
  }

  Future<void> _readCache() async {
    final p = await SharedPreferences.getInstance();
    final raw = p.getString(demoMode ? _demoKey : _key);
    if (raw == null) return;
    try {
      final parsed = json.decode(raw) as Map<String, dynamic>;
      catalog = _parseList(parsed['catalog'], CatalogItem.fromJson) ?? catalog;
      knowledge =
          _parseList(parsed['knowledge'], KnowledgeItem.fromJson) ?? knowledge;
      bookings =
          _parseList(parsed['bookings'], BookingItem.fromJson) ?? bookings;
      leads = _parseList(parsed['leads'], LeadItem.fromJson) ?? leads;
      conversations =
          _parseList(parsed['conversations'], Conversation.fromJson) ??
              conversations;
    } catch (_) {
      /* keep seed */
    }
  }

  List<T>? _parseList<T>(
    Object? raw,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    if (raw is! List) return null;
    return [
      for (final row in raw)
        if (row is Map) fromJson(Map<String, dynamic>.from(row)),
    ];
  }

  Future<void> _persist() async {
    final p = await SharedPreferences.getInstance();
    await p.setString(
      demoMode ? _demoKey : _key,
      json.encode({
        'catalog': catalog.map((e) => e.toJson()).toList(),
        'knowledge': knowledge.map((e) => e.toJson()).toList(),
        'bookings': bookings.map((e) => e.toJson()).toList(),
        'leads': leads.map((e) => e.toJson()).toList(),
        'conversations': conversations.map((e) => e.toJson()).toList(),
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
    _run(() => _api.saveCatalog(item));
  }

  void removeCatalog(String sku) {
    catalog = catalog.where((e) => e.sku != sku).toList();
    notifyListeners();
    _persist();
    _run(() => _api.deleteCatalog(sku));
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
    _run(() => _api.saveKnowledge(item));
  }

  void removeKnowledge(String id) {
    knowledge = knowledge.where((e) => e.id != id).toList();
    notifyListeners();
    _persist();
    _run(() => _api.deleteKnowledge(id));
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
    _run(() => _api.saveBooking(item));
  }

  void removeBooking(String id) {
    bookings = bookings.where((e) => e.id != id).toList();
    notifyListeners();
    _persist();
    _run(() => _api.deleteBooking(id));
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
    _run(() => _api.saveLead(item));
  }

  void removeLead(String id) {
    leads = leads.where((e) => e.id != id).toList();
    notifyListeners();
    _persist();
    _run(() => _api.deleteLead(id));
  }

  int get needsYouCount =>
      conversations.where((c) => c.status == 'needs_you').length;

  Future<void> replyInbox(String id, String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;
    final line = ChatLine(
      id: _id('m'),
      role: 'merchant',
      content: trimmed,
    );
    conversations = [
      for (final row in conversations)
        if (row.id == id)
          row.copyWith(
            preview: trimmed,
            time: 'now',
            status: 'needs_you',
            handedOff: true,
            messages: [...row.messages, line],
          )
        else
          row,
    ];
    notifyListeners();
    await _persist();
    _run(() => _api.replyInbox(id, trimmed));
  }

  Future<void> inboxAction(String id, String action) async {
    _run(() async {
      await _api.inboxAction(id, action);
      await refresh();
    });
  }

  void _run(Future<void> Function() task) {
    if (!VxApiConfig.configured) return;
    () async {
      try {
        await task();
        live = true;
      } catch (_) {
        live = false;
      }
      notifyListeners();
    }();
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
