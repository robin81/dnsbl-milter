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
