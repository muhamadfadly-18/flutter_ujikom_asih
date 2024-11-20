import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MediaPage extends StatefulWidget {
  @override
  _MediaPageState createState() => _MediaPageState();
}

class _MediaPageState extends State<MediaPage> {
  List mediaData = [];

  @override
  void initState() {
    super.initState();
    fetchMedia();
  }

Future<void> fetchMedia() async {
  try {
    final response = await http.get(Uri.parse('http://localhost:8000/api/datamedia'));

    if (response.statusCode == 200) {
      setState(() {
        mediaData = json.decode(response.body);
      });
    } else {
      print('Failed to load media data. Status code: ${response.statusCode}');
      throw Exception('Failed to load media data');
    }
  } catch (error) {
    print('Error: $error');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Media')),
      body: mediaData.isEmpty
          ? Center(child: CircularProgressIndicator())
          : GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              itemCount: mediaData.length,
              itemBuilder: (context, index) {
                final media = mediaData[index];
                return Card(
                  child: Column(
                    children: [
                      Image.network(
                        media['image_url'],
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                      Text(media['title']),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
