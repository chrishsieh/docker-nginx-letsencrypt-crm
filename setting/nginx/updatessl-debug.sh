#!/usr/bin/env sh

_SCRIPT_="$0"

ACME_BIN="/acme.sh/acme.sh --home /acme.sh --config-home /acmecerts"

DEFAULT_CONF="/etc/nginx/conf.d/default.conf"


CERTS="/etc/nginx/certs"


updatessl() {
  nginx-debug -t && nginx-debug -s reload

  if ! [ -s "$CERTS/$(jq -r '.host' /var/run/secrets/ssl).crt" ]; then
        if [ $(jq -r '.letsencrypt.mode' /var/run/secrets/ssl) = "dns" ]; then
            eval export $(jq -r '.Key1_name' /var/run/secrets/dns_api)=$(jq -r '.Key1_value' /var/run/secrets/dns_api)
            eval export $(jq -r '.Key2_name' /var/run/secrets/dns_api)=$(jq -r '.Key2_value' /var/run/secrets/dns_api)
            eval $ACME_BIN --issue --dns $(jq -r '.Provider' /var/run/secrets/dns_api) $(jq -r '.letsencrypt.domain_parameter' /var/run/secrets/ssl) $(jq -r '.letsencrypt.extra_parameter' /var/run/secrets/ssl) \
            --fullchain-file "$CERTS/$(jq -r '.host' /var/run/secrets/ssl).crt" \
            --key-file "$CERTS/$(jq -r '.host' /var/run/secrets/ssl).key" \
            --reloadcmd "\"nginx-debug -t && nginx-debug -s reload\"";
        else
            eval $ACME_BIN --issue $(jq -r '.letsencrypt.domain_parameter' /var/run/secrets/ssl) --nginx $(jq -r '.letsencrypt.extra_parameter' /var/run/secrets/ssl) \
            --fullchain-file "$CERTS/$(jq -r '.host' /var/run/secrets/ssl).crt" \
            --key-file "$CERTS/$(jq -r '.host' /var/run/secrets/ssl).key" \
            --reloadcmd "\"nginx-debug -t && nginx-debug -s reload\"";
        fi

    #generate nginx conf again.
    docker-gen /app/nginx.tmpl /etc/nginx/conf.d/default.conf
  else
    echo "skip updatessl"
  fi
  nginx-debug -t && nginx-debug -s reload
}

"$@"
