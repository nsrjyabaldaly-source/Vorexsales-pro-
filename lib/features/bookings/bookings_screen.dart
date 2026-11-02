import 'package:flutter/material.dart';
import 'package:vortexsales/core/l10n/vx_l10n.dart';
import 'package:vortexsales/core/search/vx_match.dart';
import 'package:vortexsales/core/state/store_controller.dart';
import 'package:vortexsales/core/theme/vx_colors.dart';
import 'package:vortexsales/core/widgets/vx_field.dart';
import 'package:vortexsales/core/widgets/vx_glass.dart';
import 'package:vortexsales/core/widgets/vx_page_header.dart';
import 'package:vortexsales/core/widgets/vx_pills.dart';
import 'package:vortexsales/core/widgets/vx_store_form.dart';
import 'package:vortexsales/data/mock/mock_data.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key, this.query = ''});

  final String query;

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  BookingItem? _form;
  bool _isNew = false;

  @override
  Widget build(BuildContext context) {
    final t = VxL10n.of(context);
    final store = StoreScope.of(context);
    return VxStoreScroll(
      onRefresh: store.refresh,
      children: [
        VxPageHeader(
          title: t.bookingsTitle,
          subtitle: t.bookingsSub,
          note: t.storeStatus(store.live),
          actionLabel: t.add,
          onAction: () => setState(() {
            _isNew = true;
            _form = BookingItem(
              id: '',
              who: '',
              service: '',
              when: DateTime.now().toIso8601String(),
              zone: 'Asia/Dubai',
              status: 'pending',
            );
          }),
        ),
        if (_form != null) ...[
          const SizedBox(height: 16),
          VxStoreForm(
            key: ObjectKey(_form),
            onCancel: () => setState(() => _form = null),
            onSave: () {
              if (_form!.who.trim().isEmpty) return;
              store.upsertBooking(_form!, isNew: _isNew);
              setState(() => _form = null);
            },
            children: [
              VxField(label: t.who, child: VxTextField(initialValue: _form!.who, onChanged: (v) => _form!.who = v)),
              VxField(label: t.service, child: VxTextField(initialValue: _form!.service, onChanged: (v) => _form!.service = v)),
              VxField(label: t.when, child: VxTextField(initialValue: _form!.when, onChanged: (v) => _form!.when = v)),
              VxField(label: t.zone, child: VxTextField(initialValue: _form!.zone, onChanged: (v) => _form!.zone = v)),
            ],
          ),
        ],
        const SizedBox(height: 16),
        if (store.bookings.isEmpty)
          Text(t.empty, style: const TextStyle(color: VxColors.mist500)),
        for (final b in store.bookings.where(
          (e) => vxMatches(widget.query, [e.who, e.service, e.zone, e.status]),
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
                        child: Text(b.who, style: const TextStyle(color: Colors.white, fontSize: 16)),
                      ),
                      VxPill(
                        label: b.status == 'confirmed' ? t.confirmed : t.pendingLabel,
                        cyan: b.status == 'confirmed',
                        selected: false,
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(b.service, style: const TextStyle(color: VxColors.mist400)),
                  const SizedBox(height: 4),
                  Text(
                    '${b.when} · ${b.zone}',
                    style: const TextStyle(fontSize: 12, color: VxColors.mist500),
                  ),
                  VxRowActions(
                    onEdit: () => setState(() {
                      _isNew = false;
                      _form = BookingItem(
                        id: b.id,
                        who: b.who,
                        service: b.service,
                        when: b.when,
                        zone: b.zone,
                        status: b.status,
                      );
                    }),
                    onRemove: () => store.removeBooking(b.id),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
