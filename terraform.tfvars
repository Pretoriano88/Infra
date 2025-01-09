myip = "179.34.65.138"
sns-email = "teste@hotmail.com"

//VPC
region = "us-east-1"
cidr_vpc = "10.0.0.0/16"
enable_dns_hostnames = true
enable_dns_support   = true

//RDS 
allo_stora           = 10                 // Allocated storage space (in GB)
dbname               = "bdwordpress"      // Name of the database
engine               = "mysql"            // Database engine 
v_engine             = "8.0"              // Database engine version
db_class_instance    = "db.t3.micro"      // RDS instance class
user                 = "elfos"            // Database username
password             = "elfos123"         // Database password
parameter_group_name = "default.mysql8.0" // RDS parameter group name
port                 = 3306               // Port used by the databases
skip_final_snapshot  = true               // Skip final snapshot upon RDS deletion
multi_az             = false              // Enable Multi-AZ deployment


// EC2 Configuration
key_name      = "infra"
ami           = "ami-07d9b9ddc6cd8dd30"
instance_type = "t4g.nano"

