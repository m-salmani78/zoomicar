String wordInCombination(String word) {
  if (word.trim()[word.trim().length - 1] == 'ا') {
    return word + 'ی';
  }
  return word;
}
