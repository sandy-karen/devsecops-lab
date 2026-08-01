provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "bucket_seguro" {
  #checkov:skip=CKV_AWS_18:"Bucket logging no requerido en lab"
  #checkov:skip=CKV2_AWS_62:"Notificaciones de eventos no requeridas en lab"
  #checkov:skip=CKV_AWS_144:"Replicacion cross-region no requerida en lab"
  #checkov:skip=CKV2_AWS_61:"Lifecycle configuration no requerida en lab"
  #checkov:skip=CKV_AWS_145:"Cifrado KMS no requerido en lab, se usa AES256"
  bucket = "mi-bucket-devsecops-demo-12345"
}

resource "aws_s3_bucket_public_access_block" "publico" {
  bucket                  = aws_s3_bucket.bucket_seguro.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "cifrado" {
  bucket = aws_s3_bucket.bucket_seguro.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "versionado" {
  bucket = aws_s3_bucket.bucket_seguro.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_security_group" "sg_seguro" {
  #checkov:skip=CKV2_AWS_5:"Security group no asociado a instancias en este lab de demostracion"
  name        = "sg_ssh_restringido"
  description = "Grupo de seguridad restringido para lab"

  ingress {
    description = "Acceso SSH restringido a red privada del lab"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }
}
