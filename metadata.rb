name             'sudoers'
maintainer       'Scott Lampert'
maintainer_email 'scott@lampert.org'
license          'Apache 2.0'
description      'Installs/Configures sudoers'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

%w(ubuntu debian redhat centos).each { |os| supports os }

depends 'sudo'
