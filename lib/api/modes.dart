enum Mode {
  wave(name: 'Waves', value: 0x76),
  stroke(name: 'Stroke', value: 0x77),
  climb(name: 'Climb', value: 0x78),
  combo(name: 'Combo', value: 0x79),
  intense(name: 'Intense', value: 0x7a),
  rhythm(name: 'Rhythm', value: 0x7b),
  split(name: 'Split', value: 0x7f),
  random_1(name: 'Random1', value: 0x80),
  random_2(name: 'Random2', value: 0x81),
  toggle(name: 'Toggle', value: 0x82),
  orgasm(name: 'Orgasm', value: 0x83),
  torment(name: 'Torment', value: 0x84),
  phase_1(name: 'Phase 1', value: 0x85),
  phase_2(name: 'Phase 2', value: 0x86),
  phase_3(name: 'Phase 3', value: 0x87),
  ;

  const Mode({
    required this.name,
    required this.value,
  });

  final String name;
  final int value;
}
