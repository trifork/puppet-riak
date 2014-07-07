Riak Puppet module
===

Example usage
---

```
class {"riak":
    version => 1.4.9-1,
    node_name => "riak@%{::ipaddress_eth0}",
    ring_creation_size => 64,
    http_address => "127.0.0.1,
    backend_default => "eleveldb"
    backends => [],
    default_bucket_props => "[{n_val,1}]"
    vmargs_pa => "/usr/lib/relai",
    vmargs_s = "riak_sync"
}
```
