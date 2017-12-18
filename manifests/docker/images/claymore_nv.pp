# minebox::docker::images::claymore_nv
#
# Configures claymore dual miner Docker image.
#
# @summary A short summary of the purpose of this class
#
# @exam
#   include minebox::docker::images::claymore_nv

class minebox::docker::images::claymore_nv (
  String $docker_image = 'cultclassik/claymore-nv',
  String $image_tag = 'latest',
) {

  docker::image { $docker_image :
    image_tag => $image_tag,
  }

}
