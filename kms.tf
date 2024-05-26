resource "aws_kms_key" "vault" {
  description             = "Vault unseal key"
  deletion_window_in_days = 7

  tags = {
    Name = "vault-kms-unseal-${random_pet.env.id}"
  }
}
