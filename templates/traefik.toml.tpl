################################################################
# Global configuration
################################################################

checkNewVersion = false

# Backends throttle duration: minimum duration in seconds between 2 events from providers
# before applying a new configuration. It avoids unnecessary reloads if multiples events
# are sent in a short amount of time.
#
# Optional
# Default: "2"
#
# ProvidersThrottleDuration = "5"

# If non-zero, controls the maximum idle (keep-alive) to keep per-host.  If zero, DefaultMaxIdleConnsPerHost is used.
# If you encounter 'too many open files' errors, you can either change this value, or change `ulimit` value.
#
# Optional
# Default: http.DefaultMaxIdleConnsPerHost
#
# MaxIdleConnsPerHost = 200

# If set to true invalid SSL certificates are accepted for backends.
# Note: This disables detection of man-in-the-middle attacks so should only be used on secure backend networks.
# Optional
# Default: false
#
# InsecureSkipVerify = true

# Entrypoints to be used by frontends that do not specify any entrypoint.
# Each frontend can specify its own entrypoints.
#
# Optional
# Default: ["http"]
#
# defaultEntryPoints = ["http", "https"]


# Entrypoints definition
#
# Optional
# Default:
# [entryPoints]
#   [entryPoints.http]
#   address = ":80"
#
# To redirect an http entrypoint to an https entrypoint (with SNI support):
# [entryPoints]
#   [entryPoints.http]
#   address = ":80"
#     [entryPoints.http.redirect]
#       entryPoint = "https"
#   [entryPoints.https]
#   address = ":443"
#     [entryPoints.https.tls]
#       [[entryPoints.https.tls.certificates]]
#       CertFile = "integration/fixtures/https/snitest.com.cert"
#       KeyFile = "integration/fixtures/https/snitest.com.key"
#       [[entryPoints.https.tls.certificates]]
#       CertFile = "integration/fixtures/https/snitest.org.cert"
#       KeyFile = "integration/fixtures/https/snitest.org.key"
#
# To redirect an entrypoint rewriting the URL:
# [entryPoints]
#   [entryPoints.http]
#   address = ":80"
#     [entryPoints.http.redirect]
#       regex = "^http://localhost/(.*)"
#       replacement = "http://mydomain/$1"
#
# To enable basic auth on an entrypoint
# with 2 user/pass: test:test and test2:test2
# Passwords can be encoded in MD5, SHA1 and BCrypt: you can use htpasswd to generate those ones
# [entryPoints]
#   [entryPoints.http]
#   address = ":80"
#   [entryPoints.http.auth.basic]
#   users = ["test:$apr1$H6uskkkW$IgXLP6ewTrSuBkTrqE8wj/", "test2:$apr1$d9hr9HBB$4HxwgUir3HP4EsggP/QNo0"]
#
# To enable digest auth on an entrypoint
# with 2 user/realm/pass: test:traefik:test and test2:traefik:test2
# You can use htdigest to generate those ones
# [entryPoints]
#   [entryPoints.http]
#   address = ":80"
#   [entryPoints.http.auth.basic]
#   users = ["test:traefik:a2688e031edb4be6a3797f3882655c05 ", "test2:traefik:518845800f9e2bfb1f1f740ec24f074e"]
#
# To specify an https entrypoint with a minimum TLS version, and specifying an array of cipher suites (from crypto/tls):
# [entryPoints]
#   [entryPoints.https]
#   address = ":443"
#     [entryPoints.https.tls]
#     MinVersion = "VersionTLS12"
#     CipherSuites = ["TLS_RSA_WITH_AES_256_GCM_SHA384"]
#       [[entryPoints.https.tls.certificates]]
#       CertFile = "integration/fixtures/https/snitest.com.cert"
#       KeyFile = "integration/fixtures/https/snitest.com.key"
#       [[entryPoints.https.tls.certificates]]
#       CertFile = "integration/fixtures/https/snitest.org.cert"
#       KeyFile = "integration/fixtures/https/snitest.org.key"

# To enable compression support using gzip format:
# [entryPoints]
#   [entryPoints.http]
#   address = ":80"
#   compress = true

# Enable retry sending request if network error
#
# Optional
#
# [retry]

# Number of attempts
#
# Optional
# Default: (number servers in backend) -1
#
# attempts = 3

################################################################
# Web configuration backend
################################################################

# Enable web configuration backend
#
# Optional
#
# [web]

# Web administration port
#
# Required
#
# address = ":8080"

# SSL certificate and key used
#
# Optional
#
# CertFile = "traefik.crt"
# KeyFile = "traefik.key"
#
# Set REST API to read-only mode
#
# Optional
# ReadOnly = false
#
# Enable more detailed statistics
# [web.statistics]
#   RecentErrors = 10

# To enable basic auth on the webui
# with 2 user/pass: test:test and test2:test2
# Passwords can be encoded in MD5, SHA1 and BCrypt: you can use htpasswd to generate those ones
#   [web.auth.basic]
#     users = ["test:$apr1$H6uskkkW$IgXLP6ewTrSuBkTrqE8wj/", "test2:$apr1$d9hr9HBB$4HxwgUir3HP4EsggP/QNo0"]
# To enable digest auth on the webui
# with 2 user/realm/pass: test:traefik:test and test2:traefik:test2
# You can use htdigest to generate those ones
#   [web.auth.digest]
#     users = ["test:traefik:a2688e031edb4be6a3797f3882655c05 ", "test2:traefik:518845800f9e2bfb1f1f740ec24f074e"]


################################################################
# File configuration backend
################################################################

# Enable file configuration backend
#
# Optional
#
# [file]

# Rules file
# If defined, traefik will load rules from this file,
# otherwise, it will load rules from current file (cf Sample rules below).
#
# Optional
#
# filename = "rules.toml"

# Enable watch file changes
#
# Optional
#
# watch = true


################################################################
# Docker configuration backend
################################################################

# Enable Docker configuration backend
#
# Optional
#

[docker]
endpoint = "unix:///var/run/docker.sock"
domain = "ci.avenuecode"
watch = true
exposedbydefault = true


################################################################
# Sample rules
################################################################
# [backends]
#   [backends.backend1]
#     [backends.backend1.circuitbreaker]
#       expression = "NetworkErrorRatio() > 0.5"
#     [backends.backend1.servers.server1]
#     url = "http://172.17.0.2:80"
#     weight = 10
#     [backends.backend1.servers.server2]
#     url = "http://172.17.0.3:80"
#     weight = 1
#   [backends.backend2]
#     [backends.backend2.LoadBalancer]
#       method = "drr"
#     [backends.backend2.servers.server1]
#     url = "http://172.17.0.4:80"
#     weight = 1
#     [backends.backend2.servers.server2]
#     url = "http://172.17.0.5:80"
#     weight = 2
#
# [frontends]
#   [frontends.frontend1]
#   backend = "backend2"
#     [frontends.frontend1.routes.test_1]
#     rule = "Host: test.localhost, other.localhost"
#   [frontends.frontend2]
#   backend = "backend1"
#   passHostHeader = true
#   entrypoints = ["https"] # overrides defaultEntryPoints
#     [frontends.frontend2.routes.test_1]
#     rule = "Host:{subdomain:[a-z]+}.localhost"
#   [frontends.frontend3]
#   entrypoints = ["http", "https"] # overrides defaultEntryPoints
#   backend = "backend2"
#     rule = "Path: /test, /other"