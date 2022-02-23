# Global Variables
annotation = "easy-aci:0.9.5"
apicUrl    = "https://64.100.14.15"
apicUser   = "admin"

# BGP
autonomous_system_number = 65501
bgp_route_reflectors = {
  "1" = {
    node_list = [101, 102]
  }
}
