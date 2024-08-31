from flask import Flask, request, jsonify
from flask_cors import CORS  # Import CORS

app = Flask(__name__)
CORS(app)  # Enable CORS for all routes

# Expanded hospital data for all combinations
HOSPITAL_DATA = [
    # Tambaram - Cardiology
    {
        'name': 'City Hospital',
        'location': 'Tambaram',
        'specialization': 'Cardiology',
        'address': '123 Main St, Tambaram',
        'contact': '7539621484'
    },
    # Tambaram - Neurology
    {
        'name': 'Health Hub',
        'location': 'Tambaram',
        'specialization': 'Neurology',
        'address': '101 Pine St, Tambaram',
        'contact': '8146816947'
    },
    # Tambaram - Orthopedics
    {
        'name': 'Orthopedic Center',
        'location': 'Tambaram',
        'specialization': 'Orthopedics',
        'address': '202 Maple St, Tambaram',
        'contact': '9988776655'
    },
    # Tambaram - Pediatrics
    {
        'name': 'Pediatric Clinic',
        'location': 'Tambaram',
        'specialization': 'Pediatrics',
        'address': '303 Cedar St, Tambaram',
        'contact': '2233445566'
    },
    # T.Nagar - Cardiology
    {
        'name': 'Heart Care Clinic',
        'location': 'T.Nagar',
        'specialization': 'Cardiology',
        'address': '404 Oak St, T.Nagar',
        'contact': '1122334455'
    },
    # T.Nagar - Neurology
    {
        'name': 'Neuro Health Center',
        'location': 'T.Nagar',
        'specialization': 'Neurology',
        'address': '505 Elm St, T.Nagar',
        'contact': '2233445566'
    },
    # T.Nagar - Orthopedics
    {
        'name': 'Orthopedic Specialist',
        'location': 'T.Nagar',
        'specialization': 'Orthopedics',
        'address': '606 Pine St, T.Nagar',
        'contact': '3344556677'
    },
    # T.Nagar - Pediatrics
    {
        'name': 'Children’s Clinic',
        'location': 'T.Nagar',
        'specialization': 'Pediatrics',
        'address': '707 Maple St, T.Nagar',
        'contact': '4455667788'
    },
    # Velachery - Cardiology
    {
        'name': 'Velachery Cardio Center',
        'location': 'Velachery',
        'specialization': 'Cardiology',
        'address': '808 Oak St, Velachery',
        'contact': '5566778899'
    },
    # Velachery - Neurology
    {
        'name': 'Velachery Neuro Clinic',
        'location': 'Velachery',
        'specialization': 'Neurology',
        'address': '909 Elm St, Velachery',
        'contact': '6677889900'
    },
    # Velachery - Orthopedics
    {
        'name': 'Orthopedic Hospital',
        'location': 'Velachery',
        'specialization': 'Orthopedics',
        'address': '1010 Pine St, Velachery',
        'contact': '7788990011'
    },
    # Velachery - Pediatrics
    {
        'name': 'Kids Health Center',
        'location': 'Velachery',
        'specialization': 'Pediatrics',
        'address': '1111 Maple St, Velachery',
        'contact': '8899001122'
    }
]

@app.route('/hospitals', methods=['GET'])
def get_hospitals():
    location = request.args.get('location')
    specialization = request.args.get('specialization')
    
    # Filter hospitals based on location and specialization
    filtered_hospitals = [
        hospital for hospital in HOSPITAL_DATA
        if (location is None or hospital['location'] == location) and
           (specialization is None or hospital['specialization'] == specialization)
    ]
    
    return jsonify(filtered_hospitals)

if __name__ == '__main__':
    # Run the Flask app on a specific IP address and port
    app.run(host='10.196.221.144', port=5000, debug=True)
