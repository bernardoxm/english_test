
import 'package:english_test/widgets/favorites_tab_widget.dart';
import 'package:english_test/widgets/history_tab_widget.dart';
import 'package:english_test/widgets/word_list_tab_widget.dart';
import 'package:flutter/material.dart';



class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _historyWords = [];
  final List<String> _favoriteWords = []; 

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // ignore: unused_element
  void _deleteWordFromHistory(String word) {
    setState(() {
      _historyWords.remove(word);
    });
  }

  // ignore: unused_element
  void _removeWordFromFavorites(String word) {
    setState(() {
      _favoriteWords.remove(word);
    });
  }

  // ignore: unused_element
  void _onWordTap(String word) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Word Details'),
        content: Text('You tapped on "$word".'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column( mainAxisAlignment:  MainAxisAlignment.center,
          children: [
            TabBar(
              labelStyle: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.05),
              controller: _tabController,
             
              tabs: const [
                Tab(text: 'Word List',),
                Tab(text: 'History'),
                Tab(text: 'Favorites'),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  WordListTab(),
                  HistoryTab(
                 
                  
                  ),
                  FavoritesTab(
                   
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


