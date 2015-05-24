user { ['lbetz', 'tredel']:
  ensure     => present,
  managehome => true,
}

system::user { 'lbetz':
  key     => 'test1',
}

system::user { 'tredel':
  key     => 'test2',
  tag     => ['lbetz', ],
}

system::user { 'tgelf':
  ensure => absent,
  key    => 'test3',
  tag    => 'lbetz',
}

user { 'tgelf':
  ensure     => absent,
  managehome => true,
}
