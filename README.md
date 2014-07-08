Riak Puppet module
===

Example usage
---

```
class {"riak":
    version => 1.4.9-1,
    node_name => "riak@${ipaddress_eth0}",
    ring_creation_size => 64,
    http_address => "127.0.0.1,
    backend_default => "eleveldb"
    backends => [],
    vmargs_pa => "/usr/lib/relai",
    vmargs_s = "riak_sync",
    additional_configuration => '{
        riak_sync, [
            {pb_port, 3333},
            {serverside_mapred_inputs_hook, {jp_hooks, gen_mapred_inputs}},
            {pb_ip, "172.30.252.55"}
        ]
    }'
}
```
