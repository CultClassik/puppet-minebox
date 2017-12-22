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

  -> file { "${driver_path}/${minebox::amd_driver}/amdgpu-pro-install" :
    ensure => file,
    mode   => '0744',
  }

  exec { 'Install AMD PRO GPU Blockchain Driver' :
    command     => "${driver_path}/${minebox::amd_driver}/amdgpu-pro-install --compute -y",
    #subscribe   => Archive["${driver_path}/${driver_file}"],
    subscribe   => File["${driver_path}/${minebox::amd_driver}/amdgpu-pro-install"],
    refreshonly => true,
  }

}
