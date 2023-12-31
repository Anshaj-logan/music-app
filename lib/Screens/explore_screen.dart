import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:music_app/Screens/homeScreen.dart';

import '../const/colors.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({Key? key}) : super(key: key);

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  String searchQuery = '';

  final TextEditingController searchController = TextEditingController();
  final RxList<dynamic> searchResults = <dynamic>[].obs;

  void searchRecordings() async {
    final ExploreMusicBrainzAPI api = Get.find();
    final String artistName = searchController.text;
    final results = await api.searchRecordingsByArtist(artistName);
    searchResults.value = results;

    setState(() {
      searchQuery = artistName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgDarkColor,
        leading: GestureDetector(
          onTap: () {
            Get.to(HomeScreen());
          },
          child: const Icon(
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
      body: SingleChildScrollView(
        child: Container(
          height: double.maxFinite,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: whiteColor,
                      hintText: 'Search for recordings...',
                      hintStyle: TextStyle(color: Colors.black54)),
                ),
              ),
              GestureDetector(
                onTap: () {
                  searchRecordings();
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 40, right: 40),
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: sliderColor,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search,
                          color: whiteColor,
                          size: 30,
                        ),
                        Text(
                          "Search!",
                          style: GoogleFonts.montserrat(
                              color: whiteColor, fontSize: 20),
                        )
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(
                height: 20,
              ),
              if (searchQuery.isEmpty)
                Row(
                  children: [
                    Text(
                      "Popular Genres !",
                      style: GoogleFonts.montserrat(
                          color: whiteColor,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              if (searchQuery.isEmpty)
                Container(
                  margin: EdgeInsets.only(top: 10),
                  height: 500,
                  child: GridView(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage('images/pop.jpg')),
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage('images/rock music.jpeg')),
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage('images/classical.png')),
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage('images/oldschool.jpg')),
                            borderRadius: BorderRadius.circular(20)),
                      ),
                    ],
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 15,
                        crossAxisSpacing: 15),
                  ),
                ),
              if (searchQuery.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Search Result for: "$searchQuery"',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: whiteColor),
                  ),
                ),
              // ElevatedButton(
              //   onPressed: searchRecordings,
              //   child: Text('Search'),
              // ),
              Expanded(
                child: Obx(
                  () => ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: searchResults.length,
                    itemBuilder: (context, index) {
                      final recording = searchResults[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          tileColor: bgColor,
                          title: Text(
                            recording['title'],
                            style: GoogleFonts.montserrat(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: whiteColor),
                          ),
                          subtitle: Text(
                            recording['artist-credit'][0]['artist']['name'],
                            style: GoogleFonts.montserrat(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: whiteColor),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            color: whiteColor,
                          ),
                          onTap: () {},
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ExploreMusicBrainzAPI {
  final String apiUrl = 'https://musicbrainz.org/ws/2/recording';
  final String queryParam = 'query';

  Future<List<dynamic>> searchRecordingsByArtist(String artistName) async {
    final Uri uri = Uri.parse('$apiUrl?$queryParam=$artistName&fmt=json');

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['recordings'];
      } else {
        throw Exception('Failed to search recordings !');
      }
    } catch (e) {
      print('Error: $e');
      showSnackBar('Failed to search recordings !');
      return [];
    }
  }

  void showSnackBar(String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
      backgroundColor: Colors.red, // Set your desired color here
    );
    ScaffoldMessenger.of(Get.context!).showSnackBar(snackBar);
  }
}
