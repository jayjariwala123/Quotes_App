import "package:flutter/material.dart";
import 'package:my_quotes_app/pages/quote_model.dart';
import 'package:my_quotes_app/utils/api.dart';
import 'package:my_quotes_app/utils/routes.dart';

class QuotesPage extends StatefulWidget {
  const QuotesPage({super.key});

  @override
  State<QuotesPage> createState() => _QuotesPageState();
}

class _QuotesPageState extends State<QuotesPage> {
  bool inProgress = false;
  QuoteModel? quote;
  String? backgroundImageUrl;

  @override
  void initState() {
    super.initState();
    _fetchQuote(); // Fetch quote and background on load
  }

  void _fetchQuote() async {
    setState(() {
      inProgress = true;
    });

    try {
      final fetchedQuote = await Api.fetchRandomQuote();
      final randomSig = DateTime.now().millisecondsSinceEpoch;
      final bgUrl = 'https://picsum.photos/1080/1920?sig=$randomSig';

      setState(() {
        quote = fetchedQuote;
        backgroundImageUrl = bgUrl;
      });
    } catch (e) {
      debugPrint("Error fetching quote: $e");
    } finally {
      setState(() {
        inProgress = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            // Background image from Picsum
            if (backgroundImageUrl != null)
              Image.network(
                backgroundImageUrl!,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return const Center(child: CircularProgressIndicator());
                },
                errorBuilder: (context, error, stackTrace) =>
                    Container(color: Colors.grey.shade300),
              ),

            // Overlay for readability
            Container(
              color: Colors.black.withOpacity(0.5),
            ),

            // Main content
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Quotes",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'RobotoMono',
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      quote?.q ?? "......................",
                      style: const TextStyle(
                        fontSize: 30,
                        fontFamily: 'monospace',
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      quote?.a ?? "......................",
                      style: const TextStyle(
                        fontSize: 20,
                        fontFamily: 'serif',
                        color: Colors.white70,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const Spacer(),
                    inProgress
                        ? const CircularProgressIndicator(color: Colors.white)
                        : ElevatedButton(
                            onPressed: _fetchQuote,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black87,
                              padding: const EdgeInsets.symmetric(
                                vertical: 16.0,
                                horizontal: 32.0,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            child: const Text(
                              "Generate Quote",
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'RobotoMono',
                                color: Colors.white,
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, MyRoutes.homeRoute);
          },
          child: const Icon(Icons.add_home_outlined),
        ),
      ),
    );
  }
}
