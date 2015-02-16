dnsbl-milter
============

## How to install on Redhat/CentOS 6##

1. `git clone --recursive https://github.com/robin81/dnsbl-milter.git`
1. `yum -y install db4-devel glibc-devel make gcc sendmail-cf`
1. `useradd -u milter`
1. `make && make install`

## Main Configuration Files ##
1. `/etc/mail/dnsbl-milter.ini`
1. `/etc/mail/dnsbl-milter` made into `/etc/mail/dnsbl-milter.db` via `makemap hash dnsbl-milter < dnsbl-milter`

## Configuration Details ##

A lightweight and flexible Sendmail DNSBL &amp; DNSWL mail filter (milter). dnsbl-milter consults a set of DNS black lists and white lists to determine if messages from particular hosts should be accepted.

Configuration file at /etc/mail/dnsbl-milter.ini:

```
[DNSBL]
blacklist=blacklist1.blacklist.net,Error message to send back.
blacklist=bl.spamcop.net,Listed on SpamCop RBL. Check http://spamcop.net/
blacklist=b.barracudacentral.org,Listed on Barracuda Reputation Block. Check http://www.barracudacentral.org
whitelist=list.dnswl.org
```

It is useful to be able to whitelist and blacklist based on a combination of options; not just IP addresses.
`/etc/mail/dnsbl-milter.db` controls that. `/etc/mail/dnsbl-milter.db` is typically made via `cd /etc/mail && makemap hash dnsbl-milter < dnsbl-milter`.

`dnsbl-milter` will be looked up in the following priority for either value `1` (RBL checks) or `0` (skip RBL checks):
```
[from:]sender_address[to:]recipient_address
[from:]sender_address[connect:]smtp_connection_ip_octet_1.ip_octet_2.ip_octet_3.ip_octet4
[from:]sender_address[connect:]smtp_connection_ip_octet_1.ip_octet_2.ip_octet_3
[from:]sender_address[connect:]smtp_connection_ip_octet_1.ip_octet_2
[from:]sender_address[connect:]smtp_connection_ip_octet_1
[connect:]smtp_connection_ip_octet_1.ip_octet_2.ip_octet_3.ip_octet4
[connect:]smtp_connection_ip_octet_1.ip_octet_2.ip_octet_3
[connect:]smtp_connection_ip_octet_1.ip_octet_2
[connect:]smtp_connection_ip_octet_1
[default]
```

For instance, with the following `/etc/mail/dnsbl-milter` (that is made into `/etc/mail/dnsbl-milter.db`):
```
[from:]bob@bob.com[to:]alice@alice.com 0
[from:]john@john.com[connect:]1.2.3.4  0
[default]                              1
```
we will ensure that any emails that satisfy sender address `bob@bob.com` and recipient address `alice@alice.com` will not be checked against RBLs. Emails with from address `bob@bob.com` addressed towards others will continue to be checked against RBLs. Emails from `john@john.com` will be checked against RBLs unless it comes from connecting IP 1.2.3.4.

We are aware that from addresses are easily spoofable. It is useful to whitelist based on `from` and `to` combination. For instance, your organization expects important emails from `bob@bob.com` to `alice@alice.com` and `bob@bob.com` seems to have IPs of ill repute. Such whitelists can ensure that those important emails will never be bounced due to a RBL blacklist. Given the specificity of the whitelists, the organization may deem it to be acceptable to have such a whitelist.

