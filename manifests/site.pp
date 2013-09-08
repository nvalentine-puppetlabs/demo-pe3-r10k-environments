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

node /^agent0.*$/ {
  class { 'gitolite': 
#    admin_pub_key => hiera('gitolite::admin_pub_key')
    admin_pub_key => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCxo0CLz8UIFMfhBGunu25HLwHSfkWzUpYUATOMHZOxV053YT6pRS+OLB5wc7M826JzriGQ8S5pweUPEbksN1OdzSfT/YDiw39uGep8Eoj5FoRwGAWv8Maoeif/t24KNHnW+IiI4hTnzPJXAmwoJXIXa2O6ZK323rYYBF/QmfPLcKXPWKKMSjfkskYPFcNIDyZ7Gfzou9UStZ85fTAhQa4KyKJ3v7UPvLVZChXbIoiC2xo0jW5ocKFfRUkktNfU2YvQZFT1/0wMnh2man7LbTlK9Wmh/BVnPO36iQ86PST7tw0ITf2ebHU1g4RTcruTwioyxwiF9Nxfi8LqQbccvHPJ nathan@puppetlabs.com'
  }
}

node default inherits base { 
  notify { "${::hostname} fell through to default node classification.": }
}
