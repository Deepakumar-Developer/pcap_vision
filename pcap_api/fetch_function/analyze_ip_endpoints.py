from scapy.all import rdpcap
from scapy.layers.inet import IP
from collections import Counter
import io

def analyze_ip_endpoints(pcap_file):

    print(f"Analyzing PCAP file: {pcap_file[:50]}...")  # Print first 50 bytes for identification
    fileData = io.BytesIO(pcap_file)

    packets = rdpcap(fileData)
    
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
