import os
from scapy.all import rdpcap
from scapy.layers.l2 import Ether, ARP
from scapy.layers.dns import DNS
from scapy.layers.http import HTTP
from scapy.layers.tls.all import TLS
from scapy.layers.inet import IP, TCP, UDP, ICMP
from scapy.layers.dns import DNS
from scapy.layers.dhcp import DHCP
from scapy.layers.dot11 import Dot11, RadioTap, Dot11Beacon, Dot11ProbeReq
from scapy.layers.netbios import NetBIOS_DS
import io

def get_osi(pcap_file, type):
    if type == 'path':
        if not os.path.exists(pcap_file):
            raise FileNotFoundError(f"The file at {pcap_file} was not found.")
        fileData = pcap_file
    elif type == 'bytes':
        fileData = io.BytesIO(pcap_file)
    else:
        raise ValueError("Invalid type specified. Must be 'path' or 'bytes'.")
    
    packets = rdpcap(fileData)

    if len(packets) > 2000:
        raise ValueError(f"File too large: {len(packets)} packets. Maximum allowed is 2000.")
    
    if len(packets) > 0:
        first_packet = packets[0]
        # Check if the packet has Wireless-specific layers
        if first_packet.haslayer(RadioTap) or first_packet.haslayer(Dot11):
            raise ValueError("Monitor Mode packets detected. Only standard Interface Mode (Ethernet) captures are supported.")

    osi_results = {
        '0' : {'data': [], 'count': 0}, '1' : {'data': [], 'count': 0}, '2' : {'data': [], 'count': 0}, '3' : {'data': [], 'count': 0}, '4' : {'data': [], 'count': 0}, '5' : {'data': [], 'count': 0}, '6' : {'data': [], 'count': 0}, '7' : {'data': [], 'count': 0}
    }
    for pkt in packets:
        response = map_osi_layer(pkt)
        for layer_num, layer_name, summary in response:
            number_str = str(layer_num)
            osi_results[number_str]['count'] += 1 # osi_results[number_str].get('count', 0) + 1
            osi_results[number_str]['data'].append({
                "layer_name": layer_name,
                "summary": summary,
            })

    return {
        "msg": "OSI layer mapping complete",
        "osi_mapping": osi_results
    }

def map_osi_layer(packet):
    # Layer 7: Application
    result = []

    if packet.haslayer(HTTP) or packet.haslayer(DNS) or packet.haslayer(DHCP):
        if packet.haslayer(HTTP):
            result.append((7, "Application", "HTTP"))
        if packet.haslayer(DNS):
            result.append((7, "Application", "DNS"))
        if packet.haslayer(DHCP):
            result.append((7, "Application", "DHCP"))
    
    # Layer 6: Presentation (TLS/SSL encryption lives here)
    if packet.haslayer(TLS):
        result.append((6, "Presentation", "Encrypted (TLS/SSL)"))
    
    # Layer 5: Session (NetBIOS/RPC)
    if packet.haslayer(NetBIOS_DS):
        result.append((5, "Session", "NetBIOS Session"))
    
    # Layer 4: Transport (TCP/UDP)
    if packet.haslayer(TCP):
        result.append((4, "Transport", f"TCP (Port: {packet[TCP].dport})"))
    if packet.haslayer(UDP):
        result.append((4, "Transport", f"UDP (Port: {packet[UDP].dport})"))
    
    # Layer 3: Network (IP/ICMP)
    if packet.haslayer(IP):
        result.append((3, "Network", f"IP ({packet[IP].src})"))
    if packet.haslayer(ICMP):
        result.append((3, "Network", "ICMP (Ping)"))
    
    # Layer 2: Data Link (Ethernet/ARP/802.11)
    if packet.haslayer(Dot11): # WiFi
        result.append((2, "Data Link", "WLAN (802.11)"))
    if packet.haslayer(ARP):
        result.append((2, "Data Link", "ARP (Hardware Address)"))
    if packet.haslayer(Ether):
        result.append((2, "Data Link", "Ethernet Frame"))
    
    # Layer 1: Physical (Represented by RadioTap in Monitor Mode)
    if packet.haslayer(RadioTap):
        result.append((1, "Physical", "Radio Signal Info"))

    if result:
        return result  # Return the first matched layer (most specific)
    else:
        return[( 0, "Unknown", "Other" )]  # Default if no known layers matched
