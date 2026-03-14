import os
from scapy.all import rdpcap, Ether
from scapy.layers.inet import IP
from scapy.layers.dot11 import Dot11, RadioTap
from scapy.packet import Raw
from collections import Counter
import io

def analyze_mac_endpoints(pcap_file, type):
    if type == 'path':
        if not os.path.exists(pcap_file):
            raise FileNotFoundError(f"The file at {pcap_file} was not found.")
        fileData = pcap_file
    elif type == 'bytes':
        fileData = io.BytesIO(pcap_file)
    else:
        raise ValueError("Invalid type specified. Must be 'path' or 'bytes'.")
    
    packets = rdpcap(fileData)

    if len(packets) > 1000:
        raise ValueError(f"File too large: {len(packets)} packets. Maximum allowed is 1000.")
    
    if len(packets) > 0:
        first_packet = packets[0]
        # Check if the packet has Wireless-specific layers
        if first_packet.haslayer(RadioTap) or first_packet.haslayer(Dot11):
            raise ValueError("Monitor Mode packets detected. Only standard Interface Mode (Ethernet) captures are supported.")
    
    src_macs = Counter()
    dst_macs = Counter()
    conversations = Counter()

    for pkt in packets:
        if pkt.haslayer(Raw):
            print(str(pkt[Raw].load.decode('latin-1', errors='ignore')) + '\n')

        if pkt.haslayer(Ether):
            src = pkt[Ether].src
            dst = pkt[Ether].dst
            
            # Count individual IPs
            src_macs[src] += 1
            dst_macs[dst] += 1
            
            # Count Pairings (Conversations)
            # We sort the pair so that A->B and B->A are counted as the same "talk"
            pair = tuple(sorted((src, dst)))
            conversations[pair] += 1

    mac_endpoint_info = {
        "source_macs": [{"mac": mac, "count": count} for mac, count in src_macs.items()],
        "destination_macs": [{"mac": mac, "count": count} for mac, count in dst_macs.items()],
        "conversations": [{"endpoints": pair, "count": count} for pair, count in conversations.items()]
    }

    # 1. Top 5 Source IPs
    print("\n--- TOP 5 SOURCE IPs (Who is sending?) ---")
    # print(src_macs)
    # print(dst_macs)
    print(conversations)
    for mac, count in src_macs.most_common(5):
        print(f"{mac:<15} : {count} packets")

    # 2. Top 5 Destination IPs (Where is it going?)
    print("\n--- TOP 5 DESTINATION IPs (The targets) ---")
    for mac, count in dst_macs.most_common(5):
        print(f"{mac:<15} : {count} packets")

    # 3. Common Conversations (The "Pairings")
    print("\n--- TOP 5 CONVERSATIONS (The Pairings) ---")
    print(f"{'Endpoint A':<15} <---> {'Endpoint B':<15} | {'Packets'}")
    print("-" * 50)
    for (mac_a, mac_b), count in conversations.items():
        print(f"{mac_a:<15} <---> {mac_b:<15} | {count}")

    return {'msg': 'MAC endpoint analysis complete', 'mac_endpoint_info': mac_endpoint_info}