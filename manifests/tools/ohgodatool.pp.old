# minebox::tools::ohgodatool
#
# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include minebox::tools::ohgodatool
class minebox::tools::ohgodatool (
  String $files_path,
){

  archive { "${files_path}/ohgodatool" :
      ensure       => absent,
      cleanup      => false,
      extract      => false,
      extract_path => $files_path,
      source       => 'https://github.com/OhGodACompany/OhGodATool/releases/download/1/ohgodatool',
      user         => $minebox::miner_user,
      group        => $minebox::miner_group,
      creates      => "${files_path}/ohgodatool",
  }

  -> file { "${files_path}/ohgodatool" :
    ensure => absent,
    owner => $minebox::miner_user,
    group => $minebox::miner_group,
    mode  => '0774',
  }

}
