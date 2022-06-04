fabric_wide_settings = {
  "key" = {
    annotation                         = "value"
    disable_remote_ep_learning         = false
    enforce_domain_validation          = false
    enforce_epg_vlan_validation        = false
    enforce_subnet_check               = false
    leaf_opflex_client_authentication  = false
    leaf_ssl_opflex                    = false
    reallocate_gipo                    = false
    restrict_infra_vlan_traffic        = false
    spine_opflex_client_authentication = false
    spine_ssl_opflex                   = false
    ssl_opflex_versions = [{
      TLSv1   = false
      TLSv1_1 = false
      TLSv1_2 = false
    }]
  }
}