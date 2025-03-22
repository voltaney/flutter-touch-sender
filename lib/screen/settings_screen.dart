import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:touch_sender/provider/settings_provider.dart';
import 'package:touch_sender/util/logger.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkTheme = ref.watch(isDarkThemeProvider);
    return GestureDetector(
      onTap: () => primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Settings')),
        body: SettingsList(
          sections: [
            SettingsSection(
              title: const Text('Section1'),
              tiles: [
                SettingsTile.switchTile(
                  initialValue: isDarkTheme,
                  title: const Text('Dark Theme'),
                  leading: const Icon(Icons.computer),
                  onToggle: (bool value) {
                    ref
                        .read(isDarkThemeProvider.notifier)
                        .setIsDarkTheme(value);
                  },
                ),
                SettingsTile(
                  title: const Text('IP Address'),
                  leading: const Icon(Icons.language),
                  value: const IpAddressInput(),
                ),
              ],
            ),
            SettingsSection(
              title: const Text('Section2'),
              tiles: [
                SettingsTile.switchTile(
                  description: const Text('Enables cheat mode'),
                  initialValue: true,
                  onToggle: (bool value) {},
                  title: const Text('Use cheat mode'),
                  leading: const Icon(Icons.computer),
                ),
              ],
            ),
          ],
        ),
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
