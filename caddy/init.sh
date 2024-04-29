#!/usr/bin/env bash
set -eu

# Plugins List:
# https://github.com/greenpau/caddy-trace
# https://github.com/greenpau/caddy-security
# https://github.com/abiosoft/caddy-exec
# https://github.com/caddyserver/transform-encoder
# https://github.com/caddyserver/replace-response
# https://github.com/abiosoft/caddy-exec
# https://github.com/neodyme-labs/user_agent_parse
# https://github.com/caddyserver/cache-handler
# https://github.com/greenpau/caddy-systemd

# DNS provider configuration for localhost.
localhost_dns=$(cat << EOF
  tls internal
EOF
)

# DNS provider configuration for DuckDNS.
duckdns_dns=$(cat << EOF
  tls {
    dns duckdns {
      api_token {\$TOKEN}
    }
  }
EOF
)
# DuckDNS Caddy plugin url.
duckdns_plugin="github.com/caddy-dns/duckdns"

# DNS provider configuration for Google Cloud DNS.
googlecloud_dns=$(cat << EOF
  tls {
    dns googleclouddns {
      gcp_project {\$GCP_PROJECT}
      gcp_application_default {\$GOOGLE_APPLICATION_CREDENTIALS}
    }
  }
EOF
)
# Google Cloud DNS Caddy plugin url.
googleclouddns_plugin="github.com/caddy-dns/googleclouddns"

# Format the plugins file in case the line endings are wrong.
dos2unix "$PLUGINS_LIST"

# Build plugins command using the default plugins from plugins.txt.
plugins=""
while read -r p;
do
  plugins="$plugins --with $p"
done < <(grep '' "$PLUGINS_LIST")

# Sets the DNS provider config in the Caddyfile depending on the environment variable (Default: localhost).
case ${DNS_PROVIDER:=localhost} in
  googleclouddns)
      export DNS_CONFIGURATION=$googlecloud_dns
      plugins="$plugins --with $googleclouddns_plugin"
      ;;
  duckdns)
      export DNS_CONFIGURATION=$duckdns_dns
      plugins="$plugins --with $duckdns_plugin"
      ;;
  *)
      export DNS_CONFIGURATION=$localhost_dns
      ;;
esac

# Directory to store the final Caddy configuration file.
mkdir -p "$CADDY_HOME/snippets"

# dns.conf file that has the placeholder to be substituted with the desired DNS configuration.
dns_conf_file="$CADDY_HOME/snippets/dns.conf"

# Substitute DNS_CONFIGURATION environment variable in the template and save as the DNS configuration to use.
# shellcheck disable=SC2016
envsubst '$DNS_CONFIGURATION' < "$CADDY_TEMPLATE" > "$dns_conf_file"

# Remove non-printable characters and trailing spaces from command.
plugins=$(echo "$plugins" | sed 's/[[:space:]]*$//' | sed 's/[^ -~]//g')

# Save the xcaddy command to a file for the next stage in the build process.
echo "xcaddy build --output $CADDY $plugins" > "$XCADDY_COMMAND"
