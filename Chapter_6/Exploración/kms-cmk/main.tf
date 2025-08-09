provider "aws" {
    region = "us-east-2"
}

data "aws_caller_identity" "self" {}

data "aws_iam_policy_document" "cmk_admin_policy" {
    statement {
      effect   = "Allow"
      resources = ["*"]
      actions   = ["kms:*"]

      principals {
        type = "AWS"
        identifiers = [data.aws_caller_identity.self.arn]
      }
    }

    # Permitir acceso total a joan
    statement {
      effect   = "Allow"
      resources = ["*"]
      actions   = ["kms:*"]

      principals {
        type = "AWS"
        identifiers = ["arn:aws:iam::058264112641:user/joan"]
      }
    }
}

resource "aws_kms_key" "cmk" {
    policy = data.aws_iam_policy_document.cmk_admin_policy.json
}

resource "aws_kms_alias" "cmk" {
    name          = "alias/kms-cmk-example"
    target_key_id = aws_kms_key.cmk.id
}

