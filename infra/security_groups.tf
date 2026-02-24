############################
# Security Groups (objects)
############################

resource "aws_security_group" "bingo2" {
  name        = "security group Bingo 2"
  description = "launch-wizard-3 created 2026-02-16T16:15:04.250Z"
  vpc_id      = aws_vpc.p2.id
}

resource "aws_security_group" "bingo" {
  name        = "security group Bingo"
  description = "launch-wizard-3 created 2026-02-16T16:12:54.106Z"
  vpc_id      = aws_vpc.p2.id
}

resource "aws_security_group" "sgendpoints" {
  name        = "sgendpoints"
  description = "VPC Interface Endpoints for SSM (PrivateLink)"
  vpc_id      = aws_vpc.p2.id
}

resource "aws_security_group" "launch_wizard_1" {
  name        = "launch-wizard-1"
  description = "launch-wizard-1 created 2026-02-16T15:50:19.810Z"
  vpc_id      = aws_vpc.p2.id
}

resource "aws_security_group" "launch_wizard_2" {
  name        = "launch-wizard-2"
  description = "launch-wizard-2 created 2026-02-16T15:53:48.311Z"
  vpc_id      = aws_vpc.p2.id
}

resource "aws_security_group" "launch_wizard_3" {
  name        = "launch-wizard-3"
  description = "launch-wizard-3 created 2026-02-17T14:26:30.836Z"
  vpc_id      = aws_vpc.p2.id
}

resource "aws_security_group" "sgapp" {
  name        = "sgapp"
  description = "App tier instances (private subnets)"
  vpc_id      = aws_vpc.p2.id
}

resource "aws_security_group" "p2_alb_sg" {
  name        = "p2-alb-sg"
  description = "sg for ALB"
  vpc_id      = aws_vpc.p2.id
}

resource "aws_security_group" "p2_rds_sg" {
  name        = "p2-rds-sg"
  description = "RDS Postgres - allow only from app SG"
  vpc_id      = aws_vpc.p2.id
}

############################
# Default SG (from your JSON)
############################
resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.p2.id

  ingress {
    protocol  = "-1"
    from_port = 0
    to_port   = 0
    self      = true
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#################################
# EGRESS rules (mostly allow all)
#################################
resource "aws_security_group_rule" "bingo2_egress_all" {
  type              = "egress"
  security_group_id = aws_security_group.bingo2.id
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "bingo_egress_all" {
  type              = "egress"
  security_group_id = aws_security_group.bingo.id
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "sgendpoints_egress_all" {
  type              = "egress"
  security_group_id = aws_security_group.sgendpoints.id
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "lw1_egress_all" {
  type              = "egress"
  security_group_id = aws_security_group.launch_wizard_1.id
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "lw2_egress_all" {
  type              = "egress"
  security_group_id = aws_security_group.launch_wizard_2.id
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "lw3_egress_all" {
  type              = "egress"
  security_group_id = aws_security_group.launch_wizard_3.id
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "sgapp_egress_all" {
  type              = "egress"
  security_group_id = aws_security_group.sgapp.id
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "rds_egress_all" {
  type              = "egress"
  security_group_id = aws_security_group.p2_rds_sg.id
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
}

# ALB egress (dal tuo JSON): TCP 8080 verso sgapp (NON all)
resource "aws_security_group_rule" "alb_out_8080_to_sgapp" {
  type                     = "egress"
  security_group_id        = aws_security_group.p2_alb_sg.id
  protocol                 = "tcp"
  from_port                = 8080
  to_port                  = 8080
  source_security_group_id = aws_security_group.sgapp.id
}

############################
# INGRESS rules (CIDR)
############################

# bingo2 ingress: tcp 9000,8080,22,3000 from 0.0.0.0/0
resource "aws_security_group_rule" "bingo2_in_9000" {
  type              = "ingress"
  security_group_id = aws_security_group.bingo2.id
  protocol          = "tcp"
  from_port         = 9000
  to_port           = 9000
  cidr_blocks       = ["0.0.0.0/0"]
}
resource "aws_security_group_rule" "bingo2_in_8080" {
  type              = "ingress"
  security_group_id = aws_security_group.bingo2.id
  protocol          = "tcp"
  from_port         = 8080
  to_port           = 8080
  cidr_blocks       = ["0.0.0.0/0"]
}
resource "aws_security_group_rule" "bingo2_in_22" {
  type              = "ingress"
  security_group_id = aws_security_group.bingo2.id
  protocol          = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_blocks       = ["0.0.0.0/0"]
}
resource "aws_security_group_rule" "bingo2_in_3000" {
  type              = "ingress"
  security_group_id = aws_security_group.bingo2.id
  protocol          = "tcp"
  from_port         = 3000
  to_port           = 3000
  cidr_blocks       = ["0.0.0.0/0"]
}

# bingo ingress: tcp 9000,22 from 0.0.0.0/0
resource "aws_security_group_rule" "bingo_in_9000" {
  type              = "ingress"
  security_group_id = aws_security_group.bingo.id
  protocol          = "tcp"
  from_port         = 9000
  to_port           = 9000
  cidr_blocks       = ["0.0.0.0/0"]
}
resource "aws_security_group_rule" "bingo_in_22" {
  type              = "ingress"
  security_group_id = aws_security_group.bingo.id
  protocol          = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_blocks       = ["0.0.0.0/0"]
}

# launch-wizard-1 ingress: tcp 80,22,443 from 0.0.0.0/0
resource "aws_security_group_rule" "lw1_in_80" {
  type              = "ingress"
  security_group_id = aws_security_group.launch_wizard_1.id
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_blocks       = ["0.0.0.0/0"]
}
resource "aws_security_group_rule" "lw1_in_22" {
  type              = "ingress"
  security_group_id = aws_security_group.launch_wizard_1.id
  protocol          = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_blocks       = ["0.0.0.0/0"]
}
resource "aws_security_group_rule" "lw1_in_443" {
  type              = "ingress"
  security_group_id = aws_security_group.launch_wizard_1.id
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_blocks       = ["0.0.0.0/0"]
}

# launch-wizard-2 ingress: tcp 80,22,443 from 0.0.0.0/0
resource "aws_security_group_rule" "lw2_in_80" {
  type              = "ingress"
  security_group_id = aws_security_group.launch_wizard_2.id
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_blocks       = ["0.0.0.0/0"]
}
resource "aws_security_group_rule" "lw2_in_22" {
  type              = "ingress"
  security_group_id = aws_security_group.launch_wizard_2.id
  protocol          = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_blocks       = ["0.0.0.0/0"]
}
resource "aws_security_group_rule" "lw2_in_443" {
  type              = "ingress"
  security_group_id = aws_security_group.launch_wizard_2.id
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_blocks       = ["0.0.0.0/0"]
}

# launch-wizard-3 ingress: tcp 22 from 0.0.0.0/0
resource "aws_security_group_rule" "lw3_in_22" {
  type              = "ingress"
  security_group_id = aws_security_group.launch_wizard_3.id
  protocol          = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_blocks       = ["0.0.0.0/0"]
}

# ALB ingress: tcp 80 from 0.0.0.0/0
resource "aws_security_group_rule" "alb_in_80" {
  type              = "ingress"
  security_group_id = aws_security_group.p2_alb_sg.id
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_blocks       = ["0.0.0.0/0"]
}

############################################
# INGRESS rules (SG references from your JSON)
############################################

# sgendpoints ingress 443 from sgapp
resource "aws_security_group_rule" "endpoints_in_443_from_sgapp" {
  type                     = "ingress"
  security_group_id        = aws_security_group.sgendpoints.id
  protocol                 = "tcp"
  from_port                = 443
  to_port                  = 443
  source_security_group_id = aws_security_group.sgapp.id
}

# sgapp ingress 8080 from p2-alb-sg
resource "aws_security_group_rule" "sgapp_in_8080_from_alb" {
  type                     = "ingress"
  security_group_id        = aws_security_group.sgapp.id
  protocol                 = "tcp"
  from_port                = 8080
  to_port                  = 8080
  source_security_group_id = aws_security_group.p2_alb_sg.id
}

# rds ingress 5432 from sgapp
resource "aws_security_group_rule" "rds_in_5432_from_sgapp" {
  type                     = "ingress"
  security_group_id        = aws_security_group.p2_rds_sg.id
  protocol                 = "tcp"
  from_port                = 5432
  to_port                  = 5432
  source_security_group_id = aws_security_group.sgapp.id
}
