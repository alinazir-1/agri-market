import 'dart:convert';
import 'dart:io';

void main() {
  const transcriptPath =
      r'C:\Users\Ali\.cursor\projects\d-agri-market\agent-transcripts\3fa7e56e-6f26-4753-a17e-28a71cd818a6\3fa7e56e-6f26-4753-a17e-28a71cd818a6.jsonl';
  const needle = 'Varieties: Yellow Dent';
  final file = File(transcriptPath);
  if (!file.existsSync()) {
    stderr.writeln('Missing transcript: $transcriptPath');
    exit(1);
  }
  for (final line in file.readAsLinesSync()) {
    if (!line.contains(needle)) continue;
    final obj = jsonDecode(line) as Map<String, dynamic>;
    final content = obj['message']?['content'];
    if (content is! List) continue;
    for (final block in content) {
      if (block is Map && block['type'] == 'text') {
        final t = block['text'] as String? ?? '';
        if (t.contains(needle)) {
          File('tool/user_varieties_message.txt').writeAsStringSync(t);
          stdout.writeln('Wrote tool/user_varieties_message.txt (${t.length} chars)');
          return;
        }
      }
    }
  }
  stderr.writeln('Line not found');
  exit(2);
}
