import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/club_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/providers/club_provider.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/services/club_share_service.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/club_share/widgets/club_share_poster_card.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/club_share/widgets/share_action_tile.dart';

class ShareClubPage extends ConsumerStatefulWidget {
  final Club club;

  const ShareClubPage({super.key, required this.club});

  static Future<void> open(BuildContext context, Club club) {
    return Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute<void>(builder: (_) => ShareClubPage(club: club)),
    );
  }

  @override
  ConsumerState<ShareClubPage> createState() => _ShareClubPageState();
}

class _ShareClubPageState extends ConsumerState<ShareClubPage> {
  final _posterKey = GlobalKey();
  final _shareService = ClubShareService();

  List<ShareTarget> _targets = const [];
  bool _loadingTargets = true;
  bool _downloading = false;
  bool _sharing = false;

  @override
  void initState() {
    super.initState();
    _loadTargets();
  }

  Future<void> _loadTargets() async {
    final detected = await _shareService.getInstalledTargets();
    if (!mounted) return;
    setState(() {
      _targets = detected;
      _loadingTargets = false;
    });
  }

  Future<Uint8List?> _capturePosterBytes() async {
    try {
      final context = _posterKey.currentContext;
      if (context == null) return null;

      final boundary =
          context.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return null;

      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      image.dispose();
      return byteData?.buffer.asUint8List();
    } catch (_) {
      return null;
    }
  }

  void _showSnack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _copyMessage(Club club) async {
    await Clipboard.setData(
      ClipboardData(text: ClubShareService.shareMessage(club)),
    );
    _showSnack('Club invite copied to clipboard');
  }

  Future<void> _copyLink(Club club) async {
    await Clipboard.setData(
      ClipboardData(text: ClubShareService.clubUrl(club)),
    );
    _showSnack('Club link copied');
  }

  Future<void> _downloadPoster(Club club) async {
    if (_downloading || _sharing) return;
    setState(() => _downloading = true);

    try {
      final bytes = await _capturePosterBytes();
      if (bytes == null) {
        _showSnack('Could not render club poster.');
        return;
      }

      await _shareService.downloadPoster(bytes, club);
      _showSnack('Poster saved to app storage');
    } catch (_) {
      _showSnack('Failed to save poster.');
    } finally {
      if (mounted) setState(() => _downloading = false);
    }
  }

  Future<void> _shareTo(Club club, {ShareTarget? target}) async {
    if (_sharing || _downloading) return;
    setState(() => _sharing = true);

    try {
      String? imagePath;
      if (target == null || target.supportsImage) {
        final bytes = await _capturePosterBytes();
        if (bytes != null) {
          imagePath = await _shareService.writePosterToCache(bytes, club.id);
        }
      }

      final message = ClubShareService.shareMessage(club);
      final ok = target == null
          ? await _shareService.shareViaSystemSheet(
              text: message,
              subject: 'Join ${club.name}',
              imagePath: imagePath,
            )
          : await _shareService.shareToTarget(
              target: target,
              text: message,
              imagePath: imagePath,
            );

      if (!ok) {
        _showSnack(
          target == null
              ? 'Could not open share sheet.'
              : 'Could not open ${target.label}.',
        );
      }
    } finally {
      if (mounted) setState(() => _sharing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final clubs = ref.watch(clubsProvider).valueOrNull ?? const <Club>[];
    final club = clubs.firstWhere(
      (c) => c.id == widget.club.id,
      orElse: () => widget.club,
    );
    final clubUrl = ClubShareService.clubUrl(club);

    return Scaffold(
      backgroundColor: Styles.background,
      appBar: AppBar(
        backgroundColor: Styles.background,
        surfaceTintColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: const Text(
          'Share Club',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(32, 12, 32, 16),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 420),
                    child: ClubSharePosterCard(
                      posterKey: _posterKey,
                      club: club,
                      clubUrl: clubUrl,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(0, 18, 0, 20),
              decoration: const BoxDecoration(
                color: Styles.surface,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                border: Border(top: BorderSide(color: Palette.cardBorder)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Share to',
                      style: TextStyle(
                        fontSize: 16.5,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  if (_loadingTargets)
                    const SizedBox(
                      height: 86,
                      child: Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2.2,
                          color: Palette.teal,
                        ),
                      ),
                    )
                  else if (_targets.isNotEmpty) ...[
                    SizedBox(
                      height: 98,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _targets.length,
                        separatorBuilder: (_, _) => const SizedBox(width: 8),
                        itemBuilder: (_, index) {
                          final target = _targets[index];
                          return ShareActionTile.app(
                            target: target,
                            onTap: _sharing
                                ? null
                                : () => _shareTo(club, target: target),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShareActionTile.utility(
                          icon: Icons.copy_all_outlined,
                          label: 'Copy to Clipboard',
                          onTap: () => _copyMessage(club),
                        ),
                        ShareActionTile.utility(
                          icon: Icons.download_outlined,
                          label: 'Download',
                          busy: _downloading,
                          onTap: () => _downloadPoster(club),
                        ),
                        ShareActionTile.utility(
                          icon: Icons.link,
                          label: 'Copy Link',
                          onTap: () => _copyLink(club),
                        ),
                        ShareActionTile.utility(
                          icon: Icons.share_outlined,
                          label: 'Share To',
                          busy: _sharing,
                          onTap: () => _shareTo(club),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}