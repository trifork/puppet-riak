class riak(
    $version = "1.4.9-1",
    $node_name = "riak@127.0.0.1",
    $ring_creation_size = 64,
    $http_address = "127.0.0.1",
    $ssl_cert = false,
    $ssl_cacert = false,
    $ssl_key = false,
    $backend_default = "bitcask",
    $backends = [],
    $vmargs_pa = "",
    $vmargs_s = "",
    $additional_configuration = "") {

    $version_split = split($version, "[.-]")
    $version_minor = "${version_split[0]}.${version_split[1]}"
    $version_patch = "${version_split[0]}.${version_split[1]}.${version_split[2]}"
    $package_name = "riak_${version}_amd64.deb"
    $package_location = "/tmp/${package_name}"
    $download_url = "http://s3.amazonaws.com/downloads.basho.com/riak/${version_minor}/${version_patch}/ubuntu/precise/${package_name}" #TODO: detect Ubuntu version

    if $ssl_key {
        debug("Enabling SSL enctryption")
        File[$ssl_key] ~> Service["riak"]
        File[$ssl_cert] ~> Service["riak"]
        if $ssl_cacert {
            debug("Enabling SSL mutual authentication")
            File[$ssl_cacert] ~> Service["riak"]
        }
    }

    exec {"download-riak":
        command => "/usr/bin/wget -O ${package_location} ${download_url}",
#        unless => "/bin/echo ```/usr/bin/wget -q -O - ${download_url}.sha``` \\*${package_location} | /usr/bin/sha1sum -c -",
        creates => $package_location
    } ->
    package {"riak":
        provider => "dpkg",
        ensure => latest,
        source => $package_location,
    } ->
    file {
        "/etc/riak/vm.args":
            ensure => file,
            mode => "0644",
            content => template("riak/vm.args");
        "/etc/riak/app.config":
            ensure => file,
            mode => "0644",
            content => template("riak/app.config");
    } ~>
    service {"riak":
        ensure => running,
    }
}