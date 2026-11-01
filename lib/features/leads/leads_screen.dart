import 'package:flutter/material.dart';
import 'package:vortexsales/core/l10n/vx_l10n.dart';
import 'package:vortexsales/core/search/vx_match.dart';
import 'package:vortexsales/core/state/store_controller.dart';
import 'package:vortexsales/core/theme/vx_colors.dart';
import 'package:vortexsales/core/widgets/vx_currency_field.dart';
import 'package:vortexsales/core/widgets/vx_field.dart';
import 'package:vortexsales/core/widgets/vx_glass.dart';
import 'package:vortexsales/core/widgets/vx_page_header.dart';
import 'package:vortexsales/core/widgets/vx_pills.dart';
import 'package:vortexsales/core/widgets/vx_store_form.dart';
import 'package:vortexsales/data/mock/mock_data.dart';

class LeadsScreen extends StatefulWidget {
  const LeadsScreen({super.key, this.query = ''});

  final String query;

  @override
  State<LeadsScreen> createState() => _LeadsScreenState();
}

class _LeadsScreenState extends State<LeadsScreen> {
  LeadItem? _form;
  bool _isNew = false;

  String _stageLabel(VxL10n t, String stage) => switch (stage) {
        'qualified' => t.qualified,
        'nurture' => t.nurture,
        _ => t.stageNew,
      };

  @override
  Widget build(BuildContext context) {
    final t = VxL10n.of(context);
    final store = StoreScope.of(context);
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        VxPageHeader(
          title: t.leadsTitle,
          subtitle: t.leadsSub,
          note: t.storeNote,
          actionLabel: t.add,
          onAction: () => setState(() {
            _isNew = true;
            _form = LeadItem(
              id: '',
              name: '',
              email: '',
              phone: '',
              stage: 'new',
              source: 'Widget',
              value: 0,
              currency: 'USD',
            );
          }),
        ),
        if (_form != null) ...[
          const SizedBox(height: 16),
          VxStoreForm(
            key: ObjectKey(_form),
            onCancel: () => setState(() => _form = null),
            onSave: () {
              if (_form!.name.trim().isEmpty) return;
              store.upsertLead(_form!, isNew: _isNew);
              setState(() => _form = null);
            },
            children: [
              VxField(label: t.nameLabel, child: VxTextField(initialValue: _form!.name, onChanged: (v) => _form!.name = v)),
              VxField(label: t.email, child: VxTextField(initialValue: _form!.email, onChanged: (v) => _form!.email = v)),
              VxField(label: t.phone, child: VxTextField(initialValue: _form!.phone, onChanged: (v) => _form!.phone = v)),
              VxField(label: t.stage, child: VxTextField(initialValue: _form!.stage, onChanged: (v) => _form!.stage = v)),
              VxField(label: t.source, child: VxTextField(initialValue: _form!.source, onChanged: (v) => _form!.source = v)),
              VxField(
                label: t.value,
                child: VxTextField(
                  initialValue: '${_form!.value}',
                  keyboardType: TextInputType.number,
                  onChanged: (v) => _form!.value = double.tryParse(v) ?? 0,
                ),
              ),
              VxField(
                label: t.currency,
                child: VxCurrencyField(
                  value: _form!.currency,
                  onChanged: (v) => setState(() => _form!.currency = v),
                ),
              ),
            ],
          ),
        ],
        const SizedBox(height: 16),
        if (store.leads.isEmpty)
          Text(t.empty, style: const TextStyle(color: VxColors.mist500)),
        for (final lead in store.leads.where(
          (e) => vxMatches(widget.query, [e.name, e.email, e.phone, e.source]),
        ))
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: VxGlass(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(lead.name, style: const TextStyle(color: Colors.white, fontSize: 16)),
                      ),
                      VxPill(label: _stageLabel(t, lead.stage), cyan: lead.stage == 'qualified'),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text('${lead.email} · ${lead.phone}', style: const TextStyle(fontSize: 13, color: VxColors.mist400)),
                  const SizedBox(height: 4),
                  Text(
                    '${lead.value} ${lead.currency} · ${lead.source}',
                    style: const TextStyle(fontSize: 12, color: VxColors.mist500),
                  ),
                  VxRowActions(
                    onEdit: () => setState(() {
                      _isNew = false;
                      _form = LeadItem(
                        id: lead.id,
                        name: lead.name,
                        email: lead.email,
                        phone: lead.phone,
                        stage: lead.stage,
                        source: lead.source,
                        value: lead.value,
                        currency: lead.currency,
                      );
                    }),
                    onRemove: () => store.removeLead(lead.id),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
