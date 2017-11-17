cookbook_file '/etc/logstash/conf.d/input.conf' do
    source 'input.conf'
    mode 0644
    owner 'root'
    group 'wheel'
end

cookbook_file '/etc/logstash/conf.d/output.conf' do
    source 'output.conf'
    mode 0644
    owner 'root'
    group 'wheel'
end

cookbook_file '/etc/logstash/conf.d/filter.conf' do
    source 'filter.conf'
    mode 0644
    owner 'root'
    group 'wheel'
end

bash 'start logstash' do
  user 'root'
  code <<-EOH
  systemctl daemon-reload
  systemctl enable logstash
  systemctl start logstash
  systemctl start firewalld
  firewall-cmd --add-port=5044/tcp
  firewall-cmd --add-port=5044/tcp --permanent
  systemctl restart network
  EOH
end
