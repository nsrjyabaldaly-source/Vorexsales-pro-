import 'package:share_plus/share_plus.dart';
import 'package:vortexsales/data/mock/mock_data.dart';

String vxCatalogCsv(List<CatalogItem> items) {
  final buf = StringBuffer('sku,name,name_ar,price,currency,stock\n');
  for (final item in items) {
    buf.writeln(
      [
        item.sku,
        item.name,
        item.nameAr,
        item.price,
        item.currency,
        item.stock,
      ].map(_csv).join(','),
    );
  }
  return buf.toString();
}

String vxLeadsCsv(List<LeadItem> items) {
  final buf = StringBuffer('name,email,phone,stage,source,value,currency\n');
  for (final item in items) {
    buf.writeln(
      [
        item.name,
        item.email,
        item.phone,
        item.stage,
        item.source,
        item.value,
        item.currency,
      ].map(_csv).join(','),
    );
  }
  return buf.toString();
}

String _csv(Object? value) {
  final raw = '$value'.replaceAll('"', '""');
  return '"$raw"';
}

Future<void> vxShareExport({
  required List<CatalogItem> catalog,
  required List<LeadItem> leads,
}) {
  final body = StringBuffer()
    ..writeln('VortexSales export')
    ..writeln()
    ..writeln('=== Catalog ===')
    ..writeln(vxCatalogCsv(catalog))
    ..writeln('=== Leads ===')
    ..writeln(vxLeadsCsv(leads));
  return SharePlus.instance.share(
    ShareParams(text: body.toString(), subject: 'VortexSales export'),
  );
}
