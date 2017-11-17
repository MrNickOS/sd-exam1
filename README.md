# Parcial 1 Sistemas Distribuidos
### Autor: Nicolás Machado Sáenz (A00052208)
### Tema: Aprovisionamiento de Infraestructura con Vagrant + Chef

El objetivo de esta actividad es aprovisionar un ambiente virtualizado del stack ELK: ElasticSearch, Logstash
y Kibana, utilizando Filebeat para el manejo de archivos log. Para realizar el despliegue se dispone de:
  * Vagrant.
  * Equipo físico Ubuntu 16.10 cliente.
  * Chef.
  * Cookbooks de Chef para instalación de ELK.
  
La infraestructura automatizada final consta de los siguientes equipos virtuales, que usarán direcciones IP en
el mismo segmento de red del equipo anfitrión, el Laboratorio de Redes:
  * Un servidor ElasticSearch, 192.168.130.251
  * Un servidor Logstash, 192.168.130.252
  * Un servidor Kibana, 192.168.130.253 y a este se debe acceder via web.
  * Un servidor Filebeat, 192.168.130.254
  * Un equipo cliente Ubuntu, 192.168.130.130
  
El primer comando a digitar, en el directorio donde reside el Vagrantfile para aprovisionar por primera vez
la infraestructura, es la línea ```vagrant up```, que ejecuta el siguiente código.

```ruby
# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.ssh.insert_key = false

  config.vm.define :elasticsearch do |es|
    es.vm.box = "CentOS_1706_v0.2.0"
    es.vm.hostname = "charlie"
    #es.vm.network "private_network", ip:"192.168.100.40"
    es.vm.network "public_network", bridge: "eno1", ip:"192.168.130.251", netmask: "255.255.255.0"
    es.vm.provider :virtualbox do |vbox|
      vbox.customize ["modifyvm", :id, "--memory", "840","--cpus", "1", "--name", "elasticsearch_server" ]
    end
    es.vm.provision :chef_solo do |chef|
        chef.install = false
        chef.cookbooks_path = "cookbooks"
        chef.add_recipe "elasticsearch"
    end
  end

  config.vm.define :logstash do |log|
    log.vm.box = "CentOS_1706_v0.2.0"
    log.vm.hostname = "bravo"
    #log.vm.network "private_network", ip:"192.168.100.30"
    log.vm.network "public_network", bridge: "eno1", ip:"192.168.130.252", netmask: "255.255.255.0"
    log.vm.provider :virtualbox do |vbox|
      vbox.customize ["modifyvm", :id, "--memory", "840","--cpus", "1", "--name", "logstash_server"]
    end
    log.vm.provision :chef_solo do |chef|
	    chef.install = false
	    chef.cookbooks_path = "cookbooks"
	    chef.add_recipe "logstash"
    end
  end

  config.vm.define :kibana do |kib|
    kib.vm.box = "CentOS_1706_v0.2.0"
    kib.vm.hostname = "delta"
    #kib.vm.network "private_network", ip:"192.168.100.50"
    kib.vm.network "public_network", bridge: "eno1", ip:"192.168.130.253", netmask: "255.255.255.0"
    kib.vm.provider :virtualbox do |vbox|
      vbox.customize ["modifyvm", :id, "--memory", "840","--cpus", "1", "--name", "kibana_server" ]
    end
    kib.vm.provision :chef_solo do |chef|
        chef.install = false
        chef.cookbooks_path = "cookbooks"
        chef.add_recipe "kibana"
    end
  end

  config.vm.define :filebeat do |file|
    file.vm.box = "CentOS_1706_v0.2.0"
    file.vm.hostname = "alpha"
    #file.vm.network "private_network", ip:"192.168.100.20"
    file.vm.network "public_network", bridge: "eno1", ip:"192.168.130.254", netmask: "255.255.255.0"
    file.vm.provider :virtualbox do |vbox|
      vbox.customize ["modifyvm", :id, "--memory", "840","--cpus", "1", "--name", "filebeat_server" ]
    end
    file.vm.provision :chef_solo do |chef|
      chef_install = false
      chef.cookbooks_path = "cookbooks"
      chef.add_recipe "filebeat"
    end
  end
end
```

Como se puede ver, a cada máquina se le asignó 1 core de procesamiento, 840 MB de RAM y usa una *box* base con
CentOS 7, interfaz de red bridge con el puerto de red del anfitrión. Luego, usa una serie de scripts en Ruby,
denominados recetas, y que automatizan el proceso de instalación y activación de los servicios, explicados a
continuación.

### Recetas para el despliegue y ejecución de comandos

Directorio | Descripción
---------- | -----------
sd-exam1 | Directorio raíz del proyecto, contiene el Vagrantfile y el directorio de cookbooks.
cookbooks | Alberga las 4 carpetas que contienen archivos de aprovisionamiento de cada VM del stack ELK.
elasticsearch | Incluye los archivos requeridos para el funcionamiento adecuado del servicio de Elasticsearch en el subdirectorio *files/default*, así como los script *bash* para la ejecución automatizada de los comandos de instalación en *recipes*.
logstash | Contiene archivos de configuración de repositorio (.repo) y de host (.yml) predeterminados, así como las instrucciones en *bash* a ejecutar para instalar e iniciar el servicio de Logstash.
kibana | Contiene archivos de configuración de repositorio (.repo) y host (.yml) predeterminados, así como las comandos *bash* para instalar e iniciar el servicio de Kibana. El puerto que se especifique en el .yml deberá ingresarse en el navegador web como IP:PUERTO.
filebeat | Incluye los archivos requeridos para el levantamiento apropiado del servicio Filebeat en el subfolder *files/default*, así como los script *bash* para la ejecución automatizada de los comandos de instalación en el subfolder *recipes*.

Para iniciar Elasticsearch se ejecutan estas lineas de código.

```bash
[elasticsearch]
name=Elasticsearch repository
baseurl=https://packages.elastic.co/elasticsearch/2.x/centos
gpgcheck=1
gpgkey=https://packages.elastic.co/GPG-KEY-elasticsearch
enabled=1
```

```bash
yum makecache fast
  yum -y install java
  rpm --import http://packages.elastic.co/GPG-KEY-elasticsearch
  yum -y install elasticsearch
  systemctl daemon-reload
```

Para ejecutar los comandos siguientes, debe existir un .yml
```bash
# ======================== Elasticsearch Configuration =========================
#
# NOTE: Elasticsearch comes with reasonable defaults for most settings.
...
#network.host: 192.168.100.40
network.host: 192.168.130.251
#
# Set a custom port for HTTP:
#
http.port: 9200
#
...
```

Y luego continúa con la instalación.
```bash
systemctl enable elasticsearch
  systemctl start firewalld
  firewall-cmd --add-port=9200/tcp
  firewall-cmd --add-port=9200/tcp --permanent
  systemctl restart network
  systemctl start elasticsearch
```
