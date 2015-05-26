part of clay;

String _indent(String input, int tabs) {
  return input.split('\n').map((String line) {
    if (line == '') return '';
    return ('  ' * tabs) + line;
  }).join('\n');
}