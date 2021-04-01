// resource "aws_lb" "david-alb" {
//   name     = "david-alb"
//   internal = false

//   security_groups = [var.public-sg]

//   subnets = [var.public-sbn]


//   tags = {
//     Name = "david-alb"
//   }

//   ip_address_type    = "ipv4"
//   load_balancer_type = "application"
// }

// resource "aws_lb_target_group" "david-alb-tgt" {
//   health_check {
//     interval            = 10
//     path                = "/healthstatus"
//     protocol            = "HTTP"
//     timeout             = 5
//     healthy_threshold   = 5
//     unhealthy_threshold = 2
//   }
//   name        = "david-alb-tgt"
//   port        = 80
//   protocol    = "HTTP"
//   target_type = "instance"
//   vpc_id      = var.vpc_id
// }

// resource "aws_lb_listener" "david-alb-listner" {
//   load_balancer_arn = aws_lb.david-alb.arn
//   port              = 80
//   protocol          = "HTTP"

//   default_action {
//     type             = "forward"
//     target_group_arn = aws_lb_target_group.david-alb-tgt.arn
//   }
// }



// resource "aws_lb" "david-ialb" {
//   name     = "david-alb"
//   internal = true

//   security_groups = [
//     module.vpc.aws_security_group.david-IALB.id,
//   ]
//   subnets = [
//     module.vpc.aws_subnet.private-subnets[0].id,
//     module.vpc.aws_subnet.private-subnets[1].id
//   ]
//   tags = {
//     Name = "david-ialb"
//   }

//   ip_address_type    = "ipv4"
//   load_balancer_type = "application"
// }

// resource "aws_lb_target_group" "david-ialb-tgt" {
//   health_check {
//     interval            = 10
//     path                = "/healthstatus"
//     protocol            = "HTTP"
//     timeout             = 5
//     healthy_threshold   = 5
//     unhealthy_threshold = 2
//   }

//   name        = "david-ialb-tgt"
//   port        = 80
//   protocol    = "HTTP"
//   target_type = "instance"
//   vpc_id      = module.vpc.aws_vpc.david
// }

// resource "aws_lb_listener" "david-ialb-listner" {
//   load_balancer_arn = aws_lb.david-ialb.arn
//   port              = 80
//   protocol          = "HTTP"

//   default_action {
//     type             = "forward"
//     target_group_arn = aws_lb_target_group.david-ialb-tgt.arn
//   }
// }

