# minebox::windows::tools
#
# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include minebox::windows::tools
class minebox::windows::tools (
  Array $packages = [
    'chocolatey',
    'gpu-z',
    'hwinfo.portable',
  ],
  Array $archives = [
    'https://www.monitortests.com/atikmdag-patcher-1.4.6.zip',
    'https://onedrive.live.com/download?cid=0439AD70307A0AB4&resid=439AD70307A0AB4%2115937&authkey=AEndRVqUqVLFlYM', # what is this?
  ],
  Array $files = [],
  Array $amd_tools = [],

) {

  # Install required packages
  ensure_packages(
    $minebox::windows::tools::packages,
    {
      ensure => present,
    }
  )

  # Download archives
  #...
}
