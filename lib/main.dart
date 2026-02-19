import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: DigitalPetApp(),
  ));
}

class DigitalPetApp extends StatefulWidget {
  @override
  _DigitalPetAppState createState() => _DigitalPetAppState();
}

class _DigitalPetAppState extends State<DigitalPetApp> {
  String petName = "FORTRESS DOG";
  int happinessLevel = 50;
  int hungerLevel = 50;
  int energyLevel = 70; 

String selectedActivity = "Play"; 
final List<String> activities = ["Play", "Run", "Sleep"];

   final TextEditingController _nameController = TextEditingController();
   Timer? _hungerTimer;

void _checkWinLoss() {
  // LOSS: too hungry or too unhappy
  if (hungerLevel >= 100 || happinessLevel <= 0) {
    _showEndDialog(
      title: "Game Over",
      message: "Your pet is not doing well. Try again!",
    );
    return;
  }

  // WIN: very happy and not too hungry
  if (happinessLevel >= 100 && hungerLevel <= 30) {
    _showEndDialog(
      title: "You Win!",
      message: "Your pet is thriving! Great job!",
    );
    return;
  }
}
void _showEndDialog({required String title, required String message}) {
  // Prevent multiple dialogs stacking
  if (!mounted) return;

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                // Reset game
                happinessLevel = 50;
                hungerLevel = 50;
                petName = "Your Pet";
              });
            },
            child: const Text("Restart"),
          ),
        ],
      );
    },
  );
}
void _clampStats() {
  if (happinessLevel > 100) happinessLevel = 100;
  if (happinessLevel < 0) happinessLevel = 0;

  if (hungerLevel > 100) hungerLevel = 100;
  if (hungerLevel < 0) hungerLevel = 0;

  if (energyLevel > 100) energyLevel = 100;
  if (energyLevel < 0) energyLevel = 0;
}
void _doSelectedActivity() {
  setState(() {
    switch (selectedActivity) {
      case "Play":
        happinessLevel += 12;
        hungerLevel += 6;
        energyLevel -= 10;
        break;

      case "Run":
        happinessLevel += 18;
        hungerLevel += 12;
        energyLevel -= 20;
        break;

      case "Sleep":
        energyLevel += 25;
        hungerLevel += 8;
        happinessLevel += 4;
        break;
    }

    _clampStats();
    _checkWinLoss(); 
  });
}

void _playWithPet() {
  setState(() {
    happinessLevel += 10;
    hungerLevel += 5;

    if (happinessLevel > 100) happinessLevel = 100;
    if (hungerLevel > 100) hungerLevel = 100;

    _checkWinLoss();
  });
}
@override
void initState() {
  super.initState();
  _hungerTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
    setState(() {
      
      hungerLevel += 2;

      energyLevel -= 1;
      if (hungerLevel >= 80) {
        energyLevel -= 1;
      }

      _clampStats();
      _checkWinLoss();
    });
  });
}





@override
void dispose() {
  _hungerTimer?.cancel();
  _nameController.dispose();
  super.dispose();
}

void _feedPet() {
  setState(() {
    hungerLevel -= 10;
    if (hungerLevel < 0) hungerLevel = 0;

    // Feeding affects happiness depending on hunger
    if (hungerLevel < 30) {
      happinessLevel -= 5; // still kinda hungry
    } else {
      happinessLevel += 10; // satisfied
    }

    if (happinessLevel > 100) happinessLevel = 100;
    if (happinessLevel < 0) happinessLevel = 0;

    _checkWinLoss();
  });
}

void _setPetName() {
  setState(() {
    final typed = _nameController.text.trim();
    if (typed.isNotEmpty) {
      petName = typed;
      _nameController.clear();
    }
  });
}

  String _getMoodText() {
  if (hungerLevel >= 80) return "Starving 😫";
  if (hungerLevel >= 60) return "Hungry 😕";

  if (happinessLevel >= 80) return "Super Happy 😄";
  if (happinessLevel >= 50) return "Happy 🙂";
  if (happinessLevel >= 30) return "Okay 😐";
  return "Sad 😢";
}
ColorFilter _petColorFilter() {
  // More hungry => more red tint
  if (hungerLevel >= 80) {
    return ColorFilter.mode(Colors.red.withOpacity(0.75), BlendMode.modulate);
  }
  // Very happy => green-ish tint
  if (happinessLevel >= 80) {
    return ColorFilter.mode(Colors.green.withOpacity(0.85), BlendMode.modulate);
  }
  // Neutral
  return const ColorFilter.mode(Colors.transparent, BlendMode.multiply);
}




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Digital Pet'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
  padding: const EdgeInsets.symmetric(horizontal: 24.0),
  child: TextField(
    controller: _nameController,
    decoration: const InputDecoration(
      labelText: "Enter pet name",
      border: OutlineInputBorder(),
    ),
  ),
),
const SizedBox(height: 12.0),
ElevatedButton(
  onPressed: _setPetName,
  child: const Text("Set Name"),
),
const SizedBox(height: 20.0),

            ColorFiltered(
  colorFilter: _petColorFilter(),
  child: Image.asset(
    'assets/Dog.jpg',
    width: 200,
    height: 200,
    fit: BoxFit.cover,
  ),
),
  const SizedBox(height: 16.0),
            Text('Name: $petName', style: TextStyle(fontSize: 20.0)),
            SizedBox(height: 16.0),
            Text(_getMoodText(), style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold)),
             SizedBox(height: 16.0),
            Text('Happiness Level: $happinessLevel', style: TextStyle(fontSize: 20.0)),
            SizedBox(height: 16.0),
            Text('Hunger Level: $hungerLevel', style: TextStyle(fontSize: 20.0)),
            SizedBox(height: 32.0),
           
Padding(
  padding: const EdgeInsets.symmetric(horizontal: 24.0),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("Energy Level: $energyLevel", style: const TextStyle(fontSize: 18.0)),
      const SizedBox(height: 6.0),
      LinearProgressIndicator(
        value: energyLevel / 100,
        minHeight: 10,
      ),
    ],
  ),
),
const SizedBox(height: 16.0),

            ElevatedButton(
              onPressed: _playWithPet,
              child: Text('Play with Your Pet'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _feedPet,
              child: Text('Feed Your Pet'),
            ),
          ],
        ),
      ),
    );
  }
}
