# minebox::tools::atiflash
#
# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include minebox::tools::atiflash
class minebox::tools::atiflash (
  String $files_path,
){

  archive { "${files_path}/atiflash.tar.xz" :
      ensure          => present,
      cleanup         => true,
      extract         => true,
      extract_path    => "${files_path}",
      source          => 'https://s3-us-west-1.amazonaws.com/mastermine/minebox/atiflash_linux.tar.xz',
      user            => $minebox::miner_user,
      group           => $minebox::miner_group,
      creates         => "${files_path}/atiflash",
    }

}
