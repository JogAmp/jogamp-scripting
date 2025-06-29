# Let's Encrypt Setup

## certbot
- `apt install certbot`

First add the acme redirect to your apache config, see below.
This allows webroot authentification.

- `certbot certonly`
  - 2. Place files in webroot directory -> authenticator: webroot
    - `[[webroot_map]]` -> `/srv/www/jogamp.org`

Results in `/etc/letsencrypt/renewal/jogamp.org.conf`:
```
# renew_before_expiry = 30 days
version = 2.1.0
archive_dir = /etc/letsencrypt/archive/jogamp.org
cert = /etc/letsencrypt/live/jogamp.org/cert.pem
privkey = /etc/letsencrypt/live/jogamp.org/privkey.pem
chain = /etc/letsencrypt/live/jogamp.org/chain.pem
fullchain = /etc/letsencrypt/live/jogamp.org/fullchain.pem

# Options used in the renewal process
[renewalparams]
account = ACCOUNT_ID
authenticator = webroot
server = https://acme-v02.api.letsencrypt.org/directory
key_type = ecdsa
[[webroot_map]]
jogamp.org = /srv/www/jogamp.org
mail.jogamp.org = /srv/www/jogamp.org
www.jogamp.org = /srv/www/jogamp.org
```
### Renewal Hooks
Install `apache`, `dovecot` and `sendmail` 
restart scripts into
`etc/letsencrypt/renewal-hooks/deploy/`.

## Test
- `certbot certificates`
- `certbot renew -v --dry-run`
- `systemctl status certbot`
- `/etc/letsencrypt/renewal/jogamp.org.conf`


## sendmail
Edit files to adopt new ssl cert
- `server/setup/05-service-settings/etc/mail/sendmail.mc`

## Dovecot
Edit files to adopt new ssl cert
- `/etc/dovecot/conf.d/10-ssl.conf`

## Apache
Add file `/etc/apache2/acme-and-redirect.conf`.

Edit files to allow acme redirection for webroot authentification
- `/etc/apache2/sites-available/jogamp_org-ssl.conf`
  - Include `/etc/apache2/acme-and-redirect.conf`.
- `/etc/apache2/sites-available/jogamp_org.conf`
  - Include `/etc/apache2/acme-and-redirect.conf`.

Edit files to adopt new ssl cert
- `/etc/apache2/sites-available/jogamp_org-ssl.conf`
  - Use ssl certs and keys 
    - `SSLCertificateFile /etc/letsencrypt/live/jogamp.org/fullchain.pem`
    - `SSLCertificateKeyFile /etc/letsencrypt/live/jogamp.org/privkey.pem`

