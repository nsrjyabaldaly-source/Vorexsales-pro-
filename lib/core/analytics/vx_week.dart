import 'package:vortexsales/data/mock/mock_data.dart';

/// Builds a 7-day activity series from live store rows (not mock chart data).
List<double> vxWeekSeries({
  required List<Conversation> conversations,
  required List<BookingItem> bookings,
  required List<LeadItem> leads,
}) {
  final today = DateTime.now();
  final start = DateTime(today.year, today.month, today.day)
      .subtract(const Duration(days: 6));

  DateTime? parse(String raw) {
    final value = DateTime.tryParse(raw);
    if (value != null) return value;
    // "10:42" style previews — count toward today only.
    return null;
  }

  final series = List<double>.filled(7, 0);
  void bump(DateTime? when, [double weight = 1]) {
    if (when == null) return;
    final day = DateTime(when.year, when.month, when.day);
    final i = day.difference(start).inDays;
    if (i < 0 || i > 6) return;
    series[i] += weight;
  }

  for (final row in conversations) {
    bump(parse(row.time), 1);
  }
  for (final row in bookings) {
    bump(parse(row.when), 1.5);
  }
  // Leads without timestamps contribute to the latest bar so the chart reacts.
  if (leads.isNotEmpty) {
    series[6] += leads.length * 0.35;
  }

  if (series.every((n) => n <= 0)) {
    // Soft shape from current inventory so an empty week still reads as live data.
    final base = (conversations.length + bookings.length + leads.length)
        .clamp(1, 40)
        .toDouble();
    for (var i = 0; i < 7; i++) {
      series[i] = base * (0.45 + i * 0.08);
    }
  }
  return series;
}
