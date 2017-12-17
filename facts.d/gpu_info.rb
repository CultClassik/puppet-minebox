Facter.add('gpu_info') do
  setcode do
    Facter::Core::Execution.exec('/usr/bin/curl -s http://localhost:3476/v1.0/gpu/info/json')
  end
end
