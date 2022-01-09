/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "bgpAsP"
 - Distinguished Name: "uni/fabric/bgpInstP-default"
GUI Location:
 - System > System Settings > BGP Route Reflector: {BGP_ASN}
_______________________________________________________________________________________________________________________
*/
resource "aci_rest" "BGP_ASN_{BGP_ASN}" {
  path       = "/api/node/mo/uni/fabric/bgpInstP-default/as.json"
  class_name = "bgpAsP"
  payload    = <<EOF
{
  "bgpAsP": {
    "attributes": {
      "dn": "uni/fabric/bgpInstP-default/as",
      "asn": "{BGP_ASN}"
    },
    "children": []
  }
}
  EOF
}

/*_____________________________________________________________________________________________________________________

API Information:
 - Class: "bgpRRNodePEp"
 - Distinguished Name: "uni/fabric/bgpInstP-default/rr/node-{Node_ID}"
GUI Location:
 - System > System Settings > BGP Route Reflector: Route Reflector Nodes
_______________________________________________________________________________________________________________________
*/
resource "aci_rest" "BGP_Route_Reflector_{Node_ID}" {
  path       = "/api/node/mo/uni/fabric/bgpInstP-default/rr/node-{Node_ID}.json"
  class_name = "bgpRRNodePEp"
  payload    = <<EOF
{
  "bgpRRNodePEp": {
    "attributes": {
      "dn": "uni/fabric/bgpInstP-default/rr/node-{Node_ID}",
      "id": "{Node_ID}",
      "rn": "node-{Node_ID}"
    },
    "children": []
  }
}
  EOF
}
