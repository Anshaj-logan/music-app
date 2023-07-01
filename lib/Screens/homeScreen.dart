import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_app/const/colors.dart';

import 'dart:convert';

import 'package:http/http.dart' as http;

import 'explore_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final RxList<dynamic> genres = <dynamic>[].obs;

  @override
  void initState() {
    super.initState();
    fetchGenres();
  }

  void fetchGenres() async {
    final MusicBrainzAPI api = Get.find();
    final results = await api.getAllGenres();
    genres.value = results;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: bgDarkColor,
        appBar: AppBar(
          backgroundColor: bgDarkColor,
          actions: [
            TextButton(
                onPressed: () {
                  Get.to(ExploreScreen());
                },
                child: Text("Explore",
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                      color: whiteColor,
                      fontWeight: FontWeight.bold,
                    )))
          ],
          leading: const Icon(
            Icons.list,
            color: whiteColor,
          ),
          title: Text(
            "Beats",
            style: GoogleFonts.montserrat(
              fontSize: 18,
              color: whiteColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Obx(() => ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: genres.length,
              itemBuilder: (context, index) {
                final genre = genres[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 4),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    tileColor: bgColor,
                    title: Text(
                      genre['name'],
                      style: GoogleFonts.montserrat(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: whiteColor),
                    ),
                    subtitle: Text(
                      genre['count'].toString(),
                      style: GoogleFonts.montserrat(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: whiteColor),
                    ),
                    leading: Icon(
                      Icons.music_note,
                      color: whiteColor,
                      size: 32,
                    ),
                    trailing: Icon(
                      Icons.play_arrow_sharp,
                      color: whiteColor,
                      size: 26,
                    ),
                  ),
                );
              },
            )));
  }
}

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
