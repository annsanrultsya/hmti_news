import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:aplikasi_hmti_news/screens/detail_screen.dart';
import 'edit_profile.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  Future<List<Map<String, String>>> fetchNews() async {
    final response = await http
        .get(Uri.parse('https://events.hmti.unkhair.ac.id/api/posts'));

    if (response.statusCode == 200) {
      try {
        List<dynamic> data = json.decode(response.body);

        return data.map<Map<String, String>>((item) {
          return {
            'imageUrl': 'https://events.hmti.unkhair.ac.id/storage/' +
                (item['image'] ?? ''),
            'title': item['title']?.toString() ?? 'No Title',
            'author': item['author']?.toString() ?? 'Unknown',
            'description': item['content']?.toString() ?? 'No Description',
            'time': item['updated_at']?.toString() ?? 'Unknown',
          };
        }).toList();
      } catch (e) {
        print("Error parsing data: $e");
        throw Exception('Failed to parse news data');
      }
    } else {
      print("Failed to load news with status: ${response.statusCode}");
      throw Exception('Failed to load news');
    }
  }

  // Data berita statis
  final List<Map<String, String>> news = [
    {
      'imageUrl':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQt5WX189FafKeIM1NySLXF3GziPPte-ypHGQ&s',
      'title': 'Russian warship: Moskva sinks in Black Sea',
      'author': 'Wahyu',
      'description':
          'Cukup salin salah satu URL di atas dan gunakan sebagai imageUrl di aplikasi Flutter atau HTML <img> tag. Kamu juga bisa mengunduh gambar dari URL tersebut dan menyimpannya untuk digunakan secara offline.',
      'time': '4h ago',
    },
    {
      'imageUrl':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTz2m9zjNsiwKu1wU-MwCy1p20BvDwUhRv3Rg&s',
      'title':
          "Ukraine's President Zelensky to BBC: Blood money being paid for Russian oil",
      'author': 'Wahyu',
      'description':
          'Cukup salin salah satu URL di atas dan gunakan sebagai imageUrl di aplikasi Flutter atau HTML <img> tag. Kamu juga bisa mengunduh gambar dari URL tersebut dan menyimpannya untuk digunakan secara offline.',
      'time': '14m ago',
    },
    {
      'imageUrl':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQBi1hOXLo1t_TU-qeXW7rKEmOMqXvtR7VMOA&s',
      'title':
          "Ukraine's President Zelensky to BBC: Blood money being paid for Russian oil",
      'author': 'Wahyu',
      'description':
          'Cukup salin salah satu URL di atas dan gunakan sebagai imageUrl di aplikasi Flutter atau HTML <img> tag. Kamu juga bisa mengunduh gambar dari URL tersebut dan menyimpannya untuk digunakan secara offline.',
      'time': '14m ago',
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Halaman-halaman yang akan ditampilkan di IndexedStack
    final List<Widget> pages = [
      // Halaman Home dengan daftar berita menggunakan ListView.builder
      ListView.builder(
        itemCount: news.length,
        itemBuilder: (context, index) {
          return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailScreen(
                        title: news[index]['title'].toString(),
                        description: news[index]['description'].toString(),
                        imageUrl: news[index]['imageUrl'].toString(),
                      ),
                    ),
                  );
                },
                child: Card(
                  elevation: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(
                            8.0), // Add border radius here
                        child: Image.network(
                          news[index][
                              'imageUrl']!, // Accessing imageUrl from News model
                          fit: BoxFit
                              .cover, // Optional: Adjust the fit as needed
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          news[index]['title']!,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          news[index]['author']! + " • " + news[index]['time']!,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                      SizedBox(height: 8),
                    ],
                  ),
                ),
              ));
        },
      ),
      Center(child: Text('Explore Page')),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              'ΗΜΤΙ',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              'News',
              style: TextStyle(
                  color: Color(0xFF1877F2),
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Pengaturan', style: TextStyle(color: Colors.white)),
              decoration: BoxDecoration(
                color: Color(0xFF1877F2),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profil'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditProfileScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Pengaturan'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          ...pages,
          EditProfileScreen(), // Halaman Profil
          EditProfileScreen(), // Halaman Profil
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Color(0xFF1877F2),
        unselectedItemColor: Colors.black,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Bookmark',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
