resource "digitalocean_droplet" "k3s-server" {
  image = "ubuntu-22-04-x64"
  name = "k3s-server"
  region = "nyc3"
  size = "s-2vcpu-4gb"
  user_data = file("${path.module}/cloud-init.yaml")
  ssh_keys = [
    data.digitalocean_ssh_key.terraform.fingerprint
  ]
  
  connection {
    host = self.ipv4_address
    user = "root"
    type = "ssh"
    private_key = file("${var.pvt_key}")
    timeout = "2m"
  }

  provisioner "local-exec" {
    command = "sed 's/ls_token/\"${var.ls_access_token}\"/g' ${path.module}/otelcol-config.yaml.base > ${path.module}/otelcol-config.yaml"
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
    source = "${path.module}/apiserver-tracing.yaml"
    destination = "/etc/kube-tracing/apiserver-tracing.yaml"
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
      "curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION=\"v1.25.2+k3s1\" K3S_TOKEN=\"secret\" INSTALL_K3S_EXEC=\"--kube-apiserver-arg=feature-gates=APIServerTracing=true --kube-apiserver-arg=tracing-config-file=\"/etc/kube-tracing/apiserver-tracing.yaml\" --kubelet-arg=feature-gates=KubeletTracing=true --kubelet-arg=config=/etc/kube-tracing/kubelet-tracing.yaml --etcd-arg=experimental-enable-distributed-tracing=true --etcd-arg=experimental-distributed-tracing-address=localhost:4317 --etcd-arg=experimental-distributed-tracing-service-name=etcd \" sh -s - server --cluster-init --egress-selector-mode=disabled --kube-apiserver-arg=egress-selector-config-file="
    ]
  }

  provisioner "file" {
    source = "${path.module}/config.toml.tmpl"
    destination = "/var/lib/rancher/k3s/agent/etc/containerd/config.toml.tmpl"
  }

  provisioner "remote-exec" {
    inline = [
      "cat /var/lib/rancher/k3s/agent/etc/containerd/config.toml >> /var/lib/rancher/k3s/agent/etc/containerd/config.toml.tmpl",
      "systemctl restart k3s"
    ]
  }
}