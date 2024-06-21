path "auth/approle/role/jenkins-role/secret-id" {
  capabilities = ["read", "create", "update"]
}

path "jenkins/*" {
  capabilities = ["read"]
}
