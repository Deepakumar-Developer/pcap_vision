def get_protocol_info(protocol,pcap):
    
    protocol = protocol.upper()
    fields = []  # Initialize fields as an empty list to store field names

    for pkt in pcap:
        if protocol in pkt:
            layer_data = pkt[protocol]
            fields.append(layer_data)
                
    return {
        "msg": "protocol info fetched",
        "protocol": protocol,
        'fields': fields}
    