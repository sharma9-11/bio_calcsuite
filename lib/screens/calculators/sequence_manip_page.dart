import 'package:bio_calc/logic/sequence_tools.dart';
import 'package:bio_calc/logic/database_helper.dart'; // Added DB Import
import 'package:flutter/material.dart';

class SequenceManipPage extends StatefulWidget {
  @override
  _SequenceManipPageState createState() => _SequenceManipPageState();
}

class _SequenceManipPageState extends State<SequenceManipPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _textController = TextEditingController();
  final _tools = SequenceTools();

  // Result variables
  String _reverseComplement = '';
  String _transcription = '';
  Map<String, String> _translationFrames = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _analyzeSequence() {
    final String sequence = _textController.text.toUpperCase();
    if (sequence.isEmpty) return;

    setState(() {
      _reverseComplement = _tools.reverseComplement(sequence);
      _transcription = _tools.transcribe(sequence);
      _translationFrames = _tools.translateSixFrames(sequence);
    });

    // Save calculation to Database for History tab
    DatabaseHelper.instance.insertCalculation(
      type: 'Sequence Manipulation',
      inputMap: {
        'sequence': sequence.length > 20
            ? '${sequence.substring(0, 20)}...'
            : sequence,
        'length': sequence.length
      },
      output: 'Processed sequence of length ${sequence.length} bp',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sequence Manipulation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                labelText: 'Enter DNA Sequence',
                hintText: 'e.g. ATGCGT...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => _textController.clear(),
                ),
              ),
              maxLines: 5,
              minLines: 3,
              style: const TextStyle(fontFamily: 'monospace'),
            ),
            const SizedBox(height: 16.0),
            // Analyze Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                onPressed: _analyzeSequence,
                child: const Text('Analyze'),
              ),
            ),
            const SizedBox(height: 16.0),
            TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'RevComp'),
                Tab(text: 'Transcribe'),
                Tab(text: 'Translate'),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _ResultBox(title: 'Reverse Complement', sequence: _reverseComplement),
                  _ResultBox(title: 'Transcription (RNA)', sequence: _transcription),
                  _TranslationView(frames: _translationFrames),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultBox extends StatelessWidget {
  const _ResultBox({required this.title, required this.sequence});

  final String title;
  final String sequence;

  @override
  Widget build(BuildContext context) {
    final bool isEmpty = sequence.isEmpty;

    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8.0),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Theme.of(context).dividerColor),
              ),
              child: SingleChildScrollView(
                child: SelectableText(
                  isEmpty ? '(No results to display)' : sequence,
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 16,
                    color: isEmpty
                        ? Theme.of(context).colorScheme.onSurface.withOpacity(0.6)
                        : Theme.of(context).colorScheme.onSurface,
                    fontStyle: isEmpty ? FontStyle.italic : FontStyle.normal,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TranslationView extends StatelessWidget {
  const _TranslationView({required this.frames});

  final Map<String, String> frames;

  static const Map<String, String> _frameTitles = {
    '5f1': '5\' - 3\' Frame 1',
    '5f2': '5\' - 3\' Frame 2',
    '5f3': '5\' - 3\' Frame 3',
    '3f1': '3\' - 5\' Frame 1',
    '3f2': '3\' - 5\' Frame 2',
    '3f3': '3\' - 5\' Frame 3',
  };

  @override
  Widget build(BuildContext context) {
    if (frames.isEmpty) {
      return const Center(
          child: Text('Enter a sequence to see translation results.'));
    }

    final frameKeys = frames.keys.toList();

    return ListView.builder(
      padding: const EdgeInsets.only(top: 16.0),
      itemCount: frameKeys.length,
      itemBuilder: (context, index) {
        final key = frameKeys[index];
        final title = _frameTitles[key] ?? 'Unknown Frame';
        final sequence = frames[key]!;
        final bool isEmpty = sequence.isEmpty;

        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 4.0),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: Theme.of(context).dividerColor),
                ),
                child: SelectableText(
                  isEmpty ? '(No protein translated)' : sequence,
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 16,
                    color: isEmpty
                        ? Theme.of(context).colorScheme.onSurface.withOpacity(0.6)
                        : Theme.of(context).colorScheme.onSurface,
                    fontStyle: isEmpty ? FontStyle.italic : FontStyle.normal,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}