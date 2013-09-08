$domainname = hiera('domainname', 'r10k.puppetlabs.vm')

node 'base' {
  include ntp

  @@host { "${::hostname}.${domainname}":
    ensure => present,
    ip => $ipaddress_eth1,
    host_aliases => $hostname,
  }

  host { 'localhost':
    ensure => present,
    ip => '127.0.0.1',
    host_aliases => 'localhost.localdomain',
  }

  Host <<||>>
  resources { 'host': purge => true, }
}

node default inherits base { 
  notify { "${::hostname} fell through to default node classification.": }
}
