from flask import Flask, request, jsonify
from flask_cors import CORS
import sys


app = Flask(__name__)
CORS(app)

@app.route("/")
def pcap_server():
    return jsonify({"message": "Server is live!"})

@app.route("/analyze", methods=["POST"])
def analyze():
    try:
        if 'file' not in request.files:
            return jsonify({"error": "No file part in request"}), 400
        file = request.files['file']
        if file.filename == '':
            return jsonify({"error": "No selected file"}), 400
        
        pcap_bytes = file.read()

        from fetch_function.analyze import analyze
        limit = request.args.get('limit', default=5, type=int)
        result = analyze(pcap_bytes, limit=limit)
        # Success! Returning JSON instead of HTML
        return jsonify(result)

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

@app.route("/analyze/ip", methods=["POST"])
def ip():
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

@app.route("/analyze/mac", methods=["POST"])
def mac():
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

if __name__ == "__main__":
    # Change port to 8080 to avoid Mac/System conflicts
    app.run(debug=True, port=8080)
