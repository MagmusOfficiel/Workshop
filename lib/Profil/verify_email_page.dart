import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flame/game.dart';
import 'package:workshop_gamejam/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:workshop_gamejam/Game/quest.dart';

import '../overlays/game_over.dart';
import '../overlays/main_menu.dart';

class VerifyEmailPage extends StatefulWidget {
  @override
  _VerifyEmailPageState createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool isEmailVerified = false;
  bool canResendEmail = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    if (!isEmailVerified) {
      sendVerificationEmail();
      timer = Timer.periodic(Duration(seconds: 3), (_) => checkEmailVerified());
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();

    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (isEmailVerified) timer?.cancel();
  }

  Future<void> sendVerificationEmail() async {
    try {
      await FirebaseAuth.instance.currentUser!.sendEmailVerification();

      setState(() => canResendEmail = false);
      await Future.delayed(const Duration(seconds: 5));
      setState(() => canResendEmail = true);
    } catch (e) {
      Utils.showSnackBar(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) => isEmailVerified
      ? GameWidget<EmberQuestGame>.controlled(
          gameFactory: EmberQuestGame.new,
          overlayBuilderMap: {
            'MainMenu': (_, game) => MainMenu(game: game),
            'GameOver': (_, game) => GameOver(game: game),
          },
          initialActiveOverlays: const ['MainMenu'],
        )
      : Scaffold(
          appBar: AppBar(
            title: const Text('Verifiy Email'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                    "Un email de vérification viens d'être envoyé à votre email",
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center),
                const SizedBox(height: 24),
                buildResendEmailButton(),
                const SizedBox(height: 8),
                buildCancelButton(),
              ],
            ),
          ),
        );

  Widget buildResendEmailButton() => ElevatedButton.icon(
        style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
        onPressed: canResendEmail ? sendVerificationEmail : null,
        icon: const Icon(Icons.email, size: 32),
        label: const Text("Renvoyer l'e-mail", style: TextStyle(fontSize: 24)),
      );

  Widget buildCancelButton() => TextButton(
        onPressed: () => FirebaseAuth.instance.signOut(),
        style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
        child: const Text('Annuler', style: TextStyle(fontSize: 24)),
      );
}
