from scapy.all import rdpcap
from collections import Counter
import io

def get_pcap_protocols(pcap_file):
    
    fileData = io.BytesIO(pcap_file)
    packets = rdpcap(fileData)
    
    proto_counter = Counter()
    i = 1
    for packet in packets:
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
