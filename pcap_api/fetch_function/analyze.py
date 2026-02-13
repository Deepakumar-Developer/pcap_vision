from scapy.all import rdpcap, Raw, Padding
from scapy.layers.dot11 import RadioTap, Dot11
import ast 
import io

def analyzePCAP(pcap_file):

    fileData = io.BytesIO(pcap_file)
    packets = rdpcap(fileData)

    if len(packets) > 1000:
        raise ValueError(f"File too large: {len(packets)} packets. Maximum allowed is 1000.")
    
    if len(packets) > 0:
        first_packet = packets[0]
        # Check if the packet has Wireless-specific layers
        if first_packet.haslayer(RadioTap) or first_packet.haslayer(Dot11):
            raise ValueError("Monitor Mode packets detected. Only standard Interface Mode (Ethernet) captures are supported.")

    show_packets = [packet_to_dict(p) for p in packets]  # Convert packets to dicts for JSON serialization
    summary_packets = [str(p) for p in packets]  # Summarize packets for quick analysis

    return {
        "msg": "analysis complete",
        "packet_summaries": summary_packets,
        "packet_details": show_packets
    }

def packet_to_dict(pkt):
    data = {}
    layer = pkt
    while layer:
        # Get the layer name (e.g., 'IP', 'TCP')
        layer_name = layer.name

        if layer_name in ["Raw", "Padding"]:
            # For Raw and Padding layers, we want to capture the actual payload data
            data[layer_name.upper()] = str(layer.load)  # Convert bytes to string for JSON
            layer = layer.payload if layer.payload.name != 'NoPayload' else None
            continue

        # Capture all defined fields for this specific layer
        data[layer_name.upper()] = ast.literal_eval(str(layer.fields).replace("<", '"').replace(">", '"').replace("b'", "'"))  # Convert fields to string for better readability in JSON

        layer = layer.payload if layer.payload.name != 'NoPayload' else None

        # print(f"Layer: {layer_name}, Fields: {data[layer_name]}")
        
    # print(f"Packet Summary: {data}")
    return data
