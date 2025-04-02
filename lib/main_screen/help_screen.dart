import 'package:flutter/material.dart';
import 'package:touch_sender/l10n/app_localizations.dart';
import 'package:touch_sender/util/logger.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});
  @override
  Widget build(BuildContext context) {
    logBuildAction();
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.only(
          top: 24,
          left: 24,
          right: 24,
          bottom: 56,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 32,
          children: [
            HelpNumberingSection(
              icon: Icons.desktop_windows_rounded,
              title: AppLocalizations.of(context)!.pcSetup,
              children: [
                AppLocalizations.of(context)!.pcSetupDescription1,
                AppLocalizations.of(context)!.pcSetupDescription2,
                AppLocalizations.of(context)!.pcSetupDescription3,
              ],
            ),
            HelpSimpleSection(
              icon: Icons.screen_rotation,
              title: AppLocalizations.of(context)!.touchScreenRotation,
              content:
                  AppLocalizations.of(context)!.touchScreenRotationDescription,
            ),
            HelpSimpleSection(
              icon: Icons.mouse_outlined,
              title: AppLocalizations.of(context)!.sensitivitySetting,
              content:
                  AppLocalizations.of(context)!.sensitivitySettingDescription,
            ),
            HelpSimpleSection(
              icon: Icons.speed_outlined,
              title: AppLocalizations.of(context)!.sendingRate,
              content:
                  AppLocalizations.of(context)!.sendingRateSettingDescription,
            ),
          ],
        ),
      ),
    );
  }
}

class HelpSection extends StatelessWidget {
  const HelpSection({
    super.key,
    required this.icon,
    required this.title,
    required this.content,
  });
  final IconData icon;
  final String title;
  final Widget content;

  @override
  Widget build(BuildContext context) {
    logBuildAction();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      spacing: 10,
      children: [
        Row(
          spacing: 12,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary),
            Flexible(
              child: Text(title, style: Theme.of(context).textTheme.titleLarge),
            ),
          ],
        ),
        Divider(
          color: Theme.of(context).colorScheme.primary,
          height: 1,
          thickness: 1,
        ),
        content,
      ],
    );
  }
}

class HelpSimpleSection extends StatelessWidget {
  const HelpSimpleSection({
    super.key,
    required this.icon,
    required this.title,
    required this.content,
  });
  final IconData icon;
  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    logBuildAction();
    return HelpSection(
      icon: icon,
      title: title,
      content: Text(content, style: Theme.of(context).textTheme.bodyLarge),
    );
  }
}

class HelpNumberingSection extends StatelessWidget {
  const HelpNumberingSection({
    super.key,
    required this.icon,
    required this.title,
    required this.children,
  });
  final IconData icon;
  final String title;
  final List<String> children;

  @override
  Widget build(BuildContext context) {
    logBuildAction();
    return HelpSection(
      icon: icon,
      title: title,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        spacing: 8,
        children: [
          ...children.map(
            (child) => Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${children.indexOf(child) + 1}. ',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Flexible(
                  child: Text(
                    child,
                    style: Theme.of(context).textTheme.bodyLarge,
                    softWrap: true,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
