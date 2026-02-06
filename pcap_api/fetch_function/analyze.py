from scapy.all import rdpcap, Raw, Padding
import ast 
import io

def analyze(pcap_file,limit):

    fileData = io.BytesIO(pcap_file)
    packets = rdpcap(fileData)

    print(packets[0].show())
    limit = min(len(packets), limit)

    show_packets = [packet_to_dict(p) for p in packets[:limit]]  # Convert packets to dicts for JSON serialization
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
            data[layer_name] = str(layer.load)  # Convert bytes to string for JSON
            layer = layer.payload if layer.payload.name != 'NoPayload' else None
            continue

        # Capture all defined fields for this specific layer
        data[layer_name] = ast.literal_eval(str(layer.fields).replace("<", '"').replace(">", '"'))  # Convert fields to string for better readability in JSON

        layer = layer.payload if layer.payload.name != 'NoPayload' else None

        print(f"Layer: {layer_name}, Fields: {data[layer_name]}")
        
    # print(f"Packet Summary: {data}")
    return data
