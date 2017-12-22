# minebox::amd::driver
#
# Configures Amd specific items for headless Xorg server
#
# @summary A short summary of the purpose of this class
#
# http://support.amd.com/en-us/kb-articles/Pages/AMDGPU-PRO-Install.aspx
#
# @exam
#   include minebox::amd::driver
class minebox::amd::driver {
  # Can't download direct from AMD :(
  #$amd_driver_url = "https://www2.ati.com/drivers/linux/beta/ubuntu/${minebox::amd_driver}.tar.xz"

  $driver_file = "${minebox::amd_driver}.tar.xz"
  $driver_path = "${minebox::base_path}/drivers"
  $installer = "${driver_path}/${minebox::amd_driver}/amdgpu-pro-install"

  package { 'clinfo' :
    ensure => present,
  }

  archive { "${driver_path}/${driver_file}" :
    ensure       => present,
    cleanup      => true,
    extract      => true,
    extract_path => $driver_path,
    source       => "https://s3-us-west-1.amazonaws.com/mastermine/minebox/{$driver_file}",
    creates      => "${driver_path}/${minebox::amd_driver}/amdgpu-pro-install",
  }

  -> file { $installer :
    ensure => file,
    mode   => '0774',
  }

  exec { 'Install AMD PRO GPU Blockchain Driver' :
    command     => "${installer} --compute -y",
    subscribe   => File[$installer],
    refreshonly => true,
  }

}
