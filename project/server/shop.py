from flask import Flask, request, jsonify
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

# Sample data for demonstration purposes
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

    # Find a matching shop
    for shop in shops:
        if (shop['location'] == location and
            shop['style'] == style and
            shop['rating'] == rating):
            return jsonify(shop)
    
    return jsonify({'error': 'No matching shop details found.'}), 404

if __name__ == '__main__':
    app.run(debug=True, host='10.196.221.144', port=5000)
