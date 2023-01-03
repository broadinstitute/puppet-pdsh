# @summary Create a group of hosts using the `pdsh_group.rb` script
#
# @example
#  pdsh::puppet_group {'rhel6':
#    ensure => 'present',
#    query  => '["and",["=",["fact","operatingsystem"],"RedHat"],["=",["fact","operatingsystemmajrelease"],"6"]]'
#  }
#
# @param query
#   String The query to pass to the `pdsh_group.rb` script to be used in querying PuppetDB.
# @param ensure
#   Whether this group should be present or absent.
#   (default: 'present')
#
define pdsh::puppet_group (
  String $query,
  Enum['absent', 'present'] $ensure = 'present',
) {
  file { "${pdsh::group_dir}/${name}":
    ensure => $ensure,
    group  => 'root',
    mode   => '0644',
    owner  => 'root',
  }

  # cron to update list every 30
  cron::job { "update_pdsh_group_${name}":
    ensure      => $ensure,
    command     => "/usr/local/sbin/pdsh_group.rb '${name}' '${query}' >/dev/null 2>&1",
    description => "PDSH Puppet group ${name}",
    minute      => '*/30',
    user        => 'root',
  }
}
