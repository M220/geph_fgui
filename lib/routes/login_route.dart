import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../data/account_data.dart';
import '../providers/settings_provider.dart';
import '../routes/landing_route.dart';
import '../widgets/loading_dialog.dart';
import '../widgets/register_dialog.dart';
import '../constants.dart';

class LoginRoute extends StatefulWidget {
  const LoginRoute({super.key});

  @override
  State<LoginRoute> createState() => _LoginRouteState();
}

class _LoginRouteState extends State<LoginRoute> {
  final usernameFieldController = TextEditingController();
  final passwordFieldController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  late AppLocalizations localizations;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    localizations = AppLocalizations.of(context)!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            vertical: 32,
            horizontal: 16,
          ),
          child: Center(
            child: SizedBox(
              width: 300,
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 200,
                      height: 200,
                      child: Image.asset(
                        gephLogoPath,
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: usernameFieldController,
                      decoration: InputDecoration(
                        label: Text(localizations.username),
                      ),
                      validator: (value) {
                        return (value == null || value.isEmpty)
                            ? "Please enter a username"
                            : null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: passwordFieldController,
                      decoration: InputDecoration(
                        label: Text(localizations.password),
                      ),
                      validator: (value) {
                        return (value == null || value.isEmpty)
                            ? "Please enter a password"
                            : null;
                      },
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () async {
                        if (!formKey.currentState!.validate()) return;

                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (_) =>
                              LoadingDialog(title: localizations.loading),
                        );

                        // ignore: unused_local_variable
                        final data = await Future.delayed(
                            const Duration(seconds: 3), () => "DATA DATA!");

                        if (!context.mounted) return;
                        Navigator.pop(context);
                        final account = AccountData(
                            username: usernameFieldController.text,
                            password: passwordFieldController.text);

                        context
                            .read<SettingsProvider>()
                            .setAccountData(account);

                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const LandingRoute()));
                      },
                      child: Text(localizations.logInBlurb),
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton(
                      onPressed: () async {
                        final data = await showDialog<AccountData?>(
                            context: context,
                            builder: (_) => const RegisterDialog());

                        if (data == null || !context.mounted) return;
                        showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (_) =>
                                const LoadingDialog(title: "Registering..."));

                        // Process data and send it to server.
                        // Change to false for test
                        final bool response = await Future.delayed(
                            const Duration(seconds: 3), () => false);

                        if (!context.mounted) return;
                        // Pop LoadingDialog
                        Navigator.pop(context);
                        if (!response) {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: Text(localizations.registerFailedTitle),
                              content: Text(localizations.registerFailedBlurb),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(localizations.ok),
                                ),
                              ],
                            ),
                          );
                          return;
                        }

                        context.read<SettingsProvider>().setAccountData(data);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const LandingRoute()));
                      },
                      child: Text(localizations.registerBlurb),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
