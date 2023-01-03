# @summary Set up PuppetDB-based pdsh groups
#
# @example
#  class { 'pdsh::puppet'
#    $queries => {
#      rhel6 => {
#        ensure => 'present',
#        query  => '["and",["=",["fact","operatingsystem"],"RedHat"],["=",["fact","operatingsystemmajrelease"],"6"]]'
#      }
#      rhel7 => {
#        ensure => 'absent',
#        query  => '["and",["=",["fact","operatingsystem"],"RedHat"],["=",["fact","operatingsystemmajrelease"],"7"]]'
#      }
#    }
#  }
#
# @param puppetdb
#   String The hostname of the PuppetDB server to use.
# @param queries
#   Hash of queries to be used in creating pdsh::puppet_group resources.
class pdsh::puppet (
  String $puppetdb,
  Hash $queries = {},
) {
  $ca_file = $facts['localcacert']

  file { '/usr/local/sbin/pdsh_group.rb':
    content => epp(
      'pdsh/puppet_group.rb.epp',
      {
        ca_file     => $facts['localcacert'],
        group_dir   => $pdsh::group_dir,
        hostcert    => $facts['puppet_settings']['main']['hostcert'],
        hostprivkey => $facts['puppet_settings']['main']['hostprivkey'],
        puppetdb    => $puppetdb,
      }
    ),
    group   => 'root',
    mode    => '0755',
    owner   => 'root',
  }

  create_resources(pdsh::puppet_group, $queries)
}
