# == Define Resource: system::user
#
# Manage Users, their homedirs and ssh_authorized_keys.
# Also between differnt users on the same machine
#
# == Parameters
#
# In the current version, please use the tag parameter to assign
# the user's key to other users on the same machine.
#
# [*ensure*]
#   present or absent
#
# [*user*]
#   the user's account name, default sets to the title
#
# [*key*]
#   the user's key, default to false for no key
#
# [*key_type*]
#   and the key type, supported values:
#     * ssh-dss (ssh-dsa)
#     * ssh-rsa
#     * ecdsa-sha2-nistp256
#     * ecdsa-sha2-nistp256|ecdsa-sha2-nistp384
#     * ecdsa-sha2-nistp521
#
# === Examples
#
# Creates users lbetz and tredel and stores their own keys in
# their authorized_keys files. Additional the key of tredel is
# saved to lbetz's authorized_keys file.
#
# system::user { 'lbetz':
#   key => 'test1',
# }
#
# system::user { 'tredel':
#   key => 'test2',
#   tag => ['lbetz'],
# }
#
# Removes tredel including the key stored in lbetz's file.
# Caution: For removing a user the tag and key parameter have
# to set correctly, same vales are used for present.
#
# system::user { 'lbetz':
#   key => 'test1',
# }
#
# system::user { 'tredel':
#   ensure => absent,
#   key    => 'test2',
#   tag    => ['lbetz'],
# }
#
# === Author
#
# Author: Lennart betz <lennart.betz@netways.de>
#
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
