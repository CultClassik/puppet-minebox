# minebox::amd::config
#
# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include minebox::amd::config
class minebox::amd::config {
  # Enable large page support and reboot if the resource updates
  file_line { 'Enable large page support':
    path => '/etc/default/grub',
    #line => 'GRUB_CMDLINE_LINUX_DEFAULT="nomodeset amdgpu.vm_fragment_size=9"',
    line => 'GRUB_CMDLINE_LINUX_DEFAULT="quiet splash amdgpu.vm_fragment_size=9"',
    match => '^GRUB_CMDLINE_LINUX_DEFAULT=.*$',
  }
}
