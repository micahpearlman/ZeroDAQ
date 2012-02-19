import socket
import sys

HOST = '169.254.1.1'    # The remote host
PORT = 2000              # The same port as used by the server
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect(("169.254.1.1", 2000))
raw_input("Press Enter")
while 1:
	data = s.recv(1)
	sys.stdout.write(data)
s.close()
print 'Received', repr(data)
