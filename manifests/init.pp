# @summary Installs and configures the pdsh tool
#
# @param config_dir
#   Stdlib::Absolutepath The configuration directory for pdsh.
#   (default: `/etc/dsh`).
# @param group_dir
#   Stdlib::Absolutepath The directory where group files for pdsh will be written.
#   (default: `/etc/dsh/group`).
#
class pdsh (
  Stdlib::Absolutepath $config_dir,
  Stdlib::Absolutepath $group_dir,
){
  if ! $group_dir {
    fail('The group directory cannot be empty')
  }
  if $group_dir == '/' {
    fail('The group directory cannot be /')
  }

  # base level rhel pdsh install
  package { 'pdsh':
    ensure          => installed,
    install_options => '--nogpgcheck',
  }
  package { 'pdsh-mod-dshgroup':
    ensure          => installed,
    install_options => '--nogpgcheck',
  }
  package { 'pdsh-rcmd-ssh':
    ensure          => installed,
    install_options => '--nogpgcheck',
  }
  file { $config_dir:
    ensure => 'directory',
  }
  file { $group_dir:
    ensure  => 'directory',
    purge   => true,
    recurse => true,
    require => File[$config_dir],
  }

  include pdsh::puppet
}
