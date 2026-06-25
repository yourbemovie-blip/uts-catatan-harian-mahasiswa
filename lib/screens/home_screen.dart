import 'package:flutter/material.dart';
import '../models/note.dart';
import '../helpers/note_download_helper.dart';
import '../widgets/note_card.dart';
import '../widgets/section_title.dart';
import '../widgets/stat_card.dart';
import 'add_edit_note_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Note> notes = [
    Note(
      title: 'Belajar Flutter',
      content: 'Mengerjakan tugas UTS Pemrograman Mobile menggunakan Flutter dengan tampilan profesional.',
      date: '20 Juni 2026',
      category: 'Kuliah',
    ),
    Note(
      title: 'Upload Source Code',
      content: 'Setelah aplikasi selesai, source code akan diupload ke akun GitHub dan link dimasukkan ke laporan PDF.',
      date: '20 Juni 2026',
      category: 'Tugas',
    ),
    Note(
      title: 'Rekam Video Presentasi',
      content: 'Video presentasi minimal 30 menit, wajah mahasiswa terlihat, lalu upload ke Google Drive atau YouTube.',
      date: '20 Juni 2026',
      category: 'Pribadi',
    ),
  ];

  void openAddNote() async {
    final result = await Navigator.push<Note>(
      context,
      MaterialPageRoute(builder: (context) => const AddEditNoteScreen()),
    );

    if (result != null) {
      setState(() {
        notes.insert(0, result);
      });
    }
  }

  void openEditNote(int index) async {
    final result = await Navigator.push<Note>(
      context,
      MaterialPageRoute(builder: (context) => AddEditNoteScreen(note: notes[index])),
    );

    if (result != null) {
      setState(() {
        notes[index] = result;
      });
    }
  }


  void downloadNote(int index) {
    final success = downloadNoteFile(notes[index]);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(
          success
              ? 'Catatan berhasil didownload ke perangkat.'
              : 'Download langsung hanya aktif saat aplikasi dijalankan di browser/Flutter Web.',
        ),
      ),
    );
  }

  void deleteNote(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        title: const Text('Hapus Catatan?'),
        content: const Text('Catatan yang sudah dihapus tidak dapat dikembalikan.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              setState(() {
                notes.removeAt(index);
              });
              Navigator.pop(context);
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  int countByCategory(String category) {
    return notes.where((note) => note.category == category).length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Catatan'),
        actions: [
          IconButton(
            tooltip: 'Profil Mahasiswa',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
            icon: const Icon(Icons.account_circle_outlined),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: openAddNote,
        icon: const Icon(Icons.add),
        label: const Text('Tambah'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 22, 20, 90),
          children: [
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1E3A8A), Color(0xFF0F766E)],
                ),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1E3A8A).withOpacity(0.22),
                    blurRadius: 25,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: const Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Selamat Datang',
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Kelola catatan kuliah dengan lebih rapi dan mudah.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 21,
                            height: 1.25,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16),
                  Icon(Icons.auto_stories_rounded, color: Colors.white, size: 54),
                ],
              ),
            ),
            const SizedBox(height: 22),
            Row(
              children: [
                StatCard(
                  title: 'Total Catatan',
                  value: notes.length.toString(),
                  icon: Icons.note_alt_outlined,
                  color: const Color(0xFF1E3A8A),
                ),
                const SizedBox(width: 12),
                StatCard(
                  title: 'Tugas',
                  value: countByCategory('Tugas').toString(),
                  icon: Icons.task_alt_rounded,
                  color: const Color(0xFFB45309),
                ),
              ],
            ),
            const SizedBox(height: 26),
            const SectionTitle(
              title: 'Daftar Catatan',
              subtitle: 'Catatan terbaru akan tampil di bagian atas.',
            ),
            const SizedBox(height: 16),
            if (notes.isEmpty)
              Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.inbox_outlined, size: 54, color: Color(0xFF94A3B8)),
                    SizedBox(height: 12),
                    Text('Belum ada catatan', style: TextStyle(fontWeight: FontWeight.w700)),
                    SizedBox(height: 6),
                    Text('Tekan tombol tambah untuk membuat catatan baru.'),
                  ],
                ),
              )
            else
              ...List.generate(
                notes.length,
                (index) => NoteCard(
                  note: notes[index],
                  onEdit: () => openEditNote(index),
                  onDownload: () => downloadNote(index),
                  onDelete: () => deleteNote(index),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
