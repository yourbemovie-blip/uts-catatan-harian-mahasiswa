import 'dart:convert';
import 'dart:html' as html;
import '../models/note.dart';

String _safeFileName(String text) {
  final cleaned = text
      .trim()
      .replaceAll(RegExp(r'[^a-zA-Z0-9 _-]'), '')
      .replaceAll(RegExp(r'\s+'), '_');

  if (cleaned.isEmpty) {
    return 'catatan';
  }

  return cleaned.toLowerCase();
}

bool downloadNoteFile(Note note) {
  final fileName = '${_safeFileName(note.title)}.txt';

  final content = '''CATATAN HARIAN MAHASISWA

Judul    : ${note.title}
Tanggal  : ${note.date}
Kategori : ${note.category}

Isi Catatan:
${note.content}
''';

  final bytes = utf8.encode(content);
  final blob = html.Blob([bytes], 'text/plain;charset=utf-8');
  final url = html.Url.createObjectUrlFromBlob(blob);

  final anchor = html.AnchorElement(href: url)
    ..setAttribute('download', fileName)
    ..style.display = 'none';

  html.document.body?.append(anchor);
  anchor.click();
  anchor.remove();
  html.Url.revokeObjectUrl(url);

  return true;
}
