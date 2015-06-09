require 'spec_helper'

describe 'selinux' do

  context 'package' do

    context 'on RedHat 5 based OSes' do
      let(:facts) { { :osfamily => 'RedHat', :operatingsystemmajrelease => '5', :selinux_current_mode => 'enforcing' } }

      it { should contain_package('policycoreutils').with(:ensure => 'installed') }
    end

    [ '6', '7' ].each do |majrelease|
      context "On RedHat #{majrelease} based OSes" do
        let(:facts) { { :osfamily => 'RedHat', :operatingsystemmajrelease => majrelease, :selinux_current_mode => 'enforcing' } }

        it { should contain_package('policycoreutils-python').with(:ensure => 'installed') }
      end
    end


  end

end

