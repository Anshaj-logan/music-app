import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_app/Screens/homeScreen.dart';

import '../api/api_client.dart';
import '../const/colors.dart';
import 'explore_screen.dart';
import 'package:http/http.dart' as http;

class PlayerScreen extends StatefulWidget {
  final String id;
  PlayerScreen({Key? key, required this.id}) : super(key: key);

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  final RxList<dynamic> genres = <dynamic>[].obs;
  double slidervalue = 0.0;
  late String trackId;
  String trackName = ""; // Add a variable to store the track name

  @override
  void initState() {
    super.initState();
    trackId = widget.id;
    fetchTrackInfo();
  }

  void fetchTrackInfo() async {
    final apiUrl = 'https://musicbrainz.org/ws/2/genre/$trackId';
    final formatParam = 'fmt';
    final formatValue = 'json';
    final PlayerMusicBrainzAPI api = PlayerMusicBrainzAPI(
      apiUrl: apiUrl,
      formatParam: formatParam,
      formatValue: formatValue,
    );
    final results = await api.getTrackInfo();
    if (results != null) {
      setState(() {
        trackName = results['name']; // Update the trackName variable
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
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
        leading: IconButton(
          onPressed: () {
            Get.to(HomeScreen());
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: whiteColor,
          ),
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
      body: Stack(
        children: [
          Container(
            constraints: BoxConstraints.expand(),
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("images/cover.jpg"), fit: BoxFit.cover)),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                color: Colors.black54,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.asset(
                    "images/cover.jpg",
                    width: 250,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(trackName, // Update the Text widget with trackName
                    style: GoogleFonts.montserrat(
                      fontSize: 20,
                      color: whiteColor,
                      fontWeight: FontWeight.bold,
                    )),
                SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("00:00",
                        style: GoogleFonts.montserrat(
                          fontSize: 15,
                          color: whiteColor,
                          fontWeight: FontWeight.bold,
                        )),
                    Slider(
                      min: 0,
                      max: 15,
                      divisions: 15,
                      activeColor: Colors.orange,
                      inactiveColor: Colors.grey,
                      value: slidervalue,
                      onChanged: (value) {
                        setState(() {
                          slidervalue = value;
                        });
                      },
                    ),
                    Text("02:42",
                        style: GoogleFonts.montserrat(
                          fontSize: 15,
                          color: whiteColor,
                          fontWeight: FontWeight.bold,
                        )),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(60),
                          color: Colors.black87,
                          border: Border.all(color: Colors.pink)),
                      child: InkWell(
                        onTap: () {},
                        child: Icon(
                          Icons.fast_rewind,
                          color: whiteColor,
                        ),
                      ),
                    ),
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(60),
                          color: Colors.black87,
                          border: Border.all(color: Colors.pink)),
                      child: InkWell(
                        onTap: () {},
                        child: Icon(
                          Icons.play_arrow,
                          color: whiteColor,
                        ),
                      ),
                    ),
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(60),
                          color: Colors.black87,
                          border: Border.all(color: Colors.pink)),
                      child: InkWell(
                        onTap: () {},
                        child: Icon(
                          Icons.fast_forward,
                          color: whiteColor,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
