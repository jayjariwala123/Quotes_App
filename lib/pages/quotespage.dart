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

  void _generateQuote() async {
    setState(() {
      inProgress = true;
    });

    // Simulate an API call or some async operation
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      inProgress = false;
    });

    // Show a snackbar or update quote text here
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('New quote generated!')));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
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
                  ),
                ),
                const Spacer(),
                Text(
                  quote?.q ?? "......................",
                  style: TextStyle(
                    fontSize: 30,
                    fontFamily: 'monospace',
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  quote?.a ?? "......................",
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'serif',
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Spacer(),
                inProgress
                    ? const CircularProgressIndicator(color: Colors.blue)
                    : ElevatedButton(
                      onPressed: () {
                        _fetchQuote();
                      },
                      style: ElevatedButton.styleFrom(
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
                        ),
                      ),
                    ),
              ],
            ),
          ),
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

  _fetchQuote() async {
    setState(() {
      inProgress = true;
    });

    try {
      final fetchedQuote = await Api.fetchRandomQuote();
      debugPrint(fetchedQuote.toJson().toString());
      setState(() {
        quote = fetchedQuote;
      });
    } catch (e) {
      debugPrint("Error fetching quote: $e");
    } finally {
      setState(() {
        inProgress = false;
      });
    }
  }
}
