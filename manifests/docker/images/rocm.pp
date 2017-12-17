# rocm
#
# Pulls AMD rocm Docker image.
#
# @summary A short summary of the purpose of this class
#
# @exam
#   include minebox::docker::images::rocm

class minebox::docker::images::rocm
(
  String $docker_image = 'rocm/rocm-terminal',
  String $image_tag = 'latest',
)
{

  docker::image { $docker_image :
    image_tag => $image_tag,
  }

}
