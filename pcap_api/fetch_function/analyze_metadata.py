from scapy.all import rdpcap
from scapy.layers.dot11 import RadioTap, Dot11
import datetime
import io
import os

def analyze_metadata(pcap_file, type):

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
    
    # 1. Basic Stats
    total_packets = len(packets)
    total_bytes = sum(len(p) for p in packets)
    
    # 2. Time Duration
    start_time = packets[0].time
    end_time = packets[-1].time
    duration = float(end_time - start_time)

    # 3. Average Data Rate (Mbps)
    # (Total Bytes * 8 bits) / (Duration * 1,000,000)
    if duration > 0:
        avg_rate = (total_bytes * 8) / (duration * 10**6)
    else:
        avg_rate = 0

    print("--- SESSION METADATA ---")
    print(f"Total Packets  : {total_packets:,}")
    print(f"Total Data     : {total_bytes / 1024:.2f} KB")
    print(f"Start Time     : {datetime.datetime.fromtimestamp(float(start_time))}")
    print(f"Duration       : {duration:.2f} seconds")
    print(f"Avg Data Rate  : {avg_rate:.2f} Mbps")
    print("-" * 30)

    session_info = {
        "total_packets": total_packets,
        "total_bytes": total_bytes,
        "start_time": datetime.datetime.fromtimestamp(float(start_time)).isoformat(),
        "duration_seconds": duration,
        "average_data_rate_mbps": avg_rate
    }

    # 4. Traffic Spike Visualizer (The Bar Chart)
    print("\n--- TRAFFIC TIMELINE (Activity Spikes) ---")
    num_buckets = 10
    buckets = [0] * num_buckets
    interval = duration / num_buckets

    for p in packets:
        # Determine which bucket the packet falls into
        offset = float(p.time - start_time)
        index = int(offset / interval) if interval > 0 else 0
        if index >= num_buckets: index = num_buckets - 1
        buckets[index] += 1

    print(f'buckets: {buckets}')

    # Normalize the bar length for the terminal
    max_val = max(buckets) if buckets else 1
    for i, count in enumerate(buckets):
        bar_length = int((count / max_val) * 30) # Max 30 chars
        print(f"Slot {i+1:02}: {'#' * bar_length} ({count} pkts)")

    traffic_timeline = [{"slot": i+1, "packet_count": count} for i, count in enumerate(buckets)]

    return {'msg': 'metadata analysis complete', 'session_info': session_info, 'traffic_timeline': traffic_timeline}