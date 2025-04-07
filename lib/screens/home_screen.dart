import 'package:flutter/material.dart';
import '../models/character.dart';
import '../services/api_service.dart';
import 'detail_screen.dart';
import 'episodes_screen.dart';
import '../widgets/loading.dart';
import '../widgets/empty_state.dart';
import '../widgets/error_snackbar.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService apiService = ApiService();
  late Future<List<Character>> futureCharacters;
  List<Character> allCharacters = [];
  List<Character> filteredCharacters = [];
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    futureCharacters = apiService.fetchCharacters();
    futureCharacters.then((characters) {
      setState(() {
        allCharacters = characters;
        filteredCharacters = allCharacters; // Inicialmente muestra todos
      });
    });
  }

  void _filterCharacters(String query) {
    setState(() {
      filteredCharacters = allCharacters
          .where((character) =>
              character.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: "Buscar personaje...",
            border: InputBorder.none,
            suffixIcon: searchController.text.isNotEmpty
                ? IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      searchController.clear();
                      _filterCharacters('');
                    },
                  )
                : null,
          ),
          onChanged: _filterCharacters,
        ),
      ),
      body: FutureBuilder<List<Character>>(
        future: futureCharacters,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loading();
          } else if (snapshot.hasError) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                ErrorSnackBar(errorMessage: snapshot.error.toString()),
              );
            });
            return const EmptyState();
          } else if (filteredCharacters.isEmpty) {
            return const EmptyState();
          } else {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                  childAspectRatio: 0.7,
                ),
                itemCount: filteredCharacters.length,
                itemBuilder: (context, index) {
                  final character = filteredCharacters[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailScreen(character: character),
                        ),
                      );
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                              child: Image.network(
                                character.image,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return const Center(child: CircularProgressIndicator());
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.error, size: 50, color: Colors.red);
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(
                                  character.name,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  character.species,
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.tv),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EpisodesScreen()),
          );
        },
      ),
    );
  }
}
