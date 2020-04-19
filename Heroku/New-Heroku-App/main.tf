provider "heroku" {
  email = var.email
  api_key = var.apiKey
}

resource "heroku_app" "cloudskills-app" {
  name = "cloudskils"
  region = var.region
}