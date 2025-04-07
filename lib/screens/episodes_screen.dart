import 'package:flutter/material.dart';
import '../models/episode.dart';
import '../services/api_service.dart';

class EpisodesScreen extends StatefulWidget {
  const EpisodesScreen({Key? key}) : super(key: key);

  @override
  _EpisodesScreenState createState() => _EpisodesScreenState();
}

class _EpisodesScreenState extends State<EpisodesScreen> {
  final ApiService apiService = ApiService();
  late Future<List<Episode>> futureEpisodes;

  @override
  void initState() {
    super.initState();
    futureEpisodes = apiService.fetchEpisodes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Episodios')),
      body: FutureBuilder<List<Episode>>(
        future: futureEpisodes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No se encontraron episodios"));
          } else {
            final episodes = snapshot.data!.take(12).toList();
            return ListView.builder(
              itemCount: episodes.length,
              itemBuilder: (context, index) {
                final episode = episodes[index];
                return Card(
                  child: ListTile(
                    title: Text(episode.name),
                    subtitle: Text('Emitido el: ${episode.airDate}'),
                    trailing: Text(episode.episode),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EpisodeDetailScreen(episode: episode),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class EpisodeDetailScreen extends StatelessWidget {
  final Episode episode;

  const EpisodeDetailScreen({Key? key, required this.episode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(episode.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nombre: ${episode.name}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text('Fecha de emisión: ${episode.airDate}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text('Episodio: ${episode.episode}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            const Text('Personajes (URLs):', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: episode.characters.length > 5 ? 5 : episode.characters.length,
                itemBuilder: (context, index) {
                  return Text(episode.characters[index], style: const TextStyle(fontSize: 14));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
