resource "aws_docdb_subnet_group" "guestbook-db-subnet-group" {
  name       = "guestbook-db-subnet-group"
  subnet_ids = ["${data.aws_subnet_ids.default.ids}"]
}

resource "aws_docdb_cluster_parameter_group" "guestbook-db-parameter-group" {
  family = "docdb3.6"
  name = "guestbook-db-parameter-group"

  parameter {
    name  = "tls"
    value = "disabled"
  }
}

resource "aws_docdb_cluster" "guestbook-db-cluster" {
  skip_final_snapshot     = true
  db_subnet_group_name    = "${aws_docdb_subnet_group.guestbook-db-subnet-group.name}"
  cluster_identifier      = "guestbook-db-cluster"
  engine                  = "docdb"
  master_username         = "foo"
  master_password         = "foobar11"
  db_cluster_parameter_group_name = "${aws_docdb_cluster_parameter_group.guestbook-db-parameter-group.name}"
  vpc_security_group_ids = ["${data.aws_security_group.default.id}"]
}

resource "aws_docdb_cluster_instance" "guestbook-db-cluster-instance" {
  count              = 1
  identifier         = "guestbook-db-instance-1"
  cluster_identifier = "${aws_docdb_cluster.guestbook-db-cluster.id}"
  instance_class     = "db.r5.large"
}

