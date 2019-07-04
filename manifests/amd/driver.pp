# minebox::amd::driver
#
# Configures Amd specific items for headless Xorg server
#
# @summary A short summary of the purpose of this class
# https://diehlabstorage.blob.core.windows.net/mine/amdgpu-pro-19.20-812932-ubuntu-18.04.tar.xz
#
# http://support.amd.com/en-us/kb-articles/Pages/AMDGPU-PRO-Install.aspx
#
# @exam
#   include minebox::amd::driver
class minebox::amd::driver(
  String $amd_driver,
  String $driver_url = $::minebox::amd_driver_url,
){

  $driver_file = "${amd_driver}.tar.xz"
  $driver_path = "${minebox::base_path}/drivers"
  $installer = "${driver_path}/${amd_driver}/amdgpu-pro-install"

  archive { "${driver_path}/${driver_file}" :
    ensure       => present,
    cleanup      => true,
    extract      => true,
    extract_path => $driver_path,
    source       => $::minebox::amd::driver::driver_url,
    creates      => $installer,
  }

  -> file { $installer :
    mode   => '0774',
  }

  exec { 'Install AMD PRO GPU Blockchain Driver' :
    command     => "${installer} --opencl=legacy,rocm --headless --compute -y",
    subscribe   => Archive["${driver_path}/${driver_file}"],
    refreshonly => true,
    # added - test
    #notify      => Reboot['after_run'],
  }

  file { '/etc/profile.d/amdgpu-pro.sh' :
    ensure  => file,
    mode    => '0774',
    content => 'export LLVM_BIN=/opt/amdgpu-pro/bin',
  }

}
