require 'spec_helper'

include Helpers

describe 'sudoers::default' do
  let(:chef_run) { ChefSpec::Runner.new(:step_into => ['sudo']).converge(described_recipe) }

  subject { chef_run }
  before do
    stub_command('which sudo').and_return(false)
    ChefSpec::Server.create_data_bag(
      'sudoers',
        'testuser' => {
          'id' => 'testuser',
          'user' => 'testuser',
          'runas' => 'root',
          'commands' => ['/bin/ls', '/bin/false']
        }
    )
  end

  it 'should include the sudo cookbook' do
    chef_run.should include_recipe 'sudo'
  end

  it 'should render the sudoers file' do
    chef_run.should render_file('/etc/sudoers.d/testuser')
       .with_content line_regexp('testuser  ALL=(root) /bin/ls')

    chef_run.should render_file('/etc/sudoers.d/testuser')
      .with_content line_regexp('testuser  ALL=(root) /bin/false')
  end
end
