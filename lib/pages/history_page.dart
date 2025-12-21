import 'package:flutter/material.dart';
import '../history/log.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  void removeAction(int index) {
    setState(() {
      Log.actions.removeAt(index);
    });
  }

  void clearAll() {
    setState(() {
      Log.actions.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Historique")),
      body: ListView.builder(
        itemCount: Log.actions.length,
        itemBuilder: (_, index) {
          final action = Log.actions[index];
          return ListTile(
            title: Text(action),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => removeAction(index),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: clearAll,
        child: const Icon(Icons.delete_sweep),
      ),
    );
  }
}
