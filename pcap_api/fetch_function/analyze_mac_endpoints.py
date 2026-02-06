from scapy.all import rdpcap, Ether
from scapy.layers.inet import IP
from scapy.packet import Raw
from collections import Counter
import io

def analyze_mac_endpoints(pcap_file):

    fileData = io.BytesIO(pcap_file)
    packets = rdpcap(fileData)
    
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
        "top_source_macs": [{"mac": mac, "count": count} for mac, count in src_macs.items()],
        "top_destination_macs": [{"mac": mac, "count": count} for mac, count in dst_macs.items()],
        "top_conversations": [{"endpoints": pair, "count": count} for pair, count in conversations.items()]
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