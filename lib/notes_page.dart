// notes_page.dart
import 'package:flutter/material.dart';
import 'note_model.dart';
import 'add_edit_note_page.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final List<Note> notes = [];
  final TextEditingController _searchController = TextEditingController();
  List<Note> _filteredNotes = [];
  int _selectedCategory =
      0; // 0: All, 1: Pinned, 2: Recent, 3: Personal, 4: Work
  final List<String> _categories = [
    'All',
    'Pinned',
    'Recent',
    'Personal',
    'Work',
  ];

  @override
  void initState() {
    super.initState();
    _initializeNotes();
    _filteredNotes = List.from(notes);
  }

  void _initializeNotes() {
    // Sample notes with different colors and categories
    notes.addAll([
      Note.create(
        title: 'Creative Ideas ✨',
        content:
            'Brainstorming for new design project. Consider pastel color schemes and minimalist layouts.',
        colorIndex: 0,
      )..isPinned = true,
      Note.create(
        title: 'Meeting Notes',
        content:
            'Team sync: Discuss Q4 goals, project deadlines, and resource allocation.',
        colorIndex: 1,
      ),
      Note.create(
        title: 'Personal Goals',
        content:
            '• Read 20 books this year\n• Learn Flutter animations\n• Start meditation practice',
        colorIndex: 2,
      )..isPinned = true,
      Note.create(
        title: 'Shopping List 🛒',
        content:
            'Groceries: Avocado, Salmon, Quinoa, Berries\nSupplies: Notebooks, Pens, Planner',
        colorIndex: 3,
      ),
      Note.create(
        title: 'Project Timeline',
        content:
            'Phase 1: Research & Planning\nPhase 2: Design & Prototyping\nPhase 3: Development\nPhase 4: Testing & Launch',
        colorIndex: 4,
      ),
    ]);

    // Sort notes: pinned first
    notes.sort((a, b) => b.isPinned ? 1 : -1);
    _filteredNotes.sort((a, b) => b.isPinned ? 1 : -1);
  }

  void _searchNotes(String query) {
    setState(() {
      if (query.isEmpty) {
        _applyCategoryFilter();
      } else {
        _filteredNotes = notes
            .where(
              (note) =>
                  note.title.toLowerCase().contains(query.toLowerCase()) ||
                  note.content.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
      }
    });
  }

  void _applyCategoryFilter() {
    setState(() {
      switch (_selectedCategory) {
        case 1: // Pinned
          _filteredNotes = notes.where((note) => note.isPinned).toList();
          break;
        case 2: // Recent (last 7 days)
          final weekAgo = DateTime.now().subtract(const Duration(days: 7));
          _filteredNotes = notes
              .where((note) => note.createdAt.isAfter(weekAgo))
              .toList();
          break;
        default: // All
          _filteredNotes = List.from(notes);
      }
    });
  }

  void _deleteNote(int index) {
    final note = _filteredNotes[index];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Icon(
              Icons.delete_outline,
              size: 60,
              color: const Color(0xFFFF6584),
            ),
            const SizedBox(height: 16),
            const Text(
              'Delete Note?',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '"${note.title}" will be permanently deleted',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF777777), fontSize: 16),
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      side: const BorderSide(color: Color(0xFFE0E0E0)),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: Color(0xFF777777),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        notes.remove(note);
                        _filteredNotes.removeAt(index);
                      });
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Note deleted'),
                          backgroundColor: const Color(0xFFFF6584),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF6584),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Delete',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _togglePin(int index) {
    setState(() {
      final note = _filteredNotes[index];
      note.isPinned = !note.isPinned;
      notes.sort((a, b) => b.isPinned ? 1 : -1);
      _applyCategoryFilter();
    });
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${date.day}/${date.month}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F7F7),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFF9F7F7), Color(0xFFF0EDFF)],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'My Notes',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      foreground: Paint()
                        ..shader = const LinearGradient(
                          colors: [Color(0xFF6C63FF), Color(0xFFFF6584)],
                        ).createShader(const Rect.fromLTWH(0, 0, 200, 70)),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Capture your thoughts and ideas',
                    style: TextStyle(color: Color(0xFF777777), fontSize: 16),
                  ),
                ],
              ),
            ),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: _searchNotes,
                  decoration: InputDecoration(
                    hintText: 'Search notes...',
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Color(0xFFAAAAAA),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                  ),
                ),
              ),
            ),

            // Category Filter
            SizedBox(
              height: 60,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: ChoiceChip(
                      label: Text(_categories[index]),
                      selected: _selectedCategory == index,
                      onSelected: (selected) {
                        setState(() {
                          _selectedCategory = selected ? index : 0;
                          _applyCategoryFilter();
                        });
                      },
                      labelStyle: TextStyle(
                        color: _selectedCategory == index
                            ? Colors.white
                            : const Color(0xFF777777),
                        fontWeight: FontWeight.w600,
                      ),
                      selectedColor: const Color(0xFF6C63FF),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: _selectedCategory == index ? 4 : 0,
                    ),
                  );
                },
              ),
            ),

            // Notes List
            Expanded(
              child: _filteredNotes.isEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.note_add_outlined,
                          size: 100,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'No notes yet',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFAAAAAA),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Tap + to create your first note',
                          style: TextStyle(color: Color(0xFFCCCCCC)),
                        ),
                      ],
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(24),
                      itemCount: _filteredNotes.length,
                      itemBuilder: (context, index) {
                        final note = _filteredNotes[index];
                        final colors = Note.colors[note.colorIndex];
                        final primaryColor = colors['primary'] as Color;
                        final accentColor = colors['accent'] as Color;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          child: Material(
                            borderRadius: BorderRadius.circular(24),
                            elevation: 4,
                            shadowColor: accentColor.withOpacity(0.1),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(24),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        AddEditNotePage(note: note),
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      primaryColor.withOpacity(0.9),
                                      primaryColor.withOpacity(0.7),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Title Row
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            note.title,
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700,
                                              color: accentColor,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            if (note.isPinned)
                                              Icon(
                                                Icons.push_pin,
                                                size: 16,
                                                color: accentColor,
                                              ),
                                            const SizedBox(width: 8),
                                            GestureDetector(
                                              onTap: () => _deleteNote(index),
                                              child: Container(
                                                width: 28,
                                                height: 28,
                                                decoration: BoxDecoration(
                                                  color: Colors.white
                                                      .withOpacity(0.9),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Icon(
                                                  Icons.close,
                                                  size: 16,
                                                  color: accentColor,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 12),

                                    // Content Preview
                                    Text(
                                      note.content,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF555555),
                                        height: 1.4,
                                      ),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),

                                    const SizedBox(height: 12),

                                    // Date
                                    Row(
                                      children: [
                                        Text(
                                          _formatDate(note.createdAt),
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: accentColor.withOpacity(0.7),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const Spacer(),
                                        if (note.isPinned)
                                          Text(
                                            'Pinned',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: accentColor,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const AddEditNotePage(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    const begin = Offset(0.0, 1.0);
                    const end = Offset.zero;
                    const curve = Curves.easeInOut;
                    var tween = Tween(
                      begin: begin,
                      end: end,
                    ).chain(CurveTween(curve: curve));
                    return SlideTransition(
                      position: animation.drive(tween),
                      child: child,
                    );
                  },
            ),
          );
        },
        backgroundColor: const Color(0xFF6C63FF),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }
}
