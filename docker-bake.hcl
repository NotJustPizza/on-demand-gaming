target "tools" {
  dockerfile = "docker/tools.Dockerfile"
  tags       = ["tools:latest"]
}

target "shared" {
  dockerfile = "docker/shared.Dockerfile"
}

target "api" {
  contexts = {
    shared = "target:shared"
  }
  dockerfile = "docker/api.Dockerfile"
  target     = "prod"
  tags       = ["api:latest"]
}

target "autoscaler" {
  contexts = {
    shared = "target:shared"
  }
  dockerfile = "docker/autoscaler.Dockerfile"
  target     = "prod"
  tags       = ["autoscaler:latest"]
}

target "avorion" {
  dockerfile = "docker/avorion.Dockerfile"
  tags       = ["avorion:latest"]
}
