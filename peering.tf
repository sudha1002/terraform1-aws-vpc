resource "aws_vpc_peering_connection" "default" {
  count = var.is_vpc_peering ? 1 : 0  
  vpc_id      = aws_vpc.main.id
  peer_vpc_id = local.default_vpc_id
  auto_accept = true

  tags = merge(
    var.common_tags,
    var.vpc_peering_tags,
    {
        Name = "${local.resource_name}-default"
    }
  )
}

resource "aws_route" "public_route" {
  count = var.is_vpc_peering ? 1 : 0  
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = local.default_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.default[count.index].id
}
resource "aws_route" "private_route" {
  count = var.is_vpc_peering ? 1 : 0  
  route_table_id            = aws_route_table.private.id
  destination_cidr_block    = local.default_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.default[count.index].id
}  
resource "aws_route" "database_route" {
  count = var.is_vpc_peering ? 1 : 0  
  route_table_id            = aws_route_table.database.id
  destination_cidr_block    = local.default_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.default[count.index].id
}
resource "aws_route" "default" {
   

  route_table_id            = data.aws_rour_table.main.route_table_id
  destination_cidr_block    = var.vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.default[count.index].id
}