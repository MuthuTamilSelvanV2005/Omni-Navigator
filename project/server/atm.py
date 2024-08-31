
from flask import Flask, request, jsonify
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

# Simulated database of ATM locations
ATM_DATA = {
    "Tambaram": ["ATM 1: 123 Main St", "ATM 2: 456 Broadway St"],
    "T.Nagar": ["ATM 1: 789 Main St", "ATM 2: 101 Main Ln"],
    "Velachery": ["ATM 1: 102 Velachery Rd", "ATM 2: 103 Rural St"],
}

@app.route('/get-atm', methods=['GET'])
def get_atm():
    location = request.args.get('location')
    
    # Fetch ATM details based on the provided location
    atm_list = ATM_DATA.get(location, "No ATMs found for the selected location.")
    
    return jsonify({'atms': atm_list})

if __name__ == '__main__':
    app.run(host='10.196.221.144', port=5000, debug=True)
   
   

