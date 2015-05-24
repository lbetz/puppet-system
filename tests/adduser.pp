user { ['lbetz', 'tredel', 'tgelf']:
  ensure     => present,
  managehome => true,
}

user { 'root':
  ensure => present,
}

system::user { 'root': }

system::user { 'lbetz':
  key     => 'test1',
}

system::user { 'tredel':
  key     => 'test2',
  tag     => ['lbetz', 'tgelf'],
}

system::user { 'tgelf':
  key     => 'test3',
  tag     => ['lbetz', 'root'],
}
