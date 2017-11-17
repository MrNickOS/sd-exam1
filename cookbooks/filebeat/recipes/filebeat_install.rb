cookbook_file '/etc/pki/tls/certs/logstash-forwarder.crt' do
    source 'logstash-forwarder.crt'
    mode 0644
    owner 'root'
    group 'wheel'
end

bash 'import' do
  user 'root'
  code <<-EOH
  yum makecache fast
  rpm --import http://packages.elastic.co/GPG-KEY-elasticsearch
  EOH
end

cookbook_file '/etc/yum.repos.d/filebeat.repo' do
    source 'filebeat.repo'
    mode 0644
    owner 'root'
    group 'wheel'
end

bash 'install' do
  user 'root'
  code <<-EOH
  yum -y install filebeat
  EOH
end

cookbook_file '/etc/filebeat/filebeat.yml' do
    source 'filebeat.yml'
    mode 0644
    owner 'root'
    group 'wheel'
end

bash 'start filebeat' do
  user 'root'
  code <<-EOH
  systemctl daemon-reload
  systemctl start filebeat
  systemctl enable filebeat
  systemctl restart network
  EOH
end
