package main.deployment

deny[msg] {
  input.kind == "Deployment"
  not input.spec.selector.matchLabels["app.kubernetes.io/name"]
  not input.spec.selector.matchLabels["app.kubernetes.io/instance"]

  msg := "Containers must provide predefined labels for pod selectors"
}
