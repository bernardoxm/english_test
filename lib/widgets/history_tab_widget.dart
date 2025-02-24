import 'package:english_test/controller/hist_controller.dart';
import 'package:english_test/sql/sql_data_base.dart';
import 'package:english_test/widgets/show_words_details_widget.dart';
import 'package:flutter/material.dart';
import 'package:english_test/services/api_words_service.dart';

class HistoryTab extends StatefulWidget {
  const HistoryTab({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HistoryTabState createState() => _HistoryTabState();
}

class _HistoryTabState extends State<HistoryTab> {
  final HistController _histController = HistController();

  @override
  void initState() {
    super.initState();
    _histController.loadHistory();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _histController.historyList,
      builder: (BuildContext context, Widget? child) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text('History'),
            actions: [
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => _histController
                    .removeHistoryEntry(""), // Remove todo o histórico
              ),
            ],
          ),
          body: _histController.historyList.value.isEmpty
              ? const Center(child: Text('No history available'))
              : ListView.builder(
                  itemCount: _histController.historyList.value.length,
                  itemBuilder: (context, index) {
                    final word =
                        _histController.historyList.value[index]['word'];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () =>
                            _histController.showWordDetails(context, word),
                        child: ListTile(
                          title: Text(word),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () =>
                                _histController.removeHistoryEntryOnly(word),
                          ),
                        ),
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}
