import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shorebirdpractice/note.dart';
import 'package:shorebirdpractice/note_editor_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Notes MVP',
      theme: ThemeData.from(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan),
        useMaterial3: true,
      ),
      home: const NotesListScreen(),
    );
  }
}

class NotesListScreen extends StatefulWidget {
  const NotesListScreen({super.key});

  @override
  State<NotesListScreen> createState() => _NotesListScreenState();
}

class _NotesListScreenState extends State<NotesListScreen> {
  // In-memory list of notes for our MVP
  final List<Note> _notes = [];
  static const _notesKey = 'notes';

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final notesJson = prefs.getStringList(_notesKey);
    if (notesJson != null) {
      setState(() {
        _notes.addAll(
          notesJson.map((json) => Note.fromJson(jsonDecode(json))).toList(),
        );
      });
    }
  }

  Future<void> _saveNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final notesJson = _notes
        .map((note) => jsonEncode(note.toJson()))
        .toList(); // This line is correct, the error message is misleading.
    await prefs.setStringList(_notesKey, notesJson);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('My Notes'),
      ),
      body: _notes.isEmpty
          ? const Center(
              child: Text("You have no notes. Tap '+' to create one!"),
            )
          : ListView.builder(
              itemCount: _notes.length,
              itemBuilder: (context, index) {
                final note = _notes[index];
                return ListTile(
                  title: Text(note.title),
                  subtitle: Text(
                    note.content,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () async {
                    final updatedNote = await Navigator.push<Note>(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NoteEditorScreen(note: note),
                      ),
                    );
                    if (updatedNote != null) {
                      setState(() {
                        final index = _notes.indexWhere(
                          (n) => n.id == updatedNote.id,
                        );
                        if (index != -1) {
                          _notes[index] = updatedNote;
                        }
                      });
                      await _saveNotes();
                    }
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newNote = await Navigator.push<Note>(
            context,
            MaterialPageRoute(builder: (context) => const NoteEditorScreen()),
          );

          if (newNote != null) {
            setState(() {
              _notes.add(newNote);
            });
            await _saveNotes();
          }
        },
        tooltip: 'New Note',
        child: const Icon(Icons.add),
      ),
    );
  }
}
