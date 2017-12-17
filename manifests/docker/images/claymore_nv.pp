# claymore_nv
#
# Configures claymore dual miner Docker image.
#
# @summary A short summary of the purpose of this class
#
# @exam
#   include minebox::docker::images::claymore_nv

class minebox::docker::images::claymore_nv
(
  String $docker_image = 'cultclassik/claymore-nv',
  String $image_tag = 'latest',
  String $wallet_eth = '0x96ae82e89ff22b3eff481e2499948c562354cb23',
  String $wallet_lbry = '',
  String $wallet_sia = '9e4337a945bdcbb7e9edfc6889a89202ea4e72d1ea389d8090bf117656e83bcb223626f10681',
  String $wallet_xmr = '447vxA7StEu5Ht9p8MiWNmhLo48dYnfwPGUYtxUAArxKD6DkSthnQiVL843NKEC1oGTS6Gmu3XaoK3uBcQ118zXaFPjLdxz',
)
{

  docker::image { $docker_image :
    image_tag => $image_tag,
  }

}
