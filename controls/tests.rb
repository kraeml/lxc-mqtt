lxc_containers = input('lxc_containers')
#puts input_object('lxc_mqtt').diagnostic_string

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
  title 'Erstellen der LXC Maschinen'
  desc 'Erstellen der Maschine'
  lxc_containers.each do |machine|
    describe package('mosquitto') do
      it { should be_installed }
    end
  end
end

control 'ports' do
  impact 1.0
  title 'Erstellen der LXC Maschinen'
  desc 'Erstellen der Maschine'
  lxc_containers.each do |machine|
    describe port(1883) do
      it { should be_listening }
      its('protocols') {should eq ['tcp', 'tcp6']}
      its('addresses') {should eq ['0.0.0.0', '::']}
    end
  end
end

control 'services' do
  impact 1.0
  title 'Erstellen der LXC Maschinen'
  desc 'Erstellen der Maschine'
  lxc_containers.each do |machine|
    describe service('mosquitto') do
      it { should be_installed }
      it { should be_enabled }
      it { should be_running }
    end
  end
end
