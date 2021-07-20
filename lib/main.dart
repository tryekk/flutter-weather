import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Album> fetchAlbum() async {
  // String endTime = df.format(c.getTime());
  String apikey = "z6N3a8QW0Cwy80k9sTxvPNHCGqvRFq5f";
  List<double> location = [51.4816, -3.1791];
  List<String> fields = ["temperature", "weatherCode", "precipitationProbability", "sunriseTime",
    "sunsetTime", "humidity", "windSpeed", "windDirection", "temperatureApparent",
    "grassIndex", "treeIndex"];
  String units = "metric";
  List<String> timesteps = ["1m", "1h", "1d"];
  String timezone = "Europe/London";

  String url = "https://api.tomorrow.io/v4/timelines" + "?apikey=" + apikey + "&location=" +
      "51.4816" + "," + "-3.1791" + "&fields=" + fields[0]
      + "&fields=" + fields[1] + "&fields=" + fields[2] + "&fields=" + fields[3] +
      "&fields=" + fields[4] + "&fields=" + fields[5] + "&fields=" + fields[6] +
      "&fields=" + fields[7] + "&fields=" + fields[8] + "&fields=" + fields[9] +
      "&fields=" + fields[10] + "&units=" + units + "&timesteps=" + timesteps[0] +
      "&timesteps=" + timesteps[1] + "&timesteps=" + timesteps[2] + "&timezone=" + timezone;

  final response =
  await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Album.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class Album {
  final String title;

  Album({
    required this.title,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      title: json['title'],
    );
  }
}

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<Album> futureAlbum;

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Fetch Data Example'),
        ),
        body: Center(
          child: FutureBuilder<Album>(
            future: futureAlbum,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data!.title);
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              // By default, show a loading spinner.
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}