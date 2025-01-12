import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:cached_network_image/cached_network_image.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Article Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ArticlePage(),
    );
  }
}

class ArticlePage extends StatelessWidget {
  final List<Article> articles = [
    Article(
      title: "How to Learn Flutter",
      thumbnailUrl: "https://example.com/thumbnail1.jpg",
      videoUrl: "https://example.com/video1.mp4",
    ),
    Article(
      title: "Understanding Dart Language",
      thumbnailUrl: "https://example.com/thumbnail2.jpg",
      videoUrl: "https://example.com/video2.mp4",
    ),
    // Add more articles here
  ];

  const ArticlePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Articles with Videos"),
      ),
      body: ListView.builder(
        itemCount: articles.length,
        itemBuilder: (context, index) {
          final article = articles[index];
          return ArticleCard(article: article);
        },
      ),
    );
  }
}

class Article {
  final String title;
  final String thumbnailUrl;
  final String videoUrl;

  Article({required this.title, required this.thumbnailUrl, required this.videoUrl});
}

class ArticleCard extends StatefulWidget {
  final Article article;

  const ArticleCard({super.key, required this.article});

  @override
  _ArticleCardState createState() => _ArticleCardState();
}

class _ArticleCardState extends State<ArticleCard> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.article.videoUrl)
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail image
          CachedNetworkImage(
            imageUrl: widget.article.thumbnailUrl,
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
            placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.article.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          // Video player widget
          _controller.value.isInitialized
              ? SizedBox(
                  height: 200,
                  child: VideoPlayer(_controller),
                )
              : const Center(child: CircularProgressIndicator()),
          // Play button
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  if (_controller.value.isPlaying) {
                    _controller.pause();
                  } else {
                    _controller.play();
                  }
                });
              },
              child: Icon(
                _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                size: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

