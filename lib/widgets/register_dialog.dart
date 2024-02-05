import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../data/account_data.dart';

class RegisterDialog extends StatefulWidget {
  const RegisterDialog({super.key});

  @override
  State<RegisterDialog> createState() => _RegisterDialogState();
}

class _RegisterDialogState extends State<RegisterDialog> {
  final formKey = GlobalKey<FormState>();
  final usernameFieldController = TextEditingController();
  final passwordFieldController = TextEditingController();
  final captchaFieldController = TextEditingController();
  late AppLocalizations localizations;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    localizations = AppLocalizations.of(context)!;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(localizations.register),
      contentPadding: const EdgeInsets.all(16),
      content: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                controller: usernameFieldController,
                decoration:
                    InputDecoration(label: Text(localizations.username)),
                validator: (value) {
                  //TODO: Validation logic of username goes here
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: passwordFieldController,
                decoration:
                    InputDecoration(label: Text(localizations.password)),
                validator: (value) {
                  //TODO: Validation logic of password goes here
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Container(
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.red.shade700,
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                ),
                child: const Center(child: Text("Captcha goes here")),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(label: Text(localizations.captcha)),
                validator: (value) {
                  //TODO: Validation logic of captcha goes here
                  return null;
                },
              )
            ],
          ),
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () async {
            if (formKey.currentState == null) return;
            if (formKey.currentState!.validate()) {
              final username = usernameFieldController.text;
              final password = passwordFieldController.text;
              final data = AccountData(
                username: username,
                password: password,
              );

              Navigator.pop(context, data);
            }
          },
          child: Text(localizations.register),
        ),
      ],
    );
  }
}
