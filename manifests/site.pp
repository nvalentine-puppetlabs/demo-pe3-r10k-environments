$domainname = hiera('domainname', 'r10k.puppetlabs.vm')

node 'base' {
  include ntp

  @@host { "${::hostname}.${domainname}":
    ensure => present,
    ip => $ipaddress_eth1,
    host_aliases => $hostname,
  }

  host { 'localhost.localdomain':
    ensure => present,
    ip => '127.0.0.1',
    host_aliases => 'localhost',
  }

  Host <<||>>
  resources { 'host': purge => true, }
}

node /^agent0.*$/ {
  class { 'gitolite': 
    admin_pub_key = hiera('gitolite::admin_pub_key')
  }
}

node default inherits base { 
  notify { "${::hostname} fell through to default node classification.": }
}
