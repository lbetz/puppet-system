define system::user(
  $ensure   = 'present',
  $user     = $title,
  $key      = false,
  $key_type = 'ssh-rsa',
) {

  # Validation
  validate_re($ensure, '^(present|absent)$', 'Validated values for ensure are present and absent.')
  validate_re($key_type, '^(ssh-dss|ssh-rsa|ecdsa-sha2-nistp256|ecdsa-sha2-nistp384|ecdsa-sha2-nistp521)$', 'Validated values for key_type are ssh-dss, ssh-rsa, ecdsa-sha2-nistp256, ecdsa-sha2-nistp384 and ecdsa-sha2-nistp521.')

  # Set helper variables
  $homedir = $user ? {
    'root'  => '/root',
    default => "/home/$user",
  }

  $_tag = concat(any2array($tag), $user)
  $users = parseyaml(inline_template(
    '<%= @_tag.inject({}) {|h, x| h[@user + "4" + x] = { :user => x }; h}.to_yaml %>'))

  # Realize and dependency
  if $ensure == 'present' {
    File[$homedir] -> Ssh_authorized_key <| user == $user |> }
  else {
    Ssh_authorized_key <| user == $user |> -> User[$user]
  }

  # Resources
  user { $user:
    ensure => $ensure,
    home   => $homedir,
  }

  file { $homedir:
    ensure  => $ensure ? {
      'absent' => 'absent',
      default  => 'directory',
    },
    owner   => $user,
    group   => $user,
    mode    => '0750',
    purge   => true,
    force   => true,
  }

  if $key {
    create_resources('@ssh_authorized_key', $users, {
      ensure => $ensure,
      key    => $key,
      type   => $key_type,
    })
  }

}
