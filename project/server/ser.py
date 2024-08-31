from itertools import product
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
    atm_list = ATM_DATA.get(location, "No ATMs found for the selected location.")
    return jsonify({'atms': atm_list})

# Sample hospital data
HOSPITAL_DATA = [
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
    filtered_hospitals = [
        hospital for hospital in HOSPITAL_DATA
        if (location is None or hospital['location'] == location) and
           (specialization is None or hospital['specialization'] == specialization)
    ]
    return jsonify(filtered_hospitals)

# Simulated database of addresses with updated price categories
ADDRESS_DATA = {
    ("Tambaram", "₹30L - ₹50L", "1 BHK"): "123 Tambaram Street, City Center, Contact: 5362859357",
    ("Tambaram", "₹30L - ₹50L", "2 BHK"): "456 Tambaram Ave, City Center, Contact: 3986523653",
    ("Tambaram", "₹30L - ₹50L", "3 BHK"): "789 Tambaram Blvd, City Center, Contact: 7634583847",
    ("Tambaram", "₹30L - ₹50L", "4 BHK"): "101 Tambaram Ln, City Center, Contact: 8523697410",
    ("Tambaram", "₹50L - ₹80L", "1 BHK"): "202 Tambaram Ave, City Center, Contact: 8687894427",
    ("Tambaram", "₹50L - ₹80L", "2 BHK"): "303 Tambaram Rd, City Center, Contact: 7539518524",
    ("Tambaram", "₹50L - ₹80L", "3 BHK"): "404 Tambaram Blvd, City Center, Contact: 7412369855",
    ("Tambaram", "₹50L - ₹80L", "4 BHK"): "505 Tambaram Dr, City Center, Contact: 9513698750",
    ("Tambaram", "₹80L+", "1 BHK"): "606 Tambaram Ave, City Center, Contact: 9513698750",
    ("Tambaram", "₹80L+", "2 BHK"): "707 Tambaram Rd, City Center, Contact: 8632549367",
    ("Tambaram", "₹80L+", "3 BHK"): "808 Tambaram Blvd, City Center, Contact: 7419652863",
    ("Tambaram", "₹80L+", "4 BHK"): "909 Tambaram Ln, City Center, Contact: 8523697410",
    ("T.Nagar", "₹30L - ₹50L", "1 BHK"): "101 T.Nagar Lane, Quiet Area, Contact: 8687894427",
    ("T.Nagar", "₹30L - ₹50L", "2 BHK"): "202 T.Nagar Rd, Quiet Area, Contact: 7539518524",
    ("T.Nagar", "₹30L - ₹50L", "3 BHK"): "303 T.Nagar Way, Quiet Area, Contact: 7412369855",
    ("T.Nagar", "₹30L - ₹50L", "4 BHK"): "404 T.Nagar Blvd, Quiet Area, Contact: 9513698750",
    ("T.Nagar", "₹50L - ₹80L", "1 BHK"): "505 T.Nagar Ave, Quiet Area, Contact: 8632549367",
    ("T.Nagar", "₹50L - ₹80L", "2 BHK"): "606 T.Nagar St, Quiet Area, Contact: 7419652863",
    ("T.Nagar", "₹50L - ₹80L", "3 BHK"): "707 T.Nagar Rd, Quiet Area, Contact: 8523697410",
    ("T.Nagar", "₹50L - ₹80L", "4 BHK"): "808 T.Nagar Ln, Quiet Area, Contact: 9513698750",
    ("T.Nagar", "₹80L+", "1 BHK"): "909 T.Nagar Blvd, Quiet Area, Contact: 8632549367",
    ("T.Nagar", "₹80L+", "2 BHK"): "101 T.Nagar Ct, Quiet Area, Contact: 7419652863",
    ("T.Nagar", "₹80L+", "3 BHK"): "202 T.Nagar Ln, Quiet Area, Contact: 8523697410",
    ("T.Nagar", "₹80L+", "4 BHK"): "303 T.Nagar Ave, Quiet Area, Contact: 9513698750",
    ("Velachery", "₹30L - ₹50L", "1 BHK"): "101 Velachery Rd, Green Pastures, Contact: 8687894427",
    ("Velachery", "₹30L - ₹50L", "2 BHK"): "202 Velachery Ave, Green Pastures, Contact: 7539518524",
    ("Velachery", "₹30L - ₹50L", "3 BHK"): "303 Velachery Blvd, Green Pastures, Contact: 7412369855",
    ("Velachery", "₹30L - ₹50L", "4 BHK"): "404 Velachery Dr, Green Pastures, Contact: 9513698750",
    ("Velachery", "₹50L - ₹80L", "1 BHK"): "505 Velachery Ct, Green Pastures, Contact: 8632549367",
    ("Velachery", "₹50L - ₹80L", "2 BHK"): "606 Velachery Ln, Green Pastures, Contact: 7419652863",
    ("Velachery", "₹50L - ₹80L", "3 BHK"): "707 Velachery Rd, Green Pastures, Contact: 8523697410",
    ("Velachery", "₹50L - ₹80L", "4 BHK"): "808 Velachery St, Green Pastures, Contact: 9513698750",
    ("Velachery", "₹80L+", "1 BHK"): "909 Velachery Ave, Green Pastures, Contact: 8632549367",
    ("Velachery", "₹80L+", "2 BHK"): "101 Velachery Ln, Green Pastures, Contact: 7419652863",
    ("Velachery", "₹80L+", "3 BHK"): "202 Velachery Rd, Green Pastures, Contact: 8523697410",
    ("Velachery", "₹80L+", "4 BHK"): "303 Velachery Ct, Green Pastures, Contact: 9513698750",
}

@app.route('/get-address', methods=['GET'])
def get_address():
    location = request.args.get('location')
    price = request.args.get('price')
    bhk = request.args.get('bhk')

    # Possible values for filtering
    locations = [location] if location else list(set(loc for loc, _, _ in ADDRESS_DATA.keys()))
    prices = [price] if price else list(set(pr for _, pr, _ in ADDRESS_DATA.keys()))
    bhks = [bhk] if bhk else list(set(bk for _, _, bk in ADDRESS_DATA.keys()))

    # Generate all combinations of the parameters
    combinations = product(locations, prices, bhks)

    # Filter addresses based on the generated combinations
    filtered_addresses = set()
    for combination in combinations:
        filtered_addresses.update({
            address for (loc, pr, bk), address in ADDRESS_DATA.items()
            if (combination[0] == loc or combination[0] == '*') and
               (combination[1] == pr or combination[1] == '*') and
               (combination[2] == bk or combination[2] == '*')
        })

    if filtered_addresses:
        address_list = "\n".join(filtered_addresses)
    else:
        address_list = "No address found for the selected options."

    return jsonify({'address': address_list})

# Sample data for restaurants
restaurants = [
    {
        'name': 'Tambaram Diner',
        'address': '123 Main St, Tambaram',
        'description': 'A cozy diner in the heart of Tambaram.',
        'contact': '6871917684',
        'location': 'Tambaram',
        'rating': '1 Star'
    },
    {
        'name': 'Tambaram Diner Plus',
        'address': '124 Main St, Tambaram',
        'description': 'A cozy diner with enhanced services.',
        'contact': '6871917685',
        'location': 'Tambaram',
        'rating': '2 Stars'
    },
    {
        'name': 'Tambaram Elite',
        'address': '125 Main St, Tambaram',
        'description': 'An elite dining experience in Tambaram.',
        'contact': '6871917686',
        'location': 'Tambaram',
        'rating': '3 Stars'
    },
    {
        'name': 'Tambaram Grand',
        'address': '126 Main St, Tambaram',
        'description': 'A grand restaurant for all occasions.',
        'contact': '6871917687',
        'location': 'Tambaram',
        'rating': '4 Stars'
    },
    {
        'name': 'Tambaram Supreme',
        'address': '127 Main St, Tambaram',
        'description': 'Supreme dining experience in Tambaram.',
        'contact': '6871917688',
        'location': 'Tambaram',
        'rating': '5 Stars'
    },
    {
        'name': 'T.Nagar Eats',
        'address': '456 Elm St, T.Nagar',
        'description': 'Family-friendly dining in T.Nagar.',
        'contact': '1698471842',
        'location': 'T.Nagar',
        'rating': '1 Star'
    },
    {
        'name': 'T.Nagar Delight',
        'address': '457 Elm St, T.Nagar',
        'description': 'Delicious meals in the heart of T.Nagar.',
        'contact': '1698471843',
        'location': 'T.Nagar',
        'rating': '2 Stars'
    },
    {
        'name': 'T.Nagar Bistro',
        'address': '458 Elm St, T.Nagar',
        'description': 'A trendy bistro in T.Nagar.',
        'contact': '1698471844',
        'location': 'T.Nagar',
        'rating': '3 Stars'
    },
    {
        'name': 'T.Nagar Gourmet',
        'address': '459 Elm St, T.Nagar',
        'description': 'Gourmet dining experience in T.Nagar.',
        'contact': '1698471845',
        'location': 'T.Nagar',
        'rating': '4 Stars'
    },
    {
        'name': 'T.Nagar Supreme',
        'address': '460 Elm St, T.Nagar',
        'description': 'Supreme dining in T.Nagar.',
        'contact': '1698471846',
        'location': 'T.Nagar',
        'rating': '5 Stars'
    },
    {
        'name': 'Velachery Bistro',
        'address': '789 Oak St, Velachery',
        'description': 'A charming bistro in Velachery.',
        'contact': '6134897156',
        'location': 'Velachery',
        'rating': '1 Star'
    },
    {
        'name': 'Velachery Dining',
        'address': '790 Oak St, Velachery',
        'description': 'Comfortable dining in Velachery.',
        'contact': '6134897157',
        'location': 'Velachery',
        'rating': '2 Stars'
    },
    {
        'name': 'Velachery Elite',
        'address': '791 Oak St, Velachery',
        'description': 'Elite dining experience in Velachery.',
        'contact': '6134897158',
        'location': 'Velachery',
        'rating': '3 Stars'
    },
    {
        'name': 'Velachery Grandeur',
        'address': '792 Oak St, Velachery',
        'description': 'A grandeur restaurant for special occasions.',
        'contact': '6134897159',
        'location': 'Velachery',
        'rating': '4 Stars'
    },
    {
        'name': 'Velachery Supreme',
        'address': '793 Oak St, Velachery',
        'description': 'Supreme dining in Velachery.',
        'contact': '6134897160',
        'location': 'Velachery',
        'rating': '5 Stars'
    }
]

@app.route('/get_restaurant_details', methods=['POST'])
def get_restaurant_details():
    data = request.get_json()
    location = data.get('location')
    rating = data.get('rating')
    for restaurant in restaurants:
        if restaurant['location'] == location and restaurant['rating'] == rating:
            return jsonify(restaurant)
    return jsonify({'error': 'No matching restaurant details found.'}), 404

# Sample data for shopping
shops = [
    # Tambaram
    {
        'name': 'Tambaram Fashion Store',
        'address': '123 Main St, Tambaram',
        'description': 'A trendy store with a variety of fashion styles.',
        'contact': '6547893210',
        'location': 'Tambaram',
        'style': 'DualStyle',
        'rating': '4 Stars'
    },
    {
        'name': 'Tambaram Men\'s Wear',
        'address': '456 Maple St, Tambaram',
        'description': 'Exclusive men\'s wear with the latest trends.',
        'contact': '6210896732',
        'location': 'Tambaram',
        'style': 'Men\'s Wear',
        'rating': '3 Stars'
    },
    {
        'name': 'Tambaram Women\'s Boutique',
        'address': '789 Pine St, Tambaram',
        'description': 'A beautiful collection of women\'s wear.',
        'contact': '7328091123',
        'location': 'Tambaram',
        'style': 'Women\'s Wear',
        'rating': '5 Stars'
    },
    # T.Nagar
    {
        'name': 'T.Nagar Fashion Hub',
        'address': '123 Cedar St, T.Nagar',
        'description': 'A hub for all your fashion needs.',
        'contact': '6540987123',
        'location': 'T.Nagar',
        'style': 'DualStyle',
        'rating': '2 Stars'
    },
    {
        'name': 'T.Nagar Men\'s Apparel',
        'address': '456 Elm St, T.Nagar',
        'description': 'Quality clothing for the entire family.',
        'contact': '1489429163',
        'location': 'T.Nagar',
        'style': 'Men\'s Wear',
        'rating': '3 Stars'
    },
    {
        'name': 'T.Nagar Women\'s Fashion',
        'address': '789 Birch St, T.Nagar',
        'description': 'Elegant and stylish women\'s wear.',
        'contact': '7891236540',
        'location': 'T.Nagar',
        'style': 'Women\'s Wear',
        'rating': '4 Stars'
    },
    # Velachery
    {
        'name': 'Velachery DualStyle Outlet',
        'address': '123 Oak St, Velachery',
        'description': 'A blend of men\'s and women\'s fashion.',
        'contact': '9812674350',
        'location': 'Velachery',
        'style': 'DualStyle',
        'rating': '1 Star'
    },
    {
        'name': 'Velachery Men\'s Boutique',
        'address': '456 Palm St, Velachery',
        'description': 'Top-notch men\'s wear for all occasions.',
        'contact': '6198118867',
        'location': 'Velachery',
        'style': 'Men\'s Wear',
        'rating': '5 Stars'
    },
    {
        'name': 'Velachery Women\'s Exclusive',
        'address': '789 Oak St, Velachery',
        'description': 'Exclusive designs and premium fabrics.',
        'contact': '9812367489',
        'location': 'Velachery',
        'style': 'Women\'s Wear',
        'rating': '4 Stars'
    }
]

@app.route('/get_shop_details', methods=['POST'])
def get_shop_details():
    data = request.get_json()
    location = data.get('location')
    style = data.get('style')
    rating = data.get('rating')
    for shop in shops:
        if (shop['location'] == location and
            shop['style'] == style and
            shop['rating'] == rating):
            return jsonify(shop)
    return jsonify({'error': 'No matching shop details found.'}), 404

if __name__ == '__main__':
    app.run(host='10.196.221.144', port=5000, debug=True)
