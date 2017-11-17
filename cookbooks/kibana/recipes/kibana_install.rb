cookbook_file '/etc/yum.repos.d/kibana.repo' do
  source 'kibana.repo'
  mode 0644
  owner 'root'
  group 'wheel'
end

bash 'install' do
  user 'root'
  code <<-EOH
  yum makecache fast
  yum -y install java
  yum -y install kibana
  EOH
end

cookbook_file '/opt/kibana/config/kibana.yml' do
    source 'kibana.yml'
    mode 0644
    owner 'root'
    group 'wheel'
end

bash 'start kibana' do
  user 'root'
  code <<-EOH
  systemctl daemon-reload
  systemctl start kibana
  systemctl enable kibana
  systemctl start firewalld
  firewall-cmd --add-port=5601/tcp
  firewall-cmd --add-port=5601/tcp --permanent
  systemctl restart network
  EOH
end
