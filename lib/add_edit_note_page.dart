// add_edit_note_page.dart
import 'package:flutter/material.dart';
import 'note_model.dart';

class AddEditNotePage extends StatefulWidget {
  final Note? note;

  const AddEditNotePage({Key? key, this.note}) : super(key: key);

  @override
  State<AddEditNotePage> createState() => _AddEditNotePageState();
}

class _AddEditNotePageState extends State<AddEditNotePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  late int _selectedColorIndex;
  bool _isPinned = false;

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
      _selectedColorIndex = widget.note!.colorIndex;
      _isPinned = widget.note!.isPinned;
    } else {
      _selectedColorIndex = 0;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _saveNote() {
    if (_titleController.text.trim().isEmpty ||
        _contentController.text.trim().isEmpty) {
      _showValidationError();
      return;
    }

    final result = {
      'title': _titleController.text.trim(),
      'content': _contentController.text.trim(),
      'colorIndex': _selectedColorIndex,
      'isPinned': _isPinned,
      'isUpdate': widget.note != null,
    };

    Navigator.pop(context, result);
  }

  void _showValidationError() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.warning_amber_rounded,
                size: 60,
                color: const Color(0xFFFFB74D),
              ),
              const SizedBox(height: 20),
              const Text(
                'Validation Error',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Title and content cannot be empty',
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFF777777), fontSize: 16),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6C63FF),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'OK',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Note.colors[_selectedColorIndex];
    final primaryColor = colors['primary'] as Color;
    final accentColor = colors['accent'] as Color;

    return Scaffold(
      backgroundColor: primaryColor.withOpacity(0.1),
      body: Column(
        children: [
          // App Bar Section
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  primaryColor.withOpacity(0.3),
                  primaryColor.withOpacity(0.1),
                ],
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_rounded),
                      onPressed: () => Navigator.pop(context),
                      color: accentColor,
                    ),
                    Expanded(
                      child: Text(
                        widget.note == null ? 'New Note' : 'Edit Note',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: accentColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            _isPinned
                                ? Icons.push_pin
                                : Icons.push_pin_outlined,
                            color: accentColor,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPinned = !_isPinned;
                            });
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.save_rounded, color: accentColor),
                          onPressed: _saveNote,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Main Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Color Selection
                  SizedBox(
                    height: 60,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: Note.colors.length,
                      itemBuilder: (context, index) {
                        final colorData = Note.colors[index];
                        final currentPrimary = colorData['primary'] as Color;
                        final currentAccent = colorData['accent'] as Color;

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedColorIndex = index;
                            });
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            margin: const EdgeInsets.only(right: 12),
                            decoration: BoxDecoration(
                              color: currentPrimary,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: _selectedColorIndex == index
                                    ? currentAccent
                                    : Colors.transparent,
                                width: 3,
                              ),
                            ),
                            child: _selectedColorIndex == index
                                ? Icon(
                                    Icons.check,
                                    color: currentAccent,
                                    size: 20,
                                  )
                                : null,
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Title Input
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: accentColor.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _titleController,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF333333),
                      ),
                      decoration: InputDecoration(
                        hintText: 'Note Title',
                        hintStyle: TextStyle(
                          color: accentColor.withOpacity(0.5),
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(20),
                      ),
                      maxLines: 2,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Content Input
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: accentColor.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: 200,
                        maxHeight: MediaQuery.of(context).size.height * 0.4,
                      ),
                      child: TextField(
                        controller: _contentController,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF555555),
                          height: 1.6,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Start writing your thoughts...',
                          hintStyle: TextStyle(
                            color: accentColor.withOpacity(0.4),
                            fontSize: 16,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(20),
                        ),
                        maxLines: null,
                        expands: true,
                        keyboardType: TextInputType.multiline,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Statistics
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: accentColor.withOpacity(0.2)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem(
                          icon: Icons.text_fields,
                          value: _titleController.text.length.toString(),
                          label: 'Title\nChars',
                          color: accentColor,
                        ),
                        _buildStatItem(
                          icon: Icons.format_align_left,
                          value: _contentController.text
                              .split(' ')
                              .where((word) => word.isNotEmpty)
                              .length
                              .toString(),
                          label: 'Words',
                          color: accentColor,
                        ),
                        _buildStatItem(
                          icon: Icons.timer_outlined,
                          value:
                              '${(_contentController.text.length / 200).ceil()}',
                          label: 'Read\nTime',
                          color: accentColor,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _saveNote,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentColor,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 8,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            widget.note == null ? Icons.add : Icons.save,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            widget.note == null
                                ? 'Create Note'
                                : 'Save Changes',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20), // Extra padding at bottom
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 12, color: Color(0xFF777777)),
        ),
      ],
    );
  }
}
