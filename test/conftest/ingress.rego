package main.ingress

deny[msg] {
  input.kind == "Ingress"
  msg := "Ingress must not be created by default"
}
