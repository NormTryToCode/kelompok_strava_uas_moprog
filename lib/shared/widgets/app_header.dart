import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? titleWidget;
  final Widget? leadingWidget;
  final List<Widget> actions;
  final bool showBackButton;

  const AppHeader({
    super.key,
    this.title,
    this.titleWidget,
    this.leadingWidget,
    this.actions = const [],
    this.showBackButton = false,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: showBackButton,
      leading: leadingWidget,
      leadingWidth: leadingWidget == null ? null : 150,
      backgroundColor: Styles.background,
      foregroundColor: Styles.tabActive,
      surfaceTintColor: Colors.transparent,
      scrolledUnderElevation: 0,
      centerTitle: false,
      title: titleWidget ??
          (title == null
              ? null
              : Text(
                  title!,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                )),
      actions: actions,
    );
  }
}