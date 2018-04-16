# bulk_pluginsync
#
# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include bulk_pluginsync
class bulk_pluginsync(
  $compile_master_pool_address = $facts['fqdn'],
){

  $command = 'cd /opt/puppetlabs/puppet/cache/; tar -czvf /opt/puppetlabs/server/data/packages/public/bulk_pluginsync.tar.gz lib'

  cron { 'create tar.gz of pluginsync cache':
    command => $command,
    hour    => '*',
    notify  => Exec['create tar.gz of pluginsync cache - onetime']
  }

  exec { 'create tar.gz of pluginsync cache - onetime':
    path        => $facts['path'],
    command     => $command,
    refreshonly => true,
  }

  file { '/opt/puppetlabs/server/data/packages/public/current/bulk_pluginsync.bash':
    mode    => '0644',
    content => epp('bulk_pluginsync/bulk_pluginsync.bash.epp',
                    { 'compile_master_pool_address' => $compile_master_pool_address }
                  ),
  }

}
