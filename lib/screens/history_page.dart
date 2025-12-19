import 'package:bio_calc/logic/database_helper.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Map<String, dynamic>> _history = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _refreshHistory();
  }

  Future<void> _refreshHistory() async {
    setState(() => _isLoading = true);
    final data = await DatabaseHelper.instance.getHistory();
    setState(() {
      _history = data;
      _isLoading = false;
    });
  }

  Future<void> _deleteEntry(int id) async {
    await DatabaseHelper.instance.deleteEntry(id);
    _refreshHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculation History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Clear History?'),
                  content: const Text('This will delete all saved calculations.'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                    TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Clear All')),
                  ],
                ),
              );
              if (confirm == true) {
                await DatabaseHelper.instance.clearAll();
                _refreshHistory();
              }
            },
          )
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _history.isEmpty
          ? const Center(child: Text('No history found.'))
          : ListView.builder(
        itemCount: _history.length,
        itemBuilder: (context, index) {
          final item = _history[index];
          final inputs = jsonDecode(item['input']) as Map<String, dynamic>;

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              leading: CircleAvatar(
                child: Icon(_getIcon(item['type'])),
              ),
              title: Text('${item['type']} Result'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Input: ${inputs.values.join(', ')}'),
                  Text(
                    item['output'],
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                ],
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                onPressed: () => _deleteEntry(item['id']),
              ),
            ),
          );
        },
      ),
    );
  }

  IconData _getIcon(String type) {
    switch (type) {
      case 'Molarity': return Icons.science;
      case 'Dilution': return Icons.opacity;
      case 'Protein': return Icons.hub;
      case 'Ligation': return Icons.link;
      default: return Icons.calculate;
    }
  }
}