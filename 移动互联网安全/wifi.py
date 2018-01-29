#!/usr/bin/env python

from __future__ import unicode_literals

import os
import sys
from scapy.all import Dot11, Dot11Elt, rdpcap


pcap = sys.argv[1]

if not os.path.isfile(pcap):
    print('input file does not exist')
    exit(1)

beacon_all = set()
beacon_null = set()
ssids_all = set()
ssids_hidden = set()
proberesp_all = set()

pkts = rdpcap(pcap)

for pkt in pkts:
    if not pkt.haslayer(Dot11Elt):
        continue
	
    if pkt.subtype == 8:  # Beacon Frame
        #print(pkt.summary())
        #print(pkt.getlayer(Dot11Elt).info)
        if pkt.getlayer(Dot11Elt).info.decode('utf-8').strip('\x00') == '':
			beacon_null.add(pkt.addr3)
        else:
            beacon_all.add(pkt.addr3)
            ssids_all.add(pkt.addr3 + '----' + pkt.getlayer(Dot11Elt).info.decode('utf-8'))
			#print pkt.getlayer(Dot11Elt).info.decode('utf-8')
    elif pkt.subtype == 5:  # Probe Response
            proberesp_all.add(pkt.addr3 + '----' + pkt.getlayer(Dot11Elt).info.decode('utf-8'))
            if pkt.addr3 in beacon_null:
                ssids_hidden.add(pkt.addr3 + '----' + pkt.getlayer(Dot11Elt).info.decode('utf-8'))
            else:
                ssids_all.add(pkt.addr3 + '----' + pkt.getlayer(Dot11Elt).info.decode('utf-8'))

for essid in ssids_hidden:
    print(essid)

rs = proberesp_all.difference(ssids_all).difference(ssids_hidden)

print('----------------------')
#print rs
for essid in rs:
    print(essid)