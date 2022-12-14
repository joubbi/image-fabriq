variable "vm_name" {
  type    = string
  default = "ubuntu-2204.qcow2"
}


locals {
  ssh_username = "ubuntu"
  new_ssh_pass = "ubuntu"
  sensitive = true
}

# https://www.packer.io/docs/templates/hcl_templates/blocks/source
source "qemu" "ubuntu-2204" {
  accelerator      = "kvm"
  boot_command = ["e<down><down><down><end>",
                  " autoinstall ds=nocloud;",
                  "<F10>",]
  boot_wait        = "5s"
  cpus             = "2"
  cd_label         = "cidata"
  cd_files         = ["http/user-data",
                      "http/meta-data"]
  disk_compression = "true"
  disk_interface   = "virtio-scsi"
  disk_size        = "51200M"
  format           = "qcow2"
  headless         = true
  host_port_max    = 2229
  host_port_min    = 2222
  iso_checksum     = "sha256:10f19c5b2b8d6db711582e0e27f5116296c34fe4b313ba45f9b201a5007056cb"
  iso_target_path  = "../iso/"
  iso_urls         = ["../iso/ubuntu-22.04.1-live-server-amd64.iso", "https://releases.ubuntu.com/22.04.1/ubuntu-22.04.1-live-server-amd64.iso"]
  memory           = "2048"
  net_device       = "virtio-net"
  output_directory = "image"
  qemu_binary      = "/usr/bin/kvm"
  shutdown_command = "echo ${local.new_ssh_pass} | sudo -S shutdown -P now"
  ssh_password     = "${local.new_ssh_pass}"
  ssh_port         = 22
  ssh_timeout      = "1200s"
  ssh_username     = "${local.ssh_username}"
  vm_name          = "${var.vm_name}"
}

# a build block invokes sources and runs provisioning steps on them. The
# documentation for build blocks can be found here:
# https://www.packer.io/docs/templates/hcl_templates/blocks/build
build {
  sources = ["source.qemu.ubuntu-2204"]

  provisioner "ansible" {
    # https://github.com/hashicorp/packer-plugin-ansible/issues/69
    ansible_ssh_extra_args = [ "-oHostKeyAlgorithms=+ssh-rsa -oPubkeyAcceptedKeyTypes=+ssh-rsa" ]
    playbook_file   = "../ansible/create_nic_netplan.yml"
    user            = "${local.ssh_username}"
    extra_arguments = [ "--extra-vars", "ansible_become_pass=${local.new_ssh_pass}" ]
  }

  provisioner "ansible" {
    # https://github.com/hashicorp/packer-plugin-ansible/issues/69
    ansible_ssh_extra_args = [ "-oHostKeyAlgorithms=+ssh-rsa -oPubkeyAcceptedKeyTypes=+ssh-rsa" ]
    playbook_file   = "../ansible/create_log.yml"
    user            = "${local.ssh_username}"
    extra_arguments = [ "--extra-vars", "ansible_become_pass=${local.new_ssh_pass} vm_name=${var.vm_name}" ]
  }

  post-processor "checksum" {
    checksum_types = ["sha512"]
    output         = "image/${var.vm_name}_{{ .ChecksumType }}.checksum"
  }
}
