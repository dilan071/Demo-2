// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/character.dart';
import '../models/episode.dart';
import '../models/location.dart';

class ApiService {
  static const String baseUrl = "https://rickandmortyapi.com/api";

  Future<List<Character>> fetchCharacters() async {
    final response = await http.get(Uri.parse('$baseUrl/character'));
    if (response.statusCode == 200) {
      final List<dynamic> results = json.decode(response.body)['results'];
      return results.map((json) => Character.fromJson(json)).toList();
    } else {
      throw Exception("Error al obtener los personajes");
    }
  }

  Future<List<Episode>> fetchEpisodes() async {
    final response = await http.get(Uri.parse('$baseUrl/episode'));
    if (response.statusCode == 200) {
      final List<dynamic> results = json.decode(response.body)['results'];
      return results.map((json) => Episode.fromJson(json)).toList();
    } else {
      throw Exception("Error al obtener los episodios");
    }
  }

  Future<List<Location>> fetchLocations() async {
    final response = await http.get(Uri.parse('$baseUrl/location'));
    if (response.statusCode == 200) {
      final List<dynamic> results = json.decode(response.body)['results'];
      return results.map((json) => Location.fromJson(json)).toList();
    } else {
      throw Exception("Error al obtener las ubicaciones");
    }
  }
}
