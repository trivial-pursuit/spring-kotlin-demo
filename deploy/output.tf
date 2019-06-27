output "db" {
  value = "${aws_docdb_cluster.guestbook-db-cluster.endpoint}"
}

output "home" {
  value = "http://${aws_lb.global-alb.dns_name}/index.html"
}
