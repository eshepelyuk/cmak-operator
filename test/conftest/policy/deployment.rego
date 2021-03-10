package main

deny[msg] {
  input.kind == "Deployment"
  not input.spec.selector.matchLabels["app.kubernetes.io/name"]
  not input.spec.selector.matchLabels["app.kubernetes.io/instance"]

  msg := "Containers must provide app.kubernetes.io/name and app.kubernetes.io/instance labels for pod selectors"
}
