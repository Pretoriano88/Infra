
resource "aws_elasticache_subnet_group" "this" {
  name       = "subnetcached"
  subnet_ids = [aws_subnet.sub_private_a.id]
}

resource "aws_elasticache_cluster" "cache_cluster" {
  cluster_id           = "cluster-memcached"
  engine               = "memcached"
  node_type            = "cache.t3.micro"
  num_cache_nodes      = 1
  parameter_group_name = "default.memcached1.6"
  engine_version       = "1.6.22"
  port                 = 11211
  network_type         = "ipv4"
  security_group_ids   = [aws_security_group.memcached_sg.id]
  subnet_group_name    = aws_elasticache_subnet_group.this.name
  apply_immediately    = true

  tags = {
    "Name" = "Cluster_elasticache"
  }
}


