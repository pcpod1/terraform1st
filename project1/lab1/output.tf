output "contact_ip" {
    value = module.web-vm.vm-public_ip
    
}
output "contact_ip1" {
    value =module.test-vm.vm-public_ip
}