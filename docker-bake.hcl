variable "REGISTRY" {
  default = "ghcr.io/m-s-software-engineering-ag"
}

# renovate: datasource=github-releases depName=TheDuffman85/crowdsec-web-ui
variable "CROWDSECWEBUI_VERSION" {
  default = "2026.8.3"
}

# renovate: datasource=github-releases depName=M-S-Software-Engineering-AG/container-healthcheck
variable "HEALTHCHECK_VERSION" {
  default = "v1.0.0"
}

# Set by the release workflow from the git tags; this default only tags local builds.
variable "IMAGE_REVISION" {
  default = "0.0"
}

group "default" {
  targets = ["crowdsec-web-ui", "crowdsec-web-ui-debug"]
}

target "crowdsec-web-ui" {
  context    = "."
  dockerfile = "Dockerfile"
  args       = {
    CROWDSECWEBUI_VERSION = CROWDSECWEBUI_VERSION
    HEALTHCHECK_VERSION   = HEALTHCHECK_VERSION
  }
  tags       = [
    "${REGISTRY}/rootless-containers-crowdsec-web-ui:v${CROWDSECWEBUI_VERSION}-${IMAGE_REVISION}",
    "${REGISTRY}/rootless-containers-crowdsec-web-ui:v${CROWDSECWEBUI_VERSION}-${regex_replace(IMAGE_REVISION, "\\.[0-9]+$", "")}",
    "${REGISTRY}/rootless-containers-crowdsec-web-ui:latest",
  ]
  platforms  = [
    "linux/amd64",
    "linux/arm64",
  ]
}

target "crowdsec-web-ui-debug" {
  inherits = ["crowdsec-web-ui"]
  args     = {
    BASE_IMAGE = "gcr.io/distroless/nodejs24-debian13:debug-nonroot"
  }
  tags     = [
    "${REGISTRY}/rootless-containers-crowdsec-web-ui:v${CROWDSECWEBUI_VERSION}-${IMAGE_REVISION}-debug",
    "${REGISTRY}/rootless-containers-crowdsec-web-ui:v${CROWDSECWEBUI_VERSION}-${regex_replace(IMAGE_REVISION, "\\.[0-9]+$", "")}-debug",
    "${REGISTRY}/rootless-containers-crowdsec-web-ui:latest-debug",
  ]
}
