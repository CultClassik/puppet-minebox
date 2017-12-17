# ethminer_nv
#
# Configures ethminer Docker image.
#
# @summary A short summary of the purpose of this class
#
# @exam
#   include minebox::docker::images::ethminer_nv

class minebox::docker::images::ethminer_nv
(
  String $docker_image = 'cultclassik/ethminer-nv',
  String $image_tag = 'latest',
  #String $wallet = '0x96ae82e89ff22b3eff481e2499948c562354cb23',
)
{

  docker::image { $docker_image :
    image_tag => $image_tag,
  }

}
