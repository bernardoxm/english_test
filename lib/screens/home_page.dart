import 'package:english_test/screens/home_page.dart';
import 'package:english_test/widgets/favorites_tab_widget.dart';
import 'package:english_test/widgets/history_tab_widget.dart';
import 'package:english_test/widgets/word_list_tab_widget.dart';
import 'package:flutter/material.dart';



class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _historyWords = ['hello', 'world', 'flutter', 'dart', 'coding'];
  final List<String> _favoriteWords = ['hello', 'flutter']; 

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

  void _deleteWordFromHistory(String word) {
    setState(() {
      _historyWords.remove(word);
    });
  }

  void _removeWordFromFavorites(String word) {
    setState(() {
      _favoriteWords.remove(word);
    });
  }

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
        child: Column(
          children: [
            Container(
           
              child: TabBar(
                controller: _tabController,
               
                tabs: const [
                  Tab(text: 'Word List'),
                  Tab(text: 'History'),
                  Tab(text: 'Favorites'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  WordListTab(onWordTap: (String word, Map<String, dynamic> wordDetails) {  },),
                  HistoryTab(
                 
                    onWordTap: _onWordTap, clickedWords: [], historyWords: [], onDelete: (String word) {  },
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


