require 'spec_helper'

describe 'selinux::boolean' do
  let(:title) { 'mybool' }
  let(:facts) { {
    :osfamily => 'RedHat',
    :operatingsystemmajrelease => '7',
    :selinux_current_mode => 'enforcing',
  } }

  context 'default' do
    it { should contain_exec("setsebool -P 'mybool' true")}
  end

  ['on', true].each do |value|
    context value do
      let(:params) { { :ensure => value } }
      it { should contain_exec("setsebool -P 'mybool' true")}
    end
  end

  ['off', false].each do |value|
    context value do
      let(:params) { { :ensure => value } }
      it { should contain_exec("setsebool -P 'mybool' false")}
    end
  end

end
