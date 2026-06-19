String moodLabel(int level) {
  return switch (level.clamp(0, 4)) {
    0 => 'Radiante',
    1 => 'Feliz',
    2 => 'Calmo',
    3 => 'Ansioso',
    _ => 'Triste',
  };
}
