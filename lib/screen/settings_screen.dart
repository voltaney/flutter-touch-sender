import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:touch_sender/l10n/app_localizations.dart';
import 'package:touch_sender/provider/settings_provider.dart';
import 'package:touch_sender/util/logger.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkTheme = ref.watch(isDarkThemeProvider);
    return GestureDetector(
      onTap: () => primaryFocus?.unfocus(),
      child: SettingsList(
        sections: [
          SettingsSection(
            margin: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
            title: Text(AppLocalizations.of(context)!.network),
            tiles: [
              SettingsTile(
                title: Text(AppLocalizations.of(context)!.ipAddress),
                leading: const Icon(Icons.wifi),
                value: const IpAddressInput(),
              ),
              SettingsTile(
                title: Text(AppLocalizations.of(context)!.portNumber),
                leading: const Icon(Icons.numbers),
                value: const PortNumberInput(),
              ),
            ],
          ),
          SettingsSection(
            title: Text(AppLocalizations.of(context)!.appearance),
            tiles: [
              SettingsTile.switchTile(
                initialValue: isDarkTheme,
                title: Text(AppLocalizations.of(context)!.darkMode),
                leading: const Icon(Icons.dark_mode),
                onToggle: (bool value) {
                  ref.read(isDarkThemeProvider.notifier).setIsDarkTheme(value);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class IpAddressInput extends HookConsumerWidget {
  const IpAddressInput({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ipAddress = ref.watch(ipAddressProvider);
    final ipParts = ipAddress.split('.');

    final textEditingControllers = [
      for (int i = 0; i < 4; i++) useTextEditingController(text: ipParts[i]),
    ];
    logger.d('ip rebuild');
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        for (int i = 0; i < 4; i++) ...[
          SizedBox(
            width: 50,
            child: TextFormField(
              controller: textEditingControllers[i],
              textAlign: TextAlign.center,
              textAlignVertical: TextAlignVertical.bottom,
              keyboardType: TextInputType.number,
              maxLength: 3,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              decoration: const InputDecoration(counterText: ''),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onEditingComplete: () {
                if (i == 3) {
                  primaryFocus?.unfocus();
                } else {
                  primaryFocus?.nextFocus();
                }
              },
              onChanged: (value) {
                var newValue = 0;
                if (value.isNotEmpty) {
                  newValue = int.parse(value);
                }
                ref
                    .read(ipAddressProvider.notifier)
                    .setIpAddressByIndex(i, newValue);
                textEditingControllers[i].text = newValue.toString();
              },
            ),
          ),
          if (i < 3)
            const Text(
              '.',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
        ],
      ],
    );
  }
}

class PortNumberInput extends HookConsumerWidget {
  const PortNumberInput({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final portNumber = ref.watch(portNumberProvider);
    final textEditingController = useTextEditingController(
      text: portNumber.toString(),
    );
    return SizedBox(
      width: 80,
      height: 40,
      child: TextFormField(
        controller: textEditingController,
        textAlign: TextAlign.center,
        textAlignVertical: TextAlignVertical.bottom,
        keyboardType: TextInputType.number,
        maxLength: 5,
        maxLengthEnforcement: MaxLengthEnforcement.enforced,
        decoration: const InputDecoration(counterText: ''),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onChanged: (value) {
          var newValue = 0;
          if (value.isNotEmpty) {
            newValue = int.parse(value);
          }
          ref.read(portNumberProvider.notifier).setPortNumber(newValue);
          textEditingController.text = newValue.toString();
        },
      ),
    );
  }
}
