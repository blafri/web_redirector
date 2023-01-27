# web_redirector
Used on Digital Ocean app platform to redirect naked domains to their www counterpart since App platform does not support that feature as yet.

To use it all you have to do is set an environment variable called REDIRECT_HOSTS to the host that you want to redirect to their www counterpart. REDIRECT_HOSTS should be a comma seperated list of hostname that are allowed to be redirected.

Eg:

REDIRECT_HOSTS=foo.com,bar.com


This will allow foo.com and bar.com to be redirected to www.foo.com and www.bar.com respectivly.
