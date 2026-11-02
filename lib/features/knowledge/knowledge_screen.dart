import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:vortexsales/core/api/vx_api_client.dart';
import 'package:vortexsales/core/l10n/vx_l10n.dart';
import 'package:vortexsales/core/search/vx_match.dart';
import 'package:vortexsales/core/state/store_controller.dart';
import 'package:vortexsales/core/theme/vx_colors.dart';
import 'package:vortexsales/core/widgets/vx_button.dart';
import 'package:vortexsales/core/widgets/vx_field.dart';
import 'package:vortexsales/core/widgets/vx_glass.dart';
import 'package:vortexsales/core/widgets/vx_page_header.dart';
import 'package:vortexsales/core/widgets/vx_store_form.dart';
import 'package:vortexsales/data/mock/mock_data.dart';

class KnowledgeScreen extends StatefulWidget {
  const KnowledgeScreen({super.key, this.query = ''});

  final String query;

  @override
  State<KnowledgeScreen> createState() => _KnowledgeScreenState();
}

class _KnowledgeScreenState extends State<KnowledgeScreen> {
  KnowledgeItem? _form;
  bool _isNew = false;
  bool _busy = false;
  String? _note;

  Future<void> _pickAndUpload() async {
    if (_busy) return;
    final t = VxL10n.of(context);
    final store = StoreScope.of(context);
    final picked = await FilePicker.platform.pickFiles(
      withData: true,
      type: FileType.custom,
      allowedExtensions: const ['txt', 'md', 'pdf', 'png', 'jpg', 'jpeg', 'webp'],
    );
    if (picked == null || picked.files.isEmpty) return;
    final file = picked.files.first;
    final bytes = file.bytes;
    if (bytes == null || bytes.isEmpty) {
      setState(() => _note = t.empty);
      return;
    }
    setState(() {
      _busy = true;
      _note = null;
    });
    try {
      await VxApiClient().uploadFile(
        bytes: bytes,
        filename: file.name,
        caption: file.name,
      );
      final ext = (file.extension ?? '').toLowerCase();
      final decoded = utf8.decode(bytes.take(12000).toList(), allowMalformed: true);
      final looksText = ext == 'txt' ||
          ext == 'md' ||
          decoded.contains(RegExp(r'[\u0600-\u06FFa-zA-Z]{3,}'));
      final body = looksText ? decoded.trim() : 'Uploaded file: ${file.name}';
      store.upsertKnowledge(
        KnowledgeItem(
          id: '',
          title: file.name,
          type: ext.isEmpty ? 'File' : ext.toUpperCase(),
          body: body,
          chunks: store.chunksOf(body),
          status: 'ready',
          updated: DateTime.now().toIso8601String().substring(0, 10),
        ),
        isNew: true,
      );
      await store.refresh();
      if (!mounted) return;
      setState(() {
        _busy = false;
        _note = t.storeStatus(store.live);
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _busy = false;
        _note = '$e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = VxL10n.of(context);
    final store = StoreScope.of(context);
    return VxStoreScroll(
      onRefresh: store.refresh,
      children: [
        VxPageHeader(
          title: t.knowledgeTitle,
          subtitle: t.knowledgeSub,
          note: t.storeStatus(store.live),
          actionLabel: _busy ? '…' : t.upload,
          onAction: _busy ? null : _pickAndUpload,
        ),
        const SizedBox(height: 8),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: VxButton(
            label: t.add,
            variant: VxButtonVariant.ghost,
            onPressed: () => setState(() {
              _isNew = true;
              _form = KnowledgeItem(
                id: '',
                title: '',
                type: 'Text',
                body: '',
                chunks: 1,
                status: 'ready',
                updated: DateTime.now().toIso8601String().substring(0, 10),
              );
            }),
          ),
        ),
        if (_note != null) ...[
          const SizedBox(height: 8),
          Text(_note!, style: const TextStyle(fontSize: 12, color: VxColors.mist400)),
        ],
        if (_form != null) ...[
          const SizedBox(height: 16),
          VxStoreForm(
            key: ObjectKey(_form),
            onCancel: () => setState(() => _form = null),
            onSave: () {
              final item = _form!;
              if (item.title.trim().isEmpty || item.body.trim().isEmpty) return;
              item.chunks = store.chunksOf(item.body);
              store.upsertKnowledge(item, isNew: _isNew);
              setState(() => _form = null);
            },
            children: [
              VxField(
                label: t.titleField,
                child: VxTextField(
                  initialValue: _form!.title,
                  onChanged: (v) => _form!.title = v,
                ),
              ),
              VxField(
                label: t.type,
                child: VxTextField(
                  initialValue: _form!.type,
                  onChanged: (v) => _form!.type = v,
                ),
              ),
              VxField(
                label: t.body,
                child: VxTextField(
                  initialValue: _form!.body,
                  maxLines: 4,
                  onChanged: (v) => _form!.body = v,
                ),
              ),
            ],
          ),
        ],
        const SizedBox(height: 16),
        if (store.knowledge.isEmpty)
          Text(t.empty, style: const TextStyle(color: VxColors.mist500)),
        for (final doc in store.knowledge.where(
          (e) => vxMatches(widget.query, [e.title, e.body, e.type]),
        ))
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: VxGlass(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(doc.type.toUpperCase(), style: const TextStyle(fontSize: 12, color: VxColors.cyan)),
                  const SizedBox(height: 8),
                  Text(doc.title, style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 8),
                  Text(
                    doc.body,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 14, color: VxColors.mist400),
                  ),
                  const SizedBox(height: 8),
                  Text(t.chunks(doc.chunks), style: const TextStyle(color: VxColors.mist500)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        doc.status == 'ready' ? t.ready : t.pending,
                        style: TextStyle(
                          fontSize: 12,
                          color: doc.status == 'ready' ? VxColors.cyan : VxColors.violet,
                        ),
                      ),
                      const Spacer(),
                      Text(doc.updated, style: const TextStyle(fontSize: 12, color: VxColors.mist500)),
                    ],
                  ),
                  VxRowActions(
                    onEdit: () => setState(() {
                      _isNew = false;
                      _form = KnowledgeItem(
                        id: doc.id,
                        title: doc.title,
                        type: doc.type,
                        body: doc.body,
                        chunks: doc.chunks,
                        status: doc.status,
                        updated: doc.updated,
                      );
                    }),
                    onRemove: () => store.removeKnowledge(doc.id),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
