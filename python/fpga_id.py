#!/usr/bin/env python
import os
import sys
import time
from ev12aq600 import ev12aq600

app=ev12aq600()

if len(sys.argv) > 1:
    # Check 1st argument exists 
    com_port = sys.argv[1]
    print (">> Start serial with", com_port)
else:
    com_port = "COM14"
    print (">> Start serial with", com_port)
app.start_serial(com_port) 


ret=app.get_status()
print("-- Status: "+str(hex(ret)))

app.stop_serial()

