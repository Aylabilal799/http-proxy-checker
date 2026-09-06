HTTP / HTTPS Proxy Checker (Windows)

A fast and accurate HTTP/HTTPS proxy checker for Windows.

This tool tests a list of proxies and only saves the ones that are really working (can successfully connect to the internet through the proxy).



Features





Multi-threaded (100 concurrent connections)



Full HTTP/HTTPS proxy testing



Real connectivity test through the proxy



Only saves real working proxies in working.txt



Shows live progress while scanning



Completely standalone (just double-click)



No extra software required



How to Use





Download check_http.bat



Create a file named IPs.txt in the same folder



Put your proxies inside IPs.txt (one per line)



Double-click check_http.bat



Wait for the scan to finish

Example of IPs.txt:

1.2.3.4:8080
5.6.7.8:3128
9.10.11.12:80
45.67.89.10:8888



Results

After the scan is completed, you will get two files:







File



Description





working.txt



Only real working proxies (recommended to use)





results_log.txt



Full detailed log of every tested proxy



Settings







Setting



Value





Concurrent Threads



100





Timeout per proxy



10 seconds





Test Target



http://httpbin.org/ip





Supported Protocols



HTTP & HTTPS proxies



Requirements





Windows 10 or Windows 11



PowerShell (already included in Windows)

No need to install anything extra.



How the Checking Works

The tool performs a real proxy test:





Connects to the proxy IP and port



Sends an HTTP request through the proxy to http://httpbin.org/ip



Checks if a valid response is received



Only marks the proxy as LIVE if the request succeeds through the proxy

This method is much more accurate than just checking if the port is open.



Notes





The tool works with both HTTP and HTTPS proxies.



Dead, filtered, or non-working proxies will not be saved in working.txt.



The more proxies you test, the longer the scan will take.



Make sure your IPs.txt file uses the format IP:PORT (one proxy per line).



Disclaimer

This tool is provided for educational and legitimate testing purposes only.
Use it only on proxies that you own or have explicit permission to test.
The developer is not responsible for any misuse of this tool.



License

MIT License

Copyright (c) 2026

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
