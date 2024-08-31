from flask import Flask, request, jsonify
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

# Sample data for demonstration purposes with all possible combinations of location and rating
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

    # Find matching restaurant(s)
    matching_restaurants = [restaurant for restaurant in restaurants if restaurant['location'] == location and restaurant['rating'] == rating]

    if matching_restaurants:
        return jsonify(matching_restaurants)
    
    return jsonify({'error': 'No matching restaurant details found.'}), 404

if __name__ == '__main__':
    app.run(debug=True, host='10.196.221.144', port=5000)
