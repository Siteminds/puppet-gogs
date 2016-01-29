require 'spec_helper'

describe 'gogs::install', :type => :class do
  context 'supported operating systems' do
    ['Debian', 'RedHat'].each do |osfamily|
      describe "gogs::install class without any parameters on #{osfamily}" do
        let(:params) do
          { 
            'package_ensure' => '1.2.3.4',
            'package_name'   => 'g0gz'
          }
        end
        let(:facts) do
          {
            :osfamily => osfamily,
            :lsbdistid => osfamily,
            :lsbdistcodename => 'trusty'
          }
        end
        it { is_expected.to contain_package('gogs')
               .with_ensure('1.2.3.4')
               .with_name('g0gz')
           }
      end
    end
  end

end
