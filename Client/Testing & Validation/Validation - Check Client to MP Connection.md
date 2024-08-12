# VividRock - MECM - Infrastructure Toolkit - Check Client to MP Connection

[Text]

## Check MP HTTP[S] Pages

1. Open Internet browser on client
2. Attempt to connect to each of the following links

> Note: You should see pages resolve for the HTTP attempts. You should not see pages reslve for the HTTPS? Need to check.

```html
http[s]://<servername>/sms_mp/.sms_aut?mplist
http[s]://<servername>/sms_mp/.sms_aut?mpcert
http[s]://<servername>/sms_mp/.sms_aut?MPKEYINFORMATION
```