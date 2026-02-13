from scapy.all import rdpcap
from scapy.layers.dot11 import Dot11, RadioTap
from collections import Counter
import io

def get_pcap_protocols(pcap_file):
    
    fileData = io.BytesIO(pcap_file)
    packets = rdpcap(fileData)

    if len(packets) > 1000:
        raise ValueError(f"File too large: {len(packets)} packets. Maximum allowed is 1000.")
    
    if len(packets) > 0:
        first_packet = packets[0]
        # Check if the packet has Wireless-specific layers
        if first_packet.haslayer(RadioTap) or first_packet.haslayer(Dot11):
            raise ValueError("Monitor Mode packets detected. Only standard Interface Mode (Ethernet) captures are supported.")
    
    proto_counter = Counter()
    i = 1
    for packet in packets[0:1]:
        # Loop through each layer in the current packet
        layer_index = 0
        # print(f"{i} {packet}")
        i += 1
        while True:
            layer = packet.getlayer(layer_index)
            # print(f"{packet.haslayer(layer.)}")
            if layer is None:
                break
            # Add the name of the protocol layer (e.g., 'IP', 'TCP') to our counter
            proto_counter[layer.name] += 1
            layer_index += 1

    protocol = [{"protocol": proto, "count": count} for proto, count in proto_counter.most_common()]

    return {'msg': 'protocol analysis complete', 'protocols': protocol}
