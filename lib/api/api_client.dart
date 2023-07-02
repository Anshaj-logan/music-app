import 'dart:convert';
import 'package:http/http.dart' as http;

class MusicBrainzAPI {
  final String apiUrl = 'https://musicbrainz.org/ws/2/genre/all';
  final String formatParam = 'fmt';
  final String formatValue = 'json';

  Future<List<dynamic>> getAllGenres() async {
    final Uri uri = Uri.parse('$apiUrl?$formatParam=$formatValue');

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['genres'];
      } else {
        throw Exception('Failed to fetch genres');
      }
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }
}

class PlayerMusicBrainzAPI {
  final String apiUrl;
  final String formatParam;
  final String formatValue;

  PlayerMusicBrainzAPI({
    required this.apiUrl,
    required this.formatParam,
    required this.formatValue,
  });

  Future<Map<String, dynamic>?> getTrackInfo() async {
    final Uri uri = Uri.parse('$apiUrl?$formatParam=$formatValue');

    try {
      final response = await http.get(uri);

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data; // Return the whole data object
      } else {
        throw Exception('Failed to fetch track info');
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }
}
