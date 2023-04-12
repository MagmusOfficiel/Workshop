import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:workshop_gamejam/Game/quest.dart';

import 'package:workshop_gamejam/game/classement.dart';


class GameOver extends StatelessWidget {
  // Reference to parent game.
  final EmberQuestGame game;
  const GameOver({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    const blackTextColor = Color.fromRGBO(0, 0, 0, 1.0);
    const whiteTextColor = Color.fromRGBO(255, 255, 255, 1.0);

    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          height: 300,
          width: 300,
          decoration: const BoxDecoration(
            color: blackTextColor,
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Vous êtes mort!',
                style: TextStyle(
                  color: whiteTextColor,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: 200,
                height: 75,
                child: ElevatedButton(
                  onPressed: () {
                    game.reset();
                    game.overlays.remove('GameOver');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: whiteTextColor,
                  ),
                  child: const Text(
                    'Recommencer',
                    style: TextStyle(
                      fontSize: 25.0,
                      color: blackTextColor,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) {
                          return LeaderboardPage();
                        },
                      ));
                    },
                    icon: const Icon(
                      Icons.bar_chart,
                      color: Colors.black87,
                    ),
                    label: const Text(
                      'Classement',
                      style: TextStyle(color: Colors.black87),
                    ),
                    style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(Colors.white)),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: whiteTextColor,
                    ),
                    icon: const Text('Deconnexion',style: TextStyle(color: Colors.black87),),
                    label: const Icon(Icons.east,color: Colors.black,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}