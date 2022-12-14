variable "vm_name" {
  type    = string
  default = "ubuntu-2004.qcow2"
}


locals {
  ssh_username = "ubuntu"
  new_ssh_pass = "ubuntu"
  sensitive = true
}

# https://www.packer.io/docs/templates/hcl_templates/blocks/source
source "qemu" "ubuntu-2004" {
  accelerator      = "kvm"
  boot_command = [
    "<enter><wait2><enter><wait><f6><esc><wait>",
    " autoinstall<wait2> ds=nocloud;",
    "<wait><enter>"
  ]
  boot_wait        = "2s"
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
  iso_checksum     = "sha256:5035be37a7e9abbdc09f0d257f3e33416c1a0fb322ba860d42d74aa75c3468d4"
  iso_target_path  = "../iso/"
  iso_urls         = ["../iso/ubuntu-20.04.5-live-server-amd64.iso", "https://releases.ubuntu.com/20.04.5/ubuntu-20.04.5-live-server-amd64.iso"]
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
  sources = ["source.qemu.ubuntu-2004"]

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
