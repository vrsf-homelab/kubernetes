path "jenkins/*" {
  capabilities = ["read"]
}

path "jenkins-v1/*" {
  capabilities = ["read"]
}

path "secrets/creds/*" {
  capabilities = ["read"]
}
