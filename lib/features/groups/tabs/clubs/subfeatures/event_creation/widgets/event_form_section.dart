import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/widgets/icon_bubble.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/widgets/soft_card.dart';

class EventFormSection extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData? icon;
  final Widget child;

  final bool forceExpanded;

  const EventFormSection({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
    this.icon,
    this.forceExpanded = false,
  });

  @override
  State<EventFormSection> createState() => _EventFormSectionState();
}

class _EventFormSectionState extends State<EventFormSection> {
  bool _expanded = true;

  @override
  Widget build(BuildContext context) {
    final open = _expanded || widget.forceExpanded;

    return SoftCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(22),
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  if (widget.icon != null) ...[
                    IconBubble(widget.icon!, size: 40),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.subtitle,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Styles.tabInactive,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    open ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: Styles.tabInactive,
                  ),
                ],
              ),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            alignment: Alignment.topCenter,
            child: open
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
                    child: widget.child,
                  )
                : const SizedBox(width: double.infinity),
          ),
        ],
      ),
    );
  }
}
