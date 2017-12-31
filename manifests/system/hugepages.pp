# minebox::system::hugepages
#
# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include minebox::system::hugepages
class minebox::system::hugepages (
){

  if $minebox::cpu_mining == true {
    $hugepages = present
  }

  file { '/dev/hugepages' :
    ensure => directory
  }

  -> file_line { 'Mount Huge Pages' :
    ensure => $hugepages,
    path => '/etc/fstab',
    line => 'hugetlbfs /dev/hugepages hugetlbfs defaults 0 0',
  }

  -> exec { 'Refresh mounts for Huge Pages' :
    command     => '/bin/mount',
    subscribe   => File_line['Mount Huge Pages'],
    refreshonly => true,
  }

}
