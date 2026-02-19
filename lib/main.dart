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
   final TextEditingController _nameController = TextEditingController();
   Timer? _hungerTimer;





@override
void dispose() {
  _hungerTimer?.cancel();
  _nameController.dispose();
  super.dispose();
}


  void _playWithPet() {
    setState(() {
      happinessLevel += 10;
      _updateHunger();
    });
  }

  void _feedPet() {
    setState(() {
      hungerLevel -= 10;
      _updateHappiness();
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

  void _updateHappiness() {
    if (hungerLevel < 30) {
      happinessLevel -= 20;
    } else {
      happinessLevel += 10;
    }
  }

  void _updateHunger() {
    setState(() {
      hungerLevel += 5;
      if (hungerLevel > 100) {
        hungerLevel = 100;
        happinessLevel -= 20;
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
