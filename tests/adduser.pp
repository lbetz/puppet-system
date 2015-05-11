system::user { 'lbetz':
  ensure  => present,
  key     => 'test1',
}

system::user { 'tredel':
  ensure  => present,
  key     => 'test2',
  tag     => ['lbetz', 'tgelf'],
}

system::user { 'tgelf':
  ensure  => present,
  key     => 'test3',
  tag     => 'lbetz',
}
