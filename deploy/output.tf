output "db" {
  value = "${aws_docdb_cluster.guestbook-db-cluster.endpoint}"
}

