user { ['lbetz', 'tredel', 'tgelf']:
  ensure     => present,
  managehome => true,
}

system::user { 'lbetz':
  key     => 'test1',
  require => User['lbetz']
}

system::user { 'tredel':
  key     => 'test2',
  tag     => ['lbetz', 'tgelf'],
  require => User['tredel']
}

system::user { 'tgelf':
  key     => 'test3',
  tag     => 'lbetz',
  require => User['tgelf']
}
