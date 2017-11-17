bash 'install elastic' do
  user 'root'
  code <<-EOH
  yum makecache fast
  yum -y install java
  rpm --import http://packages.elastic.co/GPG-KEY-elasticsearch
  yum -y install elasticsearch
  systemctl daemon-reload
  EOH
end

cookbook_file '/etc/elasticsearch/elasticsearch.yml' do
    source 'elasticsearch.yml'
    mode 0644
    owner 'root'
    group 'wheel'
end

bash 'start elastic' do
  user 'root'
  code <<-EOH
  systemctl enable elasticsearch
  systemctl start firewalld
  firewall-cmd --add-port=9200/tcp
  firewall-cmd --add-port=9200/tcp --permanent
  systemctl restart network
  systemctl start elasticsearch
  EOH
end
