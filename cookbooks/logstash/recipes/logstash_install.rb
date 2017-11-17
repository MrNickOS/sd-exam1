cookbook_file '/etc/yum.repos.d/logstash.repo' do
  source 'logstash.repo'
  mode 0644
  owner 'root'
  group 'wheel'
end

cookbook_file '/etc/yum.repos.d/openssl.cnf' do
  source 'openssl.cnf'
  mode 0644
  owner 'root'
  group 'wheel'
end

cookbook_file '/etc/yum.repos.d/logstash-forwarder.crt' do
  source 'logstash-forwarder.crt'
  mode 0644
  owner 'root'
  group 'wheel'
end

bash 'install' do
  user 'root'
  code <<-EOH
  yum makecache fast
  yum -y install java
  yum -y install logstash
  EOH
end
