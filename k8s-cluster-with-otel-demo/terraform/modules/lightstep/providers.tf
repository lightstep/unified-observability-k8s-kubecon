# Reference: https://stackoverflow.com/a/68277378
terraform {
  required_providers {
    lightstep = {
      source = "lightstep/lightstep"
      version = ">=1.70.0"
    }
  }
}