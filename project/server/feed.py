from flask import Flask, request, jsonify
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

# Simulated database to store feedback
FEEDBACK_DATA = {
    "Housing": [],
    "Restaurant": [],
    "Hospital": [],
    "ATM": [],
    "Shopping": []
}

@app.route('/submit-feedback', methods=['POST'])
def submit_feedback():
    data = request.json
    category = data.get('category')
    rating = data.get('rating')
    comment = data.get('comment')
    
    if category and rating and comment:
        # Save feedback
        FEEDBACK_DATA[category].append({
            'rating': rating,
            'comment': comment
        })
        return jsonify({'message': 'Feedback submitted successfully!'}), 200
    else:
        return jsonify({'message': 'Please complete all fields.'}), 400

@app.route('/get-feedback/<category>', methods=['GET'])
def get_feedback(category):
    if category in FEEDBACK_DATA:
        return jsonify({'feedback': FEEDBACK_DATA[category]}), 200
    else:
        return jsonify({'message': 'Category not found.'}), 404

if __name__ == '__main__':
    app.run(host='10.196.221.144', port=5000, debug=True)
