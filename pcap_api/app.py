from flask import Flask, request, jsonify
from flask_cors import CORS
import sys

app = Flask(__name__)
CORS(app)

@app.route("/")
def index():
    return jsonify({"message": "PCAP Vision is live!"})

@app.get("/test")

@app.route("/analyze", methods=["GET", "POST"])
def analyze():
    try:
        if 'file' not in request.files:
            return jsonify({"error": "No file part in request"}), 400
        file = request.files['file']
        if file.filename == '':
            return jsonify({"error": "No selected file"}), 400
        
        pcap_bytes = file.read()

        from fetch_function.analyze import analyze
        # get limit from query parameters, default to 5 if not provided (parameter is optional)
        limit = request.args.get('limit', default=5, type=int)
        result = analyze(pcap_bytes, limit=limit)
        # Success! Returning JSON instead of HTML
        return jsonify(result), 

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
        return jsonify(result)

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
        return jsonify(result)

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
        return jsonify(result)

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
        return jsonify(result)

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
        return jsonify(result)

    except Exception as e:
        # This prints the error to your terminal so you can read it!
        print(f"CRITICAL ERROR: {str(e)}", file=sys.stderr)
        return jsonify({"error": "Internal Server Error", "details": str(e)}), 500
    
if __name__ == "__main__":
    # Change port to 8080 to avoid Mac/System conflicts
    app.run(debug=True, port=8080)