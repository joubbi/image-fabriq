# This file was autogenerated by the 'packer hcl2_upgrade' command. We
# recommend double checking that everything is correct before going forward. We
# also recommend treating this file as disposable. The HCL2 blocks in this
# file can be moved to other files. For example, the variable blocks could be
# moved to their own 'variables.pkr.hcl' file, etc. Those files need to be
# suffixed with '.pkr.hcl' to be visible to Packer. To use multiple files at
# once they also need to be in the same folder. 'packer inspect folder/'
# will describe to you what is in that folder.

# Avoid mixing go templating calls ( for example ```{{ upper(`string`) }}``` )
# and HCL2 calls (for example '${ var.string_value_example }' ). They won't be
# executed together and the outcome will be unknown.

# All generated input variables will be of 'string' type as this is how Packer JSON
# views them; you can change their type later on. Read the variables type
# constraints documentation
# https://www.packer.io/docs/templates/hcl_templates/variables#type-constraints for more info.
variable "vm_name" {
  type    = string
  default = "rocky8-hardened.qcow2"
}

# source blocks are generated from your builders; a source can be referenced in
# build blocks. A build block runs provisioner and post-processors on a
# source. Read the documentation for source blocks here:
# https://www.packer.io/docs/templates/hcl_templates/blocks/source
source "qemu" "rocky8-hardened" {
  accelerator      = "kvm"
#  boot_command     = ["<up><wait><tab><wait> text ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/rocky8-hardened-ks.cfg<enter><wait>"]
  boot_command     = ["<esc><wait>", "vmlinuz initrd=initrd.img inst.ks=cdrom:sr1:rocky8-hardened-ks.cfg", "<enter>"]
  boot_wait        = "5s"
  cpus             = "2"
  cd_files         = ["http/rocky8-hardened-ks.cfg"]
  cd_label         = "OEMDRV"
  disk_compression = "true"
  disk_interface   = "virtio-scsi"
  disk_size        = "51200M"
  format           = "qcow2"
  headless         = true
  host_port_max    = 2229
  host_port_min    = 2222
#  http_directory   = "http"
#  http_port_max    = 10089
#  http_port_min    = 10082
  iso_checksum     = "sha256:1d48e0af63d07ff4e582a1819348e714c694e7fd33207f48879c2bc806960786"
  iso_target_path  = "../iso/"
  iso_urls         = ["../iso/Rocky-8.6-x86_64-dvd1.iso", "https://download.rockylinux.org/pub/rocky/8/isos/x86_64/Rocky-8.6-x86_64-dvd1.iso"]
  memory           = "2048"
  net_device       = "virtio-net"
  output_directory = "image"
  qemu_binary      = "/usr/bin/kvm"
  shutdown_command = "echo 'packer' | shutdown -P now"
  ssh_password     = "Changeme123"
  ssh_port         = 22
  ssh_timeout      = "1200s"
  ssh_username     = "root"
  vm_name          = "${var.vm_name}"
}

# a build block invokes sources and runs provisioning steps on them. The
# documentation for build blocks can be found here:
# https://www.packer.io/docs/templates/hcl_templates/blocks/build
build {
  sources = ["source.qemu.rocky8-hardened"]

  provisioner "ansible" {
    # https://github.com/hashicorp/packer-plugin-ansible/issues/69
    ansible_ssh_extra_args = ["-oHostKeyAlgorithms=+ssh-rsa -oPubkeyAcceptedKeyTypes=+ssh-rsa"]
    playbook_file = "../ansible/create_user01.yml"
    user          = "root"
  }

  provisioner "ansible" {
    # https://github.com/hashicorp/packer-plugin-ansible/issues/69
    ansible_ssh_extra_args = ["-oHostKeyAlgorithms=+ssh-rsa -oPubkeyAcceptedKeyTypes=+ssh-rsa"]
    playbook_file = "../ansible/yum.yml"
    user          = "root"
  }

  provisioner "ansible" {
    # https://github.com/hashicorp/packer-plugin-ansible/issues/69
    ansible_ssh_extra_args = ["-oHostKeyAlgorithms=+ssh-rsa -oPubkeyAcceptedKeyTypes=+ssh-rsa"]
    playbook_file = "../ansible/hardening.yml"
    user          = "root"
  }

  provisioner "ansible" {
    # https://github.com/hashicorp/packer-plugin-ansible/issues/69
    ansible_ssh_extra_args = ["-oHostKeyAlgorithms=+ssh-rsa -oPubkeyAcceptedKeyTypes=+ssh-rsa"]
    extra_arguments = ["--extra-vars", "vm_name=${var.vm_name}"]
    playbook_file   = "../ansible/create_log.yml"
    user            = "root"
  }

  provisioner "ansible" {
    # https://github.com/hashicorp/packer-plugin-ansible/issues/69
    ansible_ssh_extra_args = ["-oHostKeyAlgorithms=+ssh-rsa -oPubkeyAcceptedKeyTypes=+ssh-rsa"]
    playbook_file = "../ansible/aide.yml"
    user          = "root"
  }

  post-processor "checksum" {
    checksum_types = ["sha512"]
    output         = "image/${var.vm_name}_{{ .ChecksumType }}.checksum"
  }
}
