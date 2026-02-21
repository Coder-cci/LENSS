HTGET version 1.06, get a document via HTTP


Installation:

You need to run a packet driver and to configure wattcp.cfg first.
Remember to define a nameserver if you want to resolve hostnames.
Then to use the program, just run as:

	htget URL

where URL is a document on the Web that you want to fetch.  The initial
http:// can be omitted.  The returned document, if there is no error,
is sent to standard output.  Use > redirection or -o to save to a
file if this is desired. If an error occurs, the error code is printed
to stderr.

If the environment variable HTTP_PROXY is set to the host:port of
a proxy server, then htget will use that. In this case the http://
prefix of the URL cannot be omitted.

At the moment HTGET handles responses from HTTP/1.0 and HTTP/1.1 servers
only. Are there any HTTP/0.9 servers still in use?


Acknowledgements:

HTGET uses the excellent WATT32 package by Erick Engelke of the U of
Waterloo. Russ Nelson of Crynwr Software has put a lot of work into
packet drivers for many NICs.

HTGET is free software. The software is provided as-is and there is
NO SUPPORT.

If you have done some bug fixes on HTGET, or added any improvements, please
send me your code. This way I will be able to merge it to the official HTGET
release.

Note, that the original author doesn't take care of the program anymore. The
current maintainer is Mateusz Viste <mateusz@viste-family.net>.
