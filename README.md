dnsbl-milter
============

A lightweight and flexible Sendmail DNSBL &amp; DNSWL mail filter (milter). dnsbl-milter consults a set of DNS black lists and white lists to determine if messages from particular hosts should be accepted.

Configuration file at /etc/mail/dnsbl-milter.ini:

```
[DNSBL]
blacklist=blacklist1.blacklist.net,Error message to send back.
blacklist=bl.spamcop.net,Listed on SpamCop RBL. Check http://spamcop.net/
blacklist=b.barracudacentral.org,Listed on Barracuda Reputation Block. Check http://www.barracudacentral.org
whitelist=list.dnswl.org
```

Sometimes, it is useful to be able to whitelist and blacklist based on a combination of options; not just IP addresses.
`/etc/mail/dnsbl-milter.db` controls that. `/etc/mail/dnsbl-milter.db` is typically made via `cd /etc/mail && makemap hash dnsbl-milter < dnsbl-milter`.

`dnsbl-milter` will do the look up in the following priority for either value `1` (check blacklist) or `0` (skip blacklist):
1. [from:]sender_address[to:]recipient_address
1. [from:]sender_address[connect:]smtp_connection_ip_octet_1.ip_octet_2.ip_octet_3.ip_octet4
1. [from:]sender_address[connect:]smtp_connection_ip_octet_1.ip_octet_2.ip_octet_3
1. [from:]sender_address[connect:]smtp_connection_ip_octet_1.ip_octet_2
1. [from:]sender_address[connect:]smtp_connection_ip_octet_1
1. [connect:]smtp_connection_ip_octet_1.ip_octet_2.ip_octet_3.ip_octet4
1. [connect:]smtp_connection_ip_octet_1.ip_octet_2.ip_octet_3
1. [connect:]smtp_connection_ip_octet_1.ip_octet_2
1. [connect:]smtp_connection_ip_octet_1
1. [default]

For instance, with the following `/etc/mail/dnsbl-milter` (that is made into `/etc/mail/dnsbl-milter.db`):
```
[from:]bob@bob.com[to:]alice@alice.com 0
[default]                              1
```
we will ensure that any emails that satisfy sender from `bob@bob.com` and recipient `alice@alice.com` will not be checked against RBLs. Emails from `bob@bob.com` addressed towards others will continue to be checked against RBLs.

We are aware that from address are easily spoofable. Such whitelists can be useful. Say your organizations expect important emails from `bob@bob.com` to `alice@alice.com` and `bob@bob.com` seems to have IPs of ill repute. Such whitelists can ensure that those important emails will never be bounced due to a RBL blacklist. Given the specificity of the whitelists, the organization may deem it to be acceptable risk to have such a whitelist.


