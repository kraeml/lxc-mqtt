lxc_containers = input('lxc_containers')
puts input_object('lxc_containers').diagnostic_string

control 'machines' do
  impact 1.0
  title 'Erstellen der LXC Maschinen'
  desc 'Erstellen der Maschine'
  lxc_containers.each do |machine|
    describe bash('sudo lxc-ls') do
      # Gefolgt von einem Whitespace
      its('stdout') { should match /#{machine[:'name']}\s+/ }
    end
    if bash('sudo lxc-ls --running | grep ' + machine[:'name']).exit_status != 0
      describe bash('sudo lxc-start --name ' + machine[:'name']) do
        its('exit_status') { should cmp 0 }
      end
    end
  end
end

control 'packages' do
  impact 1.0
  title 'Software auf der LXC Maschinen'
  desc 'Pakete auf der Maschine'
  lxc_containers.each do |machine|
    machine[:'apt'][:'name'].each do |package|
      describe package(package) do
        it { should be_installed }
      end
    end
  end
end

control 'ports' do
  impact 1.0
  title 'Ports der LXC Maschinen'
  desc 'Ports der Maschine'
  lxc_containers.each do |machine|
    machine[:'ports'].each do |port|
      puts port
      describe port(port[:'listining']) do
        it { should be_listening }
        its('protocols') {should eq port[:'protocols']}
        its('addresses') {should eq port[:'addresses']}
      end
    end
  end
end

control 'services' do
  impact 1.0
  title 'Erstellen der LXC Maschinen'
  desc 'Erstellen der Maschine'
  lxc_containers.each do |machine|
    machine[:'services'].each do |service|
      describe service(service[:'name']) do
        it { should be_installed }
        it { should be_enabled }
        it { should be_running }
      end
    end
  end
end
