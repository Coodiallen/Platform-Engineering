Vagrant.configure("2") do |config|
  config.vm.box = "generic/ubuntu2204"

  nodes = [
    { name: "management-node", ip: "192.168.50.10", memory: 4096, cpu: 2 },
    { name: "control-plane",   ip: "192.168.50.11", memory: 4096, cpu: 2 },
    { name: "worker-1",        ip: "192.168.50.12", memory: 2048, cpu: 2 },
    { name: "worker-2",        ip: "192.168.50.13", memory: 2048, cpu: 2 }
  ]

  nodes.each do |node|
    config.vm.define node[:name] do |n|
      n.vm.hostname = node[:name]
      n.vm.network "private_network", ip: node[:ip]

      n.vm.boot_timeout = 600

      n.vm.provider "libvirt" do |lv|
        lv.driver = "kvm"
        lv.storage_pool_name = "vm"
        lv.memory = node[:memory]
        lv.cpus = node[:cpu]
        lv.machine_virtual_size = 40
      end

      n.vm.provision "shell", inline: <<-SHELL
        apt-get update
        apt-get install -y curl wget vim git tree htop net-tools
        echo "export PS1='\\u@\\h:\\w\\$ '" >> /home/vagrant/.bashrc
      SHELL
    end
  end
end