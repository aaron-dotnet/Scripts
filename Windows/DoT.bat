netsh dns add global dot=yes
netsh dns add encryption server=1.1.1.1 dothost=: autoupgrade=yes
netsh dns add encryption server=1.0.0.1 dothost=: autoupgrade=yes
netsh dns add encryption server=2606:4700:4700::1111 dothost=: autoupgrade=yes
netsh dns add encryption server=2606:4700:4700::1001 dothost=: autoupgrade=yes

ipconfig /flushdns
netsh dns show global
netsh dns show encryption
