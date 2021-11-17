
describe package('apache2') do
  it { should be_installed }
end

describe file('/var/www/html/index.html') do
  it { should exist }
  its('content') { should match(/Hello/) } 
end

describe upstart_service('apache2') do
   it { should be_enabled }
   it { should be_running }
end

describe command('curl localhost') do
    its('stdout') { should match(/Hello/)}
end
