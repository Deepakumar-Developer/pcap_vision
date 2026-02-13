import os
from scapy.all import rdpcap
from scapy.layers.inet import IP
from scapy.layers.dot11 import RadioTap, Dot11
from collections import Counter
import io

def analyze_ip_endpoints(pcap_file, type):
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
        
    src_ips = Counter()
    dst_ips = Counter()
    conversations = Counter()

    for pkt in packets:
        if pkt.haslayer(IP):
            src = pkt[IP].src
            dst = pkt[IP].dst
            
            # Count individual IPs
            src_ips[src] += 1
            dst_ips[dst] += 1
            
            # Count Pairings (Conversations)
            # We sort the pair so that A->B and B->A are counted as the same "talk"
            pair = tuple(sorted((src, dst)))
            conversations[pair] += 1

    # 1. Top 5 Source IPs
    print("\n--- TOP 5 SOURCE IPs (Who is sending?) ---")
    # print(src_ips)
    # print(dst_ips)
    for ip, count in src_ips.most_common(5):
        print(f"{ip:<15} : {count} packets")

    # 2. Top 5 Destination IPs (Where is it going?)
    print("\n--- TOP 5 DESTINATION IPs (The targets) ---")
    for ip, count in dst_ips.most_common(5):
        print(f"{ip:<15} : {count} packets")

    # 3. Common Conversations (The "Pairings")
    print("\n--- TOP 5 CONVERSATIONS (The Pairings) ---")
    print(f"{'Endpoint A':<15} <---> {'Endpoint B':<15} | {'Packets'}")
    print("-" * 50)
    for (ip_a, ip_b), count in conversations.items():
        print(f"{ip_a:<15} <---> {ip_b:<15} | {count}")

    ip_endpoint_info = {
        "top_source_ips": [{"ip": ip, "count": count} for ip, count in src_ips.items()],
        "top_destination_ips": [{"ip": ip, "count": count} for ip, count in dst_ips.items()],
        "top_conversations": [{"endpoints": pair, "count": count} for pair, count in conversations.items()]
    }

    return {'msg': 'IP endpoint analysis complete', 'ip_endpoint_info': ip_endpoint_info}
