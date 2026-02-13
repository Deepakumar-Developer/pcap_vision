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
def getInterfaces():
    from cmd_function.get_path import get_path
    try:
        hostname=request.json.get("host"),
        username=request.json.get("user"),
        password=request.json.get("pwd"),
        result = get_path(
            hostname=hostname,
            username=username,
            password=password
        )
        return jsonify(result), 200
    except Exception as e:
        return jsonify({"error": "Internal Server Error", "details": str(e)}), 500

@app.route("/cmd/interfaces", methods=["POST"])
def getInterfaces():
    from cmd_function.get_interface import get_interfance
    try:
        hostname=request.json.get("host"),
        username=request.json.get("user"),
        password=request.json.get("pwd"),
        tshark_path=request.json.get("tshark_path")
        result = get_interfance(
            hostname=hostname,
            username=username,
            password=password,
            tshark_path=tshark_path
        )
        return jsonify(result), 200
    except Exception as e:
        return jsonify({"error": "Internal Server Error", "details": str(e)}), 500
    
@app.route("/cmd/get_pcap", methods=["POST"])
def getInterfaces():
    from cmd_function.get_interface import get_interfance
    try:
        hostname=request.json.get("host"),
        username=request.json.get("user"),
        password=request.json.get("pwd"),
        tshark_path=request.json.get("tshark_path")
        index = request.json.get("index")
        result = get_interfance(
            hostname=hostname,
            username=username,
            password=password,
            tshark_path=tshark_path,
            index=index
        )
        return jsonify(result), 200
    except Exception as e:
        return jsonify({"error": "Internal Server Error", "details": str(e)}), 500
    

# Endpoints for validate and analyze PCAP files
@app.route("/analyze", methods=["POST"])
def analyze():
    try:
        if 'file' not in request.files:
            return jsonify({"error": "No file part in request"}), 400
        file = request.files['file']
        if file.filename == '':
            return jsonify({"error": "No selected file"}), 400
        
        pcap_bytes = file.read()

        from fetch_function.analyze import analyzePCAP
        # get limit from query parameters, default to 5 if not provided (parameter is optional)
        # limit = request.args.get('limit', default=5, type=int)
        result = analyzePCAP(pcap_bytes)
        # Success! Returning JSON instead of HTML
        return jsonify(result), 200

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
        if 'file' not in request.files:
            return jsonify({"error": "No file part in request"}), 400
        file = request.files['file']
        if file.filename == '':
            return jsonify({"error": "No selected file"}), 400
        
        pcap_bytes = file.read()

        from fetch_function.analyze_metadata import analyze_metadata
        result = analyze_metadata(pcap_bytes)
        # Success! Returning JSON instead of HTML
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
        if 'file' not in request.files:
            return jsonify({"error": "No file part in request"}), 400
        file = request.files['file']
        if file.filename == '':
            return jsonify({"error": "No selected file"}), 400
        
        pcap_bytes = file.read()

        from fetch_function.analyze_ip_endpoints import analyze_ip_endpoints
        result = analyze_ip_endpoints(pcap_bytes)
        # Success! Returning JSON instead of HTML
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
        if 'file' not in request.files:
            return jsonify({"error": "No file part in request"}), 400
        file = request.files['file']
        if file.filename == '':
            return jsonify({"error": "No selected file"}), 400
        
        pcap_bytes = file.read()

        from fetch_function.analyze_mac_endpoints import analyze_mac_endpoints
        result = analyze_mac_endpoints(pcap_bytes)
        # Success! Returning JSON instead of HTML
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
        if 'file' not in request.files:
            return jsonify({"error": "No file part in request"}), 400
        file = request.files['file']
        if file.filename == '':
            return jsonify({"error": "No selected file"}), 400
        
        pcap_bytes = file.read()

        from fetch_function.get_pcap_protocol import get_pcap_protocols
        result = get_pcap_protocols(pcap_bytes)
        # Success! Returning JSON instead of HTML
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
        if 'file' not in request.files:
            return jsonify({"error": "No file part in request"}), 400
        file = request.files['file']
        if file.filename == '':
            return jsonify({"error": "No selected file"}), 400
        
        pcap_bytes = file.read()

        from fetch_function.analyze_dns import analyze_dns
        result = analyze_dns(pcap_bytes)
        # Success! Returning JSON instead of HTML
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
        if 'file' not in request.files:
            return jsonify({"error": "No file part in request"}), 400
        file = request.files['file']
        if file.filename == '':
            return jsonify({"error": "No selected file"}), 400
        
        pcap_bytes = file.read()

        from fetch_function.get_osi import get_osi
        result = get_osi(pcap_bytes)
        # Success! Returning JSON instead of HTML
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