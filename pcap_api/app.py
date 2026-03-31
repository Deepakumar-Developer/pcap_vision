from flask import Flask, request, jsonify
from flask_cors import CORS
import sys

app = Flask(__name__)
CORS(app)

@app.route("/")
def index():
    return jsonify({"message": "PCAP Vision is live!"})

# Endpoint for get pcap using SSH and tshark
@app.route("/cmd/path", methods=["POST"])
def getPath():
    from cmd_function.get_path import get_path
    try:
        data = request.get_json()
        host = data.get('host')
        user = data.get('user')
        pwd = data.get('pwd')

        result = get_path(
            hostname=host,
            username=user,
            password=pwd
        )
        return jsonify(result), 200
    except Exception as e:
        return jsonify({"error": "Internal Server Error", "details": str(e)}), 500

@app.route("/cmd/interface", methods=["POST"])
def getInterface():
    from cmd_function.get_interface import get_interfance
    try:
        data = request.get_json()
        host = data.get('host')
        user = data.get('user')
        pwd = data.get('pwd')
        path = data.get('path')
        
        result = get_interfance(
            hostname=host,
            username=user,
            password=pwd,
            tshark_path=path
        )
        return jsonify(result), 200
    except Exception as e:
        return jsonify({"error": "Internal Server Error", "details": str(e)}), 500
    
@app.route("/cmd/get_pcap", methods=["POST"])
def getPCAP():
    from cmd_function.get_pcap import get_pcap
    try:
        data = request.get_json()
        host=data.get("host")
        user=data.get("user")
        pwd=data.get("pwd")
        path=data.get("path")
        index = data.get("index")

        result = get_pcap(
            hostname=host,
            username=user,
            password=pwd,
            tshark_path=path,
            index=index
        )
        return jsonify(result), 200
    except Exception as e:
        return jsonify({"error": "Internal Server Error", "details": str(e)}), 500
    
# Endpoints for validate and analyze PCAP files
@app.route("/analyze", methods=["POST"])
def analyze():
    try:        
        from fetch_function.analyze import analyzePCAP
        
        data = request.args.get('type', default='', type=str)  # Get the 'data' query parameter, default to empty JSON string
        print(data)
        if data and data.lower() == 'bytes':
            if 'file' not in request.files:
                return jsonify({"error": "No file part in request"}), 400
            file = request.files['file']

            if file.filename == '':
                return jsonify({"error": "No selected file"}), 400
            pcap_bytes = file.read()
            result = analyzePCAP(pcap_bytes, data.lower())
            return jsonify(result), 200
        elif data and data.lower() == 'path':
            path = request.get_json().get('path')
            print(path)
            if not path:
                print("No path provided in JSON body")
                return jsonify({"error": "No path provided in JSON body"}), 400
            result = analyzePCAP(path, data.lower())
            return jsonify(result), 200
        else:
            return jsonify({"error": "Invalid type specified. Must be 'path' or 'bytes'."}), 400

    except ValueError as ve:
        # This catches our custom 1000 packet limit error
        return jsonify({"error": "Validation Error", "details": str(ve)}), 400
    
    except Exception as e:
        # This prints the error to your terminal so you can read it!
        print(f"CRITICAL ERROR: {str(e)}", file=sys.stderr)
        return jsonify({"error": "Internal Server Error", "details": str(e)}), 500

@app.route("/analyze/metadata", methods=["POST"])
def metadata():
    try:        
        from fetch_function.analyze_metadata import analyze_metadata
        
        data = request.args.get('type', default='', type=str)  # Get the 'data' query parameter, default to empty JSON string
        if data and data.lower() == 'bytes':
            if 'file' not in request.files:
                return jsonify({"error": "No file part in request"}), 400
        
            file = request.files['file']
            if file.filename == '':
                return jsonify({"error": "No selected file"}), 400
            pcap_bytes = file.read()
            result = analyze_metadata(pcap_bytes, type='bytes')
            return jsonify(result), 200
        elif data and data.lower() == 'path':
            path = request.get_json().get('path')
            if not path:
                return jsonify({"error": "No path provided in JSON body"}), 400
            result = analyze_metadata(path, type='path')
            return jsonify(result), 200
        
    except ValueError as ve:
        # This catches our custom 1000 packet limit error
        return jsonify({"error": "Validation Error", "details": str(ve)}), 400

    except Exception as e:
        # This prints the error to your terminal so you can read it!
        print(f"CRITICAL ERROR: {str(e)}", file=sys.stderr)
        return jsonify({"error": "Internal Server Error", "details": str(e)}), 500

@app.route("/analyze/ipAddress", methods=["POST"])
def ipAddress():
    try:
        from fetch_function.analyze_ip_endpoints import analyze_ip_endpoints

        data = request.args.get('type', default='', type=str)  # Get the 'data' query parameter, default to empty JSON string
        if data and data.lower() == 'bytes':
            if 'file' not in request.files:
                return jsonify({"error": "No file part in request"}), 400
        
            file = request.files['file']
            if file.filename == '':
                return jsonify({"error": "No selected file"}), 400
            pcap_bytes = file.read()
            result = analyze_ip_endpoints(pcap_bytes, type='bytes')
            return jsonify(result), 200
        elif data and data.lower() == 'path':
            path = request.get_json().get('path')
            if not path:
                return jsonify({"error": "No path provided in JSON body"}), 400
            result = analyze_ip_endpoints(path, type='path')
            return jsonify(result), 200
        
    except ValueError as ve:
        # This catches our custom 1000 packet limit error
        return jsonify({"error": "Validation Error", "details": str(ve)}), 400

    except Exception as e:
        # This prints the error to your terminal so you can read it!
        print(f"CRITICAL ERROR: {str(e)}", file=sys.stderr)
        return jsonify({"error": "Internal Server Error", "details": str(e)}), 500

@app.route("/analyze/macAddress", methods=["POST"])
def macAddress():
    try:
        from fetch_function.analyze_mac_endpoints import analyze_mac_endpoints

        data = request.args.get('type', default='', type=str)  # Get the 'data' query parameter, default to empty JSON string
        if data and data.lower() == 'bytes':
            if 'file' not in request.files:
                return jsonify({"error": "No file part in request"}), 400
        
            file = request.files['file']
            if file.filename == '':
                return jsonify({"error": "No selected file"}), 400
            pcap_bytes = file.read()
            result = analyze_mac_endpoints(pcap_bytes, type='bytes')
            return jsonify(result), 200
        elif data and data.lower() == 'path':
            path = request.get_json().get('path')
            if not path:
                return jsonify({"error": "No path provided in JSON body"}), 400
            result = analyze_mac_endpoints(path, type='path')
            return jsonify(result), 200
        
    except ValueError as ve:
        # This catches our custom 1000 packet limit error
        return jsonify({"error": "Validation Error", "details": str(ve)}), 400

    except Exception as e:
        # This prints the error to your terminal so you can read it!
        print(f"CRITICAL ERROR: {str(e)}", file=sys.stderr)
        return jsonify({"error": "Internal Server Error", "details": str(e)}), 500
    
@app.route("/analyze/get_protocols", methods=["POST"])
def getProtocols():
    try:
        from fetch_function.get_pcap_protocol import get_pcap_protocols
        
        data = request.args.get('type', default='', type=str)  # Get the 'data' query parameter, default to empty JSON string
        if data and data.lower() == 'bytes':
            if 'file' not in request.files:
                return jsonify({"error": "No file part in request"}), 400
        
            file = request.files['file']
            if file.filename == '':
                return jsonify({"error": "No selected file"}), 400
            pcap_bytes = file.read()
            result = get_pcap_protocols(pcap_bytes, type='bytes')
            return jsonify(result), 200
        elif data and data.lower() == 'path':
            path = request.get_json().get('path')
            if not path:
                return jsonify({"error": "No path provided in JSON body"}), 400
            result = get_pcap_protocols(path, type='path')
            return jsonify(result), 200
        
    except ValueError as ve:
        # This catches our custom 1000 packet limit error
        return jsonify({"error": "Validation Error", "details": str(ve)}), 400

    except Exception as e:
        # This prints the error to your terminal so you can read it!
        print(f"CRITICAL ERROR: {str(e)}", file=sys.stderr)
        return jsonify({"error": "Internal Server Error", "details": str(e)}), 500
    
@app.route("/analyze/dns", methods=["POST"])
def dns():
    try:
        from fetch_function.analyze_dns import analyze_dns
        
        data = request.args.get('type', default='', type=str)  # Get the 'data' query parameter, default to empty JSON string
        if data and data.lower() == 'bytes':
            if 'file' not in request.files:
                return jsonify({"error": "No file part in request"}), 400
            file = request.files['file']
            if file.filename == '':
                return jsonify({"error": "No selected file"}), 400
            pcap_bytes = file.read()
            result = analyze_dns(pcap_bytes, type='bytes')
            return jsonify(result), 200
        elif data and data.lower() == 'path':
            path = request.get_json().get('path')
            if not path:
                return jsonify({"error": "No path provided in JSON body"}), 400
            result = analyze_dns(path, type='path')
            return jsonify(result), 200
        
    except ValueError as ve:
        # This catches our custom 1000 packet limit error
        return jsonify({"error": "Validation Error", "details": str(ve)}), 400

    except Exception as e:
        # This prints the error to your terminal so you can read it!
        print(f"CRITICAL ERROR: {str(e)}", file=sys.stderr)
        return jsonify({"error": "Internal Server Error", "details": str(e)}), 500
    
@app.route("/analyze/get_osi", methods=["POST"])
def getOSI():
    try:
        from fetch_function.get_osi import get_osi        
        data = request.args.get('type', default='', type=str)  # Get the 'data' query parameter, default to empty JSON string
        if data and data.lower() == 'bytes':
            if 'file' not in request.files:
                return jsonify({"error": "No file part in request"}), 400
            file = request.files['file']
            if file.filename == '':
                return jsonify({"error": "No selected file"}), 400
            pcap_bytes = file.read()
            result = get_osi(pcap_bytes, type='bytes')
            return jsonify(result), 200
        elif data and data.lower() == 'path':
            path = request.get_json().get('path')
            if not path:
                return jsonify({"error": "No path provided in JSON body"}), 400
            result = get_osi(path, type='path')
            return jsonify(result), 200
        
    except ValueError as ve:
        # This catches our custom 1000 packet limit error
        return jsonify({"error": "Validation Error", "details": str(ve)}), 400
    
    except Exception as e:
        # This prints the error to your terminal so you can read it!
        print(f"CRITICAL ERROR: {str(e)}", file=sys.stderr)
        return jsonify({"error": "Internal Server Error", "details": str(e)}), 500
    
# Get all the Protocols in given pcap file    
@app.route("/get/<string:protocol>", methods=["POST"])
def getProtocolInfo(protocol):
    try:
                
        pcap_details = request.get_json().get('pcap_details')  # Assuming the pcap details are sent in the JSON body under the key 'pcap_details'

        from fetch_function.get_protocol_info import get_protocol_info
        result = get_protocol_info(protocol, pcap_details)
        # Success! Returning JSON instead of HTML
        return jsonify(result), 200
    
    except ValueError as ve:
        # This catches our custom 1000 packet limit error
        return jsonify({"error": "Validation Error", "details": str(ve)}), 400

    except Exception as e:
        # This prints the error to your terminal so you can read it!
        print(f"CRITICAL ERROR: {str(e)}", file=sys.stderr)
        return jsonify({"error": "Internal Server Error", "details": str(e)}), 500
    
if __name__ == "__main__":
    # Change port to 8080 to avoid Mac/System conflicts
    app.run(debug=True, port=8080)