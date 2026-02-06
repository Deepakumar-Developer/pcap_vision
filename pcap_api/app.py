from flask import Flask, request, jsonify
from flask_cors import CORS
import sys

app = Flask(__name__)
CORS(app)

@app.route("/")
def hello_world():
    return jsonify({"message": "Server is live!"})

@app.route("/analyze/datetime", methods=["POST"])
def analyze():
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

if __name__ == "__main__":
    # Change port to 8080 to avoid Mac/System conflicts
    app.run(debug=True, port=8080)
