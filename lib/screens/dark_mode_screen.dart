import 'package:flutter/material.dart';
import 'package:messenger/services/provider/theme_provider.dart';
import 'package:messenger/theme/colors_theme.dart';
import 'package:messenger/theme/typography_theme.dart';
import 'package:provider/provider.dart';

class DarkModeScreen extends StatefulWidget {
  const DarkModeScreen({super.key});

  @override
  State<DarkModeScreen> createState() => _DarkModeScreenState();
}

class _DarkModeScreenState extends State<DarkModeScreen> {
  ChooseMode? _mode = ChooseMode.system;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            Icons.arrow_back_rounded,
            color: Theme.of(context).iconTheme.color,
          ),
        ),
        title: Text(
          'Dark Mode',
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ),
      body: Column(
        children: [
          buildRadioListTile(
            title: 'Turn off',
            value: ChooseMode.light,
            groupValue: _mode,
            onChanged: (ChooseMode? value) {
              setState(() {
                _mode = value;
              });
              themeProvider.toggleTheme(_mode!);
            },
          ),
          buildRadioListTile(
            title: 'Turn on',
            value: ChooseMode.dark,
            groupValue: _mode,
            onChanged: (ChooseMode? value) {
              setState(() {
                _mode = value;
              });
              themeProvider.toggleTheme(_mode!);
            },
          ),
          buildRadioListTile(
            title: 'System',
            value: ChooseMode.system,
            groupValue: _mode,
            onChanged: (ChooseMode? value) {
              setState(() {
                _mode = value;
              });
              themeProvider.toggleTheme(_mode!);
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "If you choose system. Zapp will automatically adjust the interface according to the system settings on the device",
                    style: TypographyTheme.text3(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildRadioListTile({
    required String title,
    required ChooseMode value,
    required ChooseMode? groupValue,
    required Function(ChooseMode?) onChanged,
  }) {
    return ListTile(
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyText1,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      leading: Transform.scale(
        scale: 1.2,
        child: Radio<ChooseMode>(
          fillColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
            if (states.contains(MaterialState.selected)) {
              return ColorsTheme.primary;
            }
            return ColorsTheme.grey;
          }),
          value: value,
          groupValue: groupValue,
          onChanged: onChanged,
        ),
      ),
      onTap: () {
        onChanged(value);
      },
    );
  }
}
