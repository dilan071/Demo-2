// lib/screens/detail_screen.dart
import 'package:flutter/material.dart';
import '../models/character.dart';
import 'episodes_screen.dart';

class DetailScreen extends StatelessWidget {
  final Character character;

  DetailScreen({required this.character});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(character.name)),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Image.network(character.image, height: 200)),
            SizedBox(height: 20),
            Center(
              child: Text(
                character.name,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 10),
            Text("Estado: ${character.status}", style: TextStyle(fontSize: 18)),
            Text("Especie: ${character.species}", style: TextStyle(fontSize: 18)),
            Text("Género: ${character.gender}", style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            // Usamos character.location.name ya que location es un objeto Location
            Text("Ubicación: ${character.location.name}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Text("Episodios en los que aparece:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            character.episodes.isNotEmpty
                ? Column(
                    children: character.episodes.map((ep) => Card(
                      elevation: 2,
                      margin: EdgeInsets.symmetric(vertical: 4),
                      child: ListTile(
                        title: Text(ep),
                      ),
                    )).toList(),
                  )
                : Text("No hay episodios disponibles", style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic)),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EpisodesScreen()),
                  );
                },
                child: Text("Ver Episodios"),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Volver"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
