#!/bin/bash
# This script is meant to be run in the User Data of the Vault Server while it's booting.

# Add Hashicorp Repo & install vault
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add - ;\
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main" ;\
sudo apt-get update && sudo apt-get install vault unzip -y




# Bring some plugins
mkdir -p /opt/vault/plugins
wget -P /tmp/ https://releases.hashicorp.com/vault-plugin-secrets-gcp/0.19.0/vault-plugin-secrets-gcp_0.19.0_linux_amd64.zip
unzip /tmp/vault-plugin-secrets-gcp_0.19.0_linux_amd64.zip -d /opt/vault/plugins
chown -Rv vault:vault /opt/vault/plugins

#Configure Vault server
cat << EOVCF >/etc/vault.d/vault.hcl
ui = true
plugin_directory = "/opt/vault/plugins"
# HTTPS listener
listener "tcp" {
  address       = "0.0.0.0:8200"
  tls_cert_file = "/opt/vault/tls/tls.crt"
  tls_key_file  = "/opt/vault/tls/tls.key"
}

storage "raft" {
  path = "/opt/vault/data"
  node_id = "$${HOSTNAME}"
  retry_join {
    auto_join = "provider=aws region=eu-central-1 tag_key=aws:autoscaling:groupName tag_value=${asg_name}"
    leader_tls_servername = "${leader_tls_servername}"
  }
}

api_addr = "https://{{ GetPrivateIP }}:8200"
cluster_addr = "https://{{ GetPrivateIP }}:8201"

seal "awskms" {
  region     = "${aws_region}"
  kms_key_id = "${kms_key}"
}
EOVCF

cat << EOVK >/opt/vault/tls/tls.key
${certificate_key}
EOVK

cat << EOVCRT >/opt/vault/tls/tls.crt
${certificate_pem}
${issuer_pem}
EOVCRT

systemctl enable vault
systemctl start vault
