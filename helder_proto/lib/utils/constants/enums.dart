
enum LetterKind {
  regular('Normale brief'),
  appointment('Afsrpaak'),
  invoice('Rekening'),
  tax('Belastingdienst');

  const LetterKind(this.kindName);
  final String kindName;
}