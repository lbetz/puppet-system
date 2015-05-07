include system

system::user { 'lbetz':
  ensure  => present,
  key     => 'AAAAB3NzaC1yc2EAAAABIwAAAQEAtZHd3tS7ynYfGDCiFRhfI2GMmLbKX/Gtblyx62kgI3CpPeR8UiHLWUs6mCXbkU7xJSoswdnovLhppPS8u4CS4/Jt8N2yvtqy1uPmCDpiD+kNPgF/k9jSrnGZ1XFSa5a75sG+olfRVd/gSedxchNezHjIghWLQZOigpFMYNY+skj4EyWd6KMJ+GQSI4+UlKq56EZqWCEasLbazgKzhUUhwwDnftFU9F9baiUgh8ZxVzUBwT/MUNXM6XTPtoN0ZtuOWsVtDfQXfC/z0r9WiDTVNAsSSapbSKz1kANyIfSZfF/QAThWowGBwEneGz0gguc9IePzYh2ZgGHIkB8qNYXxFw=='
}

system::user { 'tredel':
  ensure  => absent,
  key     => 'test',
  tag     => ['lbetz', 'tgelf'],
}

system::user { 'tgelf':
  ensure  => absent,
  key     => 'test2',
  tag     => 'lbetz',
}
