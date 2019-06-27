output "db" {
  value = "${aws_docdb_cluster.guestbook-db-cluster.endpoint}"
}

output "alb" {
  value = "${aws_lb.global-alb.dns_name}"
}