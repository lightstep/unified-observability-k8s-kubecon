resource "digitalocean_droplet" "k3s-worker-2" {
  image = "ubuntu-22-04-x64"
  name = "k3s-worker-2"
  region = "nyc3"
  size = "s-2vcpu-4gb"
  user_data = file("${path.module}/cloud-init.yaml")
  ssh_keys = [
    data.digitalocean_ssh_key.terraform.fingerprint
  ]
  depends_on = [
    digitalocean_droplet.k3s-server
  ]
  
  connection {
    host = self.ipv4_address
    user = "root"
    type = "ssh"
    private_key = file("${var.pvt_key}")
    timeout = "2m"
  }

  provisioner "remote-exec" {
    inline = [
      "apt-get update",
      "systemctl restart systemd-journald",
      "wget https://github.com/open-telemetry/opentelemetry-collector-releases/releases/download/v0.61.0/otelcol-contrib_0.61.0_linux_amd64.deb",
      "dpkg -i otelcol-contrib_0.61.0_linux_amd64.deb",
      "mkdir -p /etc/kube-tracing"
    ]
  }

provisioner "file" {
    source = "${path.module}/kubelet-tracing.yaml"
    destination = "/etc/kube-tracing/kubelet-tracing.yaml"
  }

  provisioner "file" {
    source = "${path.module}/otelcol-config.yaml"
    destination = "/etc/otelcol-contrib/config.yaml"
  }

  provisioner "remote-exec" {
    inline = [
      "systemctl restart otelcol-contrib",
      "curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION=\"v1.25.2+k3s1\" K3S_URL=https://${digitalocean_droplet.k3s-server.ipv4_address}:6443 K3S_TOKEN=\"secret\" INSTALL_K3S_EXEC=\"--kubelet-arg=feature-gates=KubeletTracing=true --kubelet-arg=config=/etc/kube-tracing/kubelet-tracing.yaml\" sh -s -"
    ]
  }

  provisioner "file" {
    source = "${path.module}/config.toml.tmpl"
    destination = "/var/lib/rancher/k3s/agent/etc/containerd/config.toml.tmpl"
  }

  provisioner "remote-exec" {
    inline = [
      "cat /var/lib/rancher/k3s/agent/etc/containerd/config.toml >> /var/lib/rancher/k3s/agent/etc/containerd/config.toml.tmpl",
      "systemctl restart k3s-agent"
    ]
  }
}

resource "digitalocean_droplet" "k3s-worker-1" {
  image = "ubuntu-22-04-x64"
  name = "k3s-worker-1"
  region = "nyc3"
  size = "s-2vcpu-4gb"
  user_data = file("${path.module}/cloud-init.yaml")
  ssh_keys = [
    data.digitalocean_ssh_key.terraform.fingerprint
  ]
  depends_on = [
    digitalocean_droplet.k3s-server
  ]
  
  connection {
    host = self.ipv4_address
    user = "root"
    type = "ssh"
    private_key = file("${var.pvt_key}")
    timeout = "2m"
  }

  provisioner "remote-exec" {
    inline = [
      "apt-get update",
      "systemctl restart systemd-journald",
      "wget https://github.com/open-telemetry/opentelemetry-collector-releases/releases/download/v0.61.0/otelcol-contrib_0.61.0_linux_amd64.deb",
      "dpkg -i otelcol-contrib_0.61.0_linux_amd64.deb",
      "mkdir -p /etc/kube-tracing"
    ]
  }

  provisioner "file" {
    source = "${path.module}/kubelet-tracing.yaml"
    destination = "/etc/kube-tracing/kubelet-tracing.yaml"
  }

  provisioner "file" {
    source = "${path.module}/otelcol-config.yaml"
    destination = "/etc/otelcol-contrib/config.yaml"
  }

  provisioner "remote-exec" {
    inline = [
      "systemctl restart otelcol-contrib",
      "curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION=\"v1.25.2+k3s1\" K3S_URL=https://${digitalocean_droplet.k3s-server.ipv4_address}:6443 K3S_TOKEN=\"secret\" INSTALL_K3S_EXEC=\"--kubelet-arg=feature-gates=KubeletTracing=true --kubelet-arg=config=/etc/kube-tracing/kubelet-tracing.yaml\" sh -s -"
    ]
  }

  provisioner "file" {
    source = "${path.module}/config.toml.tmpl"
    destination = "/var/lib/rancher/k3s/agent/etc/containerd/config.toml.tmpl"
  }

  provisioner "remote-exec" {
    inline = [
      "cat /var/lib/rancher/k3s/agent/etc/containerd/config.toml >> /var/lib/rancher/k3s/agent/etc/containerd/config.toml.tmpl",
      "systemctl restart k3s-agent",
    ]
  }
}