cookbook_file '/etc/kibana/kibana.yml' do
	source 'kibana.yml'
	mode 0644
	owner 'root'
	group 'wheel'
end

bash 'configure kibana' do
  user 'root'
  code <<-EOH
  systemctl daemon-reload
  systemctl start kibana
  systemctl enable kibana
  systemctl start firewalld
  firewall-cmd --add-port=5601/tcp
  firewall-cmd --zone=public --add-port=5601/tcp --permanent
  systemctl restart network
  EOH
end
