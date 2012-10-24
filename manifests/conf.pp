# Define: sudo::conf
#
# This module manages sudoa configurations
#
# Parameters:
#   [*ensure*]
#     Ensure if present or absent.
#     Default: present
#
#   [*priority*]
#     Prefix file name with $priority
#     Default: 10
#
#   [*content*]
#     Content of configuration snippet.
#     Default: undef
#
#   [*source*]
#     Source of configuration snippet.
#     Default: undef
#
#   [*sudo_config_dir*]
#     Where to place configuration snippets.
#     Only set this, if your platform is not supported or
#     you know, what you're doing.
#     Default: auto-set, platform specific
#
# Actions:
#   Installs sudo configuration snippets
#   Checks configuration snippets for syntax errors and removes failures
#
# Requires:
#   Class sudo
#
# Sample Usage:
#   sudo::conf { 'admins':
#     source => 'puppet:///files/etc/sudoers.d/admins',
#   }
#
# [Remember: No empty lines between comments and class definition]
define sudo::conf(
  $ensure = present,
  $priority = 10,
  $content = undef,
  $source = undef,
  $sudo_config_dir = $sudo::params::config_dir
) {

  Class['sudo'] -> Sudo::Conf[$name]

  if $content != undef {
    $content_real = "${content}\n"
  } else {
    $content_real = undef
  }

  $path = "${sudo_config_dir}${priority}_${name}"
  
  file { "${priority}_${name}":
    ensure  => $ensure,
    path    => $path,
    owner   => 'root',
    group   => $sudo::params::config_file_group,
    mode    => '0440',
    source  => $source,
    content => $content_real,
    notify  => Exec["check ${priority}_${name} sudo syntax"],
  }

  # Don't deploy a broken config file!
  exec { "check ${priority}_${name} sudo syntax":
    command     => "/bin/rm $path",
    unless      => "/usr/sbin/visudo -c -f $path",
    refreshonly => true,
  }
    
}
