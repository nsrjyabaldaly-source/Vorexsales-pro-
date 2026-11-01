import 'package:flutter/material.dart';
import 'package:vortexsales/core/l10n/vx_l10n.dart';
import 'package:vortexsales/core/search/vx_match.dart';
import 'package:vortexsales/core/state/store_controller.dart';
import 'package:vortexsales/core/theme/vx_colors.dart';
import 'package:vortexsales/core/widgets/vx_currency_field.dart';
import 'package:vortexsales/core/widgets/vx_field.dart';
import 'package:vortexsales/core/widgets/vx_glass.dart';
import 'package:vortexsales/core/widgets/vx_page_header.dart';
import 'package:vortexsales/core/widgets/vx_store_form.dart';
import 'package:vortexsales/data/mock/mock_data.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key, this.query = '', this.coachKey});

  final String query;
  final Key? coachKey;

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  CatalogItem? _form;
  bool _isNew = false;

  @override
  Widget build(BuildContext context) {
    final t = VxL10n.of(context);
    final store = StoreScope.of(context);
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        KeyedSubtree(
          key: widget.coachKey,
          child: VxPageHeader(
            title: t.catalogTitle,
            subtitle: t.catalogSub,
            note: t.storeNote,
            actionLabel: t.add,
            onAction: () => setState(() {
              _isNew = true;
              _form = CatalogItem(
                sku: '',
                name: '',
                nameAr: '',
                price: 0,
                currency: 'USD',
                duration: 0,
                stock: 'Bookable',
              );
            }),
          ),
        ),
        if (_form != null) ...[
          const SizedBox(height: 16),
          VxStoreForm(
            key: ObjectKey(_form),
            onCancel: () => setState(() => _form = null),
            onSave: () {
              if (_form!.sku.trim().isEmpty || _form!.name.trim().isEmpty) return;
              store.upsertCatalog(_form!, isNew: _isNew);
              setState(() => _form = null);
            },
            children: [
              VxField(label: t.sku, child: VxTextField(initialValue: _form!.sku, onChanged: (v) => _form!.sku = v)),
              VxField(label: t.nameLabel, child: VxTextField(initialValue: _form!.name, onChanged: (v) => _form!.name = v)),
              VxField(label: t.nameAr, child: VxTextField(initialValue: _form!.nameAr, onChanged: (v) => _form!.nameAr = v)),
              VxField(
                label: t.price,
                child: VxTextField(
                  initialValue: '${_form!.price}',
                  keyboardType: TextInputType.number,
                  onChanged: (v) => _form!.price = double.tryParse(v) ?? 0,
                ),
              ),
              VxField(
                label: t.currency,
                child: VxCurrencyField(
                  value: _form!.currency,
                  onChanged: (v) => setState(() => _form!.currency = v),
                ),
              ),
              VxField(
                label: t.duration,
                child: VxTextField(
                  initialValue: '${_form!.duration}',
                  keyboardType: TextInputType.number,
                  onChanged: (v) => _form!.duration = int.tryParse(v) ?? 0,
                ),
              ),
              VxField(label: t.stock, child: VxTextField(initialValue: _form!.stock, onChanged: (v) => _form!.stock = v)),
            ],
          ),
        ],
        const SizedBox(height: 16),
        if (store.catalog.isEmpty)
          Text(t.empty, style: const TextStyle(color: VxColors.mist500)),
        for (final item in store.catalog.where(
          (e) => vxMatches(widget.query, [e.sku, e.name, e.nameAr, e.stock]),
        ))
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: VxGlass(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.sku, style: const TextStyle(fontSize: 12, color: VxColors.cyan)),
                  const SizedBox(height: 6),
                  Text(t.isAr ? item.nameAr : item.name, style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 8),
                  Text(
                    '${item.price} ${item.currency} · ${item.duration}m · ${item.stock}',
                    style: const TextStyle(fontSize: 13, color: VxColors.mist400),
                  ),
                  VxRowActions(
                    onEdit: () => setState(() {
                      _isNew = false;
                      _form = CatalogItem(
                        sku: item.sku,
                        name: item.name,
                        nameAr: item.nameAr,
                        price: item.price,
                        currency: item.currency,
                        duration: item.duration,
                        stock: item.stock,
                      );
                    }),
                    onRemove: () => store.removeCatalog(item.sku),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
