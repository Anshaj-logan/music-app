import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_app/Screens/player_screen.dart';
import 'package:music_app/const/colors.dart';

import 'dart:convert';

import '../api/api_client.dart';
import 'explore_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final RxList<dynamic> genres = <dynamic>[].obs;
  late String Id;

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
                    onTap: () {
                      Id = genre['id'].toString();
                      print('Track Id ${Id}');
                      Get.to(PlayerScreen(
                        id: Id,
                      ));
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    tileColor: bgColor,
                    title: Text(
                      genre['name'],
                      style: GoogleFonts.montserrat(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: whiteColor),
                    ),
                    subtitle: Text(
                      genre['count'].toString(),
                      style: GoogleFonts.montserrat(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: whiteColor),
                    ),
                    leading: Icon(
                      Icons.music_note,
                      color: whiteColor,
                      size: 32,
                    ),
                    trailing: CircleAvatar(
                      backgroundColor: Colors.teal,
                      radius: 35,
                      child: Icon(
                        Icons.play_arrow_sharp,
                        color: whiteColor,
                        size: 40,
                      ),
                    ),
                  ),
                );
              },
            )));
  }
}
