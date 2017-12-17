# cryptomine::amd::rocm
#
# Configures Amd specific items for headless Xorg server
#
# @summary A short summary of the purpose of this class
#
# @exam
#   include minebox::amd
class minebox::amd::rocm {

  # Add the amd deb repo -- deb [arch=amd64] http://repo.radeon.com/rocm/apt/debian/ xenial main
   apt::source { 'rocm' :
    location     => 'http://repo.radeon.com/rocm/apt/debian/',
    architecture => 'amd64',
    release      => 'xenial',
    repos        => 'main',
    key          => {
      'id'     => 'CA8BB4727A47B4D09B4EE8969386B48A1A693C5C',
      'source' => 'http://repo.radeon.com/rocm/apt/debian/rocm.gpg.key',
    },
    include      => {
      'deb' => true,
    },
  }

  ### addding rocm package causes errors if it's already installed, may need to use regex on the kernal to ensure it doesn't contain rocm before proceeding
  #-> package { 'rocm' :
  #  ensure => present,
  #}

  exec { 'Update GRUB':
    command     => '/usr/sbin/update-grub',
    refreshonly => true,
    subscribe   => File_line['Enable large page support'],
  }

  reboot { 'after':
    subscribe => Exec['Update GRUB'],
  }

  file { '/etc/profile.d/amdgpu-pro.sh':
    ensure  => file,
    content => 'export LLVM_BIN=/opt/amdgpu-pro/bin'
  }

}
