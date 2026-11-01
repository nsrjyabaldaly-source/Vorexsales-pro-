import 'package:flutter/material.dart';
import 'package:vortexsales/core/l10n/vx_l10n.dart';
import 'package:vortexsales/core/theme/vx_colors.dart';
import 'package:vortexsales/core/theme/vx_radii.dart';
import 'package:vortexsales/core/widgets/vx_button.dart';

class CoachMarks extends StatefulWidget {
  const CoachMarks({
    super.key,
    required this.step,
    required this.targetKey,
    required this.onNext,
    required this.onSkip,
  });

  final int step;
  final GlobalKey targetKey;
  final VoidCallback onNext;
  final VoidCallback onSkip;

  @override
  State<CoachMarks> createState() => _CoachMarksState();
}

class _CoachMarksState extends State<CoachMarks> {
  static const _ids = ['inbox', 'channels', 'catalog'];
  Rect? _box;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _measure());
  }

  @override
  void didUpdateWidget(covariant CoachMarks oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((_) => _measure());
  }

  void _measure() {
    final ctx = widget.targetKey.currentContext;
    if (ctx == null || !mounted) {
      setState(() => _box = null);
      return;
    }
    final box = ctx.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) {
      setState(() => _box = null);
      return;
    }
    final self = context.findRenderObject() as RenderBox?;
    final global = box.localToGlobal(Offset.zero);
    final local = self?.globalToLocal(global) ?? global;
    setState(() => _box = local & box.size);
  }

  @override
  Widget build(BuildContext context) {
    final t = VxL10n.of(context);
    final last = widget.step >= _ids.length - 1;
    final id = _ids[widget.step.clamp(0, _ids.length - 1)];
    final box = _box;
    final size = MediaQuery.sizeOf(context);
    final pad = 8.0;

    double bubbleTop;
    if (box == null) {
      bubbleTop = size.height * 0.32;
    } else if (box.top > 220) {
      bubbleTop = box.top - 16 - 140;
    } else {
      bubbleTop = box.bottom + 16;
    }
    bubbleTop = bubbleTop.clamp(24.0, size.height - 200);

    return Positioned.fill(
      child: Stack(
        children: [
          const Positioned.fill(
            child: ModalBarrier(color: Color(0x8C04060C)),
          ),
          if (box != null)
            Positioned(
              top: box.top - pad,
              left: box.left - pad,
              width: box.width + pad * 2,
              height: box.height + pad * 2,
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(VxRadii.input),
                    border: Border.all(color: VxColors.cyan, width: 2),
                    boxShadow: const [
                      BoxShadow(color: Color(0x6622E3D2), blurRadius: 18),
                    ],
                  ),
                ),
              ),
            ),
          Positioned(
            top: bubbleTop,
            left: 20,
            right: 20,
            child: Material(
              color: VxColors.ink900,
              elevation: 8,
              borderRadius: BorderRadius.circular(24),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: VxColors.hairline),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      t.coachCopy(id),
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        color: VxColors.mist100,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        TextButton(
                          onPressed: widget.onSkip,
                          child: Text(
                            t.coachSkip,
                            style: const TextStyle(
                              fontSize: 12,
                              color: VxColors.mist400,
                            ),
                          ),
                        ),
                        const Spacer(),
                        VxButton(
                          label: last ? t.coachDone : t.coachNext,
                          size: VxButtonSize.sm,
                          onPressed: widget.onNext,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
