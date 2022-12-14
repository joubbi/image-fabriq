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
  default = "rocky9-cis1.qcow2"
}


locals {
  ssh_username = "user01"
  old_ssh_pass = "admin123"
  new_ssh_pass = "FaridJoubbi123%"
  sensitive = true
}

# source blocks are generated from your builders; a source can be referenced in
# build blocks. A build block runs provisioner and post-processors on a
# source. Read the documentation for source blocks here:
# https://www.packer.io/docs/templates/hcl_templates/blocks/source
source "qemu" "rocky9-cis1" {
  accelerator      = "kvm"
  boot_command     = ["<esc><wait>", "vmlinuz initrd=initrd.img inst.ks=cdrom:sr1:rocky9-cis1-ks.cfg", "<enter><wait500>",
                      "${local.ssh_username}<enter><wait3>",
                      "${local.old_ssh_pass}<enter><wait3>",
                      "${local.old_ssh_pass}<enter><wait3>",
                      "${local.new_ssh_pass}<enter><wait3>",
                      "${local.new_ssh_pass}<enter><wait3>"]
  boot_wait        = "5s"
  cpus             = "2"
  cd_files         = ["http/rocky9-cis1-ks.cfg"]
  cd_label         = "OEMDRV"
  disk_compression = "true"
  disk_interface   = "virtio-scsi"
  disk_size        = "51200M"
  format           = "qcow2"
  headless         = true
  host_port_max    = 2229
  host_port_min    = 2222
  iso_checksum     = "sha256:69fa71d69a07c9d204da81767719a2af183d113bc87ee5f533f98a194a5a1f8a"
  iso_target_path  = "../iso/"
  iso_urls         = ["../iso/Rocky-9.1-x86_64-dvd1.iso", "https://download.rockylinux.org/pub/rocky/9/isos/x86_64/Rocky-9.1-x86_64-dvd.iso"]
  memory           = "2048"
  net_device       = "virtio-net"
  output_directory = "image"
  qemu_binary      = "/usr/bin/kvm"
  # https://github.com/hashicorp/packer-plugin-qemu/issues/76
  qemuargs                = [
    [
      "-cpu",
      "host,x2apic=on,tsc-deadline=on,hypervisor=on,tsc-adjust=on,erms=on,vaes=on,vpclmulqdq=on,",
      "spec-ctrl=on,stibp=on,arch-capabilities=on,ssbd=on,xsaves=on,cmp-legacy=on,ibrs=on,",
      "amd-ssbd=on,virt-ssbd=on,rdctl-no=on,skip-l1dfl-vmentry=on,mds-no=on,pschange-mc-no=on"
    ]
  ]
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
  sources = ["source.qemu.rocky9-cis1"]

  provisioner "ansible" {
    # https://github.com/hashicorp/packer-plugin-ansible/issues/69
    ansible_ssh_extra_args = [ "-oHostKeyAlgorithms=+ssh-rsa -oPubkeyAcceptedKeyTypes=+ssh-rsa" ]
    playbook_file = "../ansible/fix_firewalld.yml"
    user          = "${local.ssh_username}"
    extra_arguments = [ "--extra-vars", "ansible_become_pass=${local.new_ssh_pass}" ]
  }

  provisioner "ansible" {
    # https://github.com/hashicorp/packer-plugin-ansible/issues/69
    ansible_ssh_extra_args = [ "-oHostKeyAlgorithms=+ssh-rsa -oPubkeyAcceptedKeyTypes=+ssh-rsa" ]
    playbook_file = "../ansible/configure_rsyslog.yml"
    user          = "${local.ssh_username}"
    extra_arguments = [ "--extra-vars", "ansible_become_pass=${local.new_ssh_pass}" ]
  }

  provisioner "ansible" {
    # https://github.com/hashicorp/packer-plugin-ansible/issues/69
    ansible_ssh_extra_args = [ "-oHostKeyAlgorithms=+ssh-rsa -oPubkeyAcceptedKeyTypes=+ssh-rsa" ]
    playbook_file = "../ansible/yum.yml"
    user          = "${local.ssh_username}"
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
