output "server_ip" {
  value = digitalocean_droplet.k3s-server.ipv4_address
}