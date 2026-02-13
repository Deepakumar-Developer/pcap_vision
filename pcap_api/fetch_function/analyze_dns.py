import os
from scapy.all import rdpcap, DNS
from scapy.layers.dot11 import Dot11, RadioTap, Dot11Beacon, Dot11ProbeReq
from collections import Counter
import io

def analyze_dns(pcap_file, type):
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

    query_counts = Counter()
    resolved_ips = {}  # Domain -> Set of IPs

    for pkt in packets:
        if pkt.haslayer(DNS):
            dns = pkt[DNS]
            
            # 1. Capture Queries (Requests)
            if dns.qr == 0:  # qr=0 means it's a Query
                qname = dns.qd.qname.decode().strip('.')
                query_counts[qname] += 1
            
            # 2. Capture Answers (Responses)
            elif dns.qr == 1:  # qr=1 means it's a Response
                if dns.ancount > 0:
                    # Look through all answer records (DNSRR)
                    for i in range(dns.ancount):
                        rr = dns.an[i]
                        if rr.type == 1:  # Type 1 is an 'A' record (IPv4)
                            qname = rr.rrname.decode().strip('.')
                            ip_val = rr.rdata
                            
                            if qname not in resolved_ips:
                                resolved_ips[qname] = set()
                            resolved_ips[qname].add(ip_val)

    dns_info = [{'domain': domain, 'count': count, 'ips': ", ".join(resolved_ips.get(domain, ["Pending/No Ans"]))} for domain, count in query_counts.items()]

    print(resolved_ips)
    print("\n--- DNS ANALYSIS (Domain Resolution) ---")
    print(f"{'Domain Name':<30} | {'Reqs':<5} | {'Resolved IP(s)'}")
    print("-" * 65)


    for domain, count in query_counts.most_common():
        # Get IPs if we found them, otherwise show 'N/A'
        ips = ", ".join(resolved_ips.get(domain, ["Pending/No Ans"]))
        print(f"{domain:<30} | {count:<5} | {ips}")

    return {'msg': 'DNS analysis completed successfully', 'dns_info': dns_info}
