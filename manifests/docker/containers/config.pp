# minebox::docker::containers::config
#
# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# NOTE! the image name received must match a defined type name
#
# @example
#   include minebox::docker::containers::config
class minebox::docker::containers::config (
  Array $gpus,
) {

  notify { 'Applying Docker GPU Miner Container Class..' : }

  $gpus.each |Hash $gpu| {

    # generate full image name from repo and image variable values
    $docker_image = "${gpu['miner']['repo']}/${gpu['miner']['image']}:${gpu['miner']['tag']}"

    # generate worker id
    $worker_id = "gpu${gpu['id']}"

    # set worker id in docker command
    $command = regsubst($gpu['miner']['command'], 'WORKER_ID', $worker_id)

    # generate the container name
    $container_name = "m-${worker_id}"

    # replace dashes with underscores in the resource type
    $resource_type = regsubst("minebox::docker::types::${gpu['miner']['image']}::miner", '-', '_', "G")

    ensure_resource(
      $resource_type,
      $container_name,
      {
        gpu_id         => $gpu['id'],
        container_name => $container_name,
        image          => $docker_image,
        command        => $command,
      }
    )
  }

}
