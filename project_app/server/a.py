from flask import Flask, request, jsonify
from flask_cors import CORS
from itertools import product

app = Flask(__name__)
CORS(app)

# Helper function to convert price range to numeric range
def parse_price_range(price_range):
    if '₹' not in price_range:
        return None
    parts = price_range.replace('₹', '').replace('L', '').split(' - ')
    try:
        min_price = int(parts[0])
        max_price = int(parts[1]) if len(parts) > 1 else float('inf')
        return min_price, max_price
    except ValueError:
        return None

# Simulated database of addresses
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

    locations = [location] if location else list(set(loc for loc, _, _ in ADDRESS_DATA.keys()))
    prices = [price] if price else list(set(pr for _, pr, _ in ADDRESS_DATA.keys()))
    bhks = [bhk] if bhk else list(set(bk for _, _, bk in ADDRESS_DATA.keys()))

    # Generate all combinations of the parameters
    combinations = product(locations, prices, bhks)

    filtered_addresses = set()
    for combination in combinations:
        loc, pr, bk = combination
        
        # Parse the price range for filtering
        pr_range = parse_price_range(pr) if pr and '₹' in pr else None
        
        for (db_loc, db_pr, db_bk), address in ADDRESS_DATA.items():
            db_pr_range = parse_price_range(db_pr) if '₹' in db_pr else None
            
            if (loc == '*' or loc == db_loc) and \
               (pr_range is None or db_pr_range is None or (pr_range[0] <= db_pr_range[1] and pr_range[1] >= db_pr_range[0])) and \
               (bk == '*' or bk == db_bk):
                filtered_addresses.add(address)

    if filtered_addresses:
        address_list = "\n".join(filtered_addresses)
    else:
        address_list = "No address found for the selected options."

    return jsonify({'address': address_list})

if __name__ == '__main__':
    app.run(host='10.196.221.144', port=5000, debug=True)
