#!/bin/bash

_SCRIPT_="$0"
ACME_BIN="/acme.sh/acme.sh --home /acme.sh --config-home /acmecerts"
DEFAULT_CONF="/etc/apache2/sites-available/000-default.conf"
CERTS="/etc/apache2/certs"

updatessl() {
ssl=0
cp /etc/apache2/sites-available/www.conf /etc/apache2/sites-available/ChurchCRM.conf
sed -i "s/#ServerName www.example.com/ServerName ${VIRTUAL_HOST}/g" /etc/apache2/sites-available/ChurchCRM.conf
sed -i "s\DocumentRoot /var/www/html\DocumentRoot ${VIRTUAL_ROOT}\g" /etc/apache2/sites-available/ChurchCRM.conf
#service apache2 force-reload

for site_info_base64 in $(cat /var/run/secrets/ssl | jq -r '.[] | @base64'); do
    _jq() {
       echo ${1} | base64 -d | jq -r ${2}
    }

    ssl_mode=$(_jq ${site_info_base64} '.ssl')

    case ${ssl_mode} in
        'letsencrypt')
            if ! [ -s "$CERTS/$(_jq ${site_info_base64} '.host').crt.pem" ]; then
                ssl_parameter_base64=$(_jq ${site_info_base64} '.'$(echo "${ssl_mode}"'|@base64'))
                case $(_jq ${ssl_parameter_base64} '.mode') in
                    'dns')
                        ssl=1
                        eval export $(jq -r '.Key1_name' /var/run/secrets/dns_api)=$(jq -r '.Key1_value' /var/run/secrets/dns_api)
                        eval export $(jq -r '.Key2_name' /var/run/secrets/dns_api)=$(jq -r '.Key2_value' /var/run/secrets/dns_api)
                        eval $ACME_BIN --issue --dns $(jq -r '.Provider' /var/run/secrets/dns_api) $(_jq ${ssl_parameter_base64} '.domain_parameter') $(_jq ${ssl_parameter_base64} '.extra_parameter') \
                            --cert-file "$CERTS/$(_jq ${site_info_base64} '.host').crt.pem" \
                            --key-file "$CERTS/$(_jq ${site_info_base64} '.host').key.pem" \
                            --fullchain-file "$CERTS/$(_jq ${site_info_base64} '.host').fullchain.pem" \
                            --reloadcmd "\"service apache2 force-reload\"";
                        ;;
                    'webroot')
                        eval $ACME_BIN --issue $(_jq ${ssl_parameter_base64} '.domain_parameter') --apache $(_jq ${ssl_parameter_base64} '.extra_parameter') \
                            --cert-file "$CERTS/$(_jq ${site_info_base64} '.host').crt.pem" \
                            --key-file "$CERTS/$(_jq ${site_info_base64} '.host').key.pem" \
                            --fullchain-file "$CERTS/$(_jq ${site_info_base64} '.host').fullchain.pem" \
                            --reloadcmd "\"service apache2 force-reload\"";
                        ;;
                    *)
                        echo "Unkown letsencrypt mode \"$(_jq ${ssl_parameter_base64} '.mode')\""
                        ;;
                esac
            else
               echo "skip updatessl"
            fi
            ;;
        'build')
            if ! [ -s "$CERTS/$(_jq ${site_info_base64} '.host').crt.pem" ]; then
                ssl_parameter_base64=$(_jq ${site_info_base64} '.'$(echo "${ssl_mode}"'|@base64'))
                opssl_parameter=\"/C=$(_jq ${ssl_parameter_base64} '.country')/ST=$(_jq ${ssl_parameter_base64} '.state')/L=$(_jq ${ssl_parameter_base64} '.locality')/O=$(_jq ${ssl_parameter_base64} '.organization')/OU=$(_jq ${ssl_parameter_base64} '.organizationalunit')/emailAddress=$(_jq ${ssl_parameter_base64} '.email')/CN=$(_jq ${site_info_base64} '.host')\";
                openssl genrsa -des3 -passout pass:xxxx -out rootCA.key 2048;
                eval openssl req -x509 -passin pass:xxxx -new -nodes -key rootCA.key -sha256 -days 1024 -out rootCA.pem -subj ${opssl_parameter};
                eval openssl req -new -sha256 -nodes -out server.csr -newkey rsa:2048 -keyout "$CERTS/$(_jq ${site_info_base64} '.host').key.pem" -subj ${opssl_parameter};
                openssl x509 -req -passin pass:xxxx -in server.csr -CA rootCA.pem -CAkey rootCA.key -CAcreateserial -out "$CERTS/$(_jq ${site_info_base64} '.host').crt.pem" -days 3600 -sha256 -extfile /app/v3.ext;
                rm rootCA.*
                rm server.csr
                ssl=1
            else
               echo "skip updatessl"
            fi
            ;;
        'own')
            echo "own ssl mode"
            ssl=1
            ;;
        'none')
            echo "no ssl"
            ;;
        *)
            echo "Unkown ssl mode \"${ssl_mode}\""
            ;;
    esac
done

a2ensite ChurchCRM.conf
if [ ssl == 1 ]; then
    cp /etc/apache2/sites-available/ssl.conf /etc/apache2/sites-available/ChurchCRM-ssl.conf
    sed -i "s\DocumentRoot /var/www/html\DocumentRoot ${VIRTUAL_ROOT}\g" /etc/apache2/sites-available/ChurchCRM-ssl.conf
    sed -i "s\SSLCertificateFile	/etc/ssl/certs/ssl-cert-snakeoil.pem\SSLCertificateFile	/etc/apache2/certs/${VIRTUAL_HOST}.crt.pem\g" /etc/apache2/sites-available/ChurchCRM-ssl.conf
    sed -i "s\SSLCertificateKeyFile /etc/ssl/private/ssl-cert-snakeoil.key\SSLCertificateKeyFile /etc/apache2/certs/${VIRTUAL_HOST}.key.pem\g" /etc/apache2/sites-available/ChurchCRM-ssl.conf
    a2enmod ssl
    a2ensite ChurchCRM-ssl.conf
fi
a2enmod rewrite
#service apache2 force-reload
}

"$@"
