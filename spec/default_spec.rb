require 'spec_helper'

include Helpers

describe 'sudoers::default' do
  let(:chef_run) { ChefSpec::Runner.new(:step_into => ['sudo']).converge(described_recipe) }

  subject { chef_run }
  before do
    stub_command('which sudo').and_return(false)
    stub_command(::File.exists?('/etc/sudoers.d/deluser')).and_return(true)
    ChefSpec::Server.create_data_bag(
      'sudoers',
        'testuser' => {
          'id' => 'testuser',
          'user' => 'testuser',
          'runas' => 'root',
          'commands' => ['/bin/ls', '/bin/false']
        },
        'testgroup' => {
          'id' => 'testgroup',
          'group' => 'testgroup',
          'commands' => '/bin/false'
        },
        'testgroup2' => {
          'id' => 'testgroup2',
          'user' => '%testgroup2',
          'commands' => '/bin/true'
        },
        'deluser' => {
          'id' => 'deluser',
          'action' => 'remove'
        }
    )
  end

  it 'should include the sudo cookbook' do
    chef_run.should include_recipe 'sudo'
  end

  it 'should render the sudoers files' do
    chef_run.should render_file('/etc/sudoers.d/testuser')
       .with_content line_regexp('testuser  ALL=(root) /bin/ls')

    chef_run.should render_file('/etc/sudoers.d/testuser')
      .with_content line_regexp('testuser  ALL=(root) /bin/false')

    chef_run.should render_file('/etc/sudoers.d/testgroup')
      .with_content line_regexp('%testgroup  ALL=(ALL) /bin/false')

    chef_run.should render_file('/etc/sudoers.d/testgroup2')
      .with_content line_regexp('%testgroup2  ALL=(ALL) /bin/true')
  end
end
