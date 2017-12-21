require 'spec_helper'

describe 'minebox::docker::containers::claymore_nv' do
  let(:title) { 'namevar' }
  let(:params) do
    {}
  end

  on_supported_os(facterversion: '2.4').each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
    end
  end
end