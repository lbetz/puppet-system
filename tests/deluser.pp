system::user { 'lbetz':
  key     => 'test1',
}

system::user { 'tredel':
  key     => 'test2',
  tag     => ['lbetz', 'tgelf'],
}

system::user { 'tgelf':
  ensure  => absent,
  key     => 'test3',
  tag     => 'lbetz',
}
