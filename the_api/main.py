import firebase_admin
from firebase_admin import firestore, credentials, initialize_app
import json
from flask import Flask, request, jsonify
from flask import escape
from flask_cors import CORS
import functions_framework
import uuid
import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
import datetime


cred= credentials.Certificate('key.json')
firebase_admin.initialize_app(cred)
db = firestore.client()
app = Flask(__name__)
CORS(app)


#create profile
@app.route('/Users', methods=['POST'])
def create_profile():
    user_info = request.get_json()
    # Check if the user already exists in Firestore
    user_log = db.collection('Users')
    student_ids = [doc.id for doc in user_log.list_documents()]
    if user_info['student_id'] in student_ids:
        error_message = "Error: user with ID " + user_info['student_id'] + " is already registered."
        return jsonify({"error": error_message}), 409
    else:
        user_log.document(user_info['student_id']).set(user_info)
        return jsonify(user_info), 201


#edit profile
@app.route('/Users', methods=['PATCH'])
def update_profile():
    user_info = request.get_json()
    student_id = request.args.get('student_id')
    user_log = db.collection('Users')
    user = user_log.document(student_id).get()
    if user.exists:
        user_data = {}
        for field in ['yeargroup', 'major', 'dob', 'residence', 'favorite_food', 'favorite_movie']:
            if field in user_info:
                user_data[field] = user_info[field]
            else:
                user_data[field] = user.to_dict().get(field)
        user_log.document(student_id).update(user_data)
        return user.to_dict()

    return jsonify({'error': 'user not found'}), 404



#retrieve profile
@app.route('/Users', methods=['GET'])
def retrieve_user():
    student_id = request.args.get('student_id')
    user_log = db.collection('Users')
    user = user_log.document(student_id).get()
    if user.exists:
        return jsonify(user.to_dict())
    
    return jsonify({'error': 'User not found'}), 404


@app.route('/Posts', methods=['POST'])
def create_post():
    post_data = request.get_json()
    record = json.loads(request.data)
    student_id = request.args.get('student_id')
    user_log = db.collection('Users')
    user = user_log.document(student_id).get()
    if user.exists and user.get('email') == post_data.get('email'):
        post_log = db.collection('Posts')
        post_data['timestamp'] = firestore.SERVER_TIMESTAMP
        post_log.add(post_data)
        
        sender = None  
        for user_doc in user_log.stream():
            userf = user_doc.to_dict()
            if userf['email'] == record['email']:
                sender = userf['name']
                break  
        
        if sender is not None:
            for user_doc in user_log.stream():
                userf = user_doc.to_dict()
                if userf['email'] != record['email']:
                    send_email(userf['email'], sender)
        
        return jsonify(post_data), 201
    return jsonify({'error': 'User not found or unauthorized'}), 404


def send_email(user_email, sender):
    
    data = {
        "to": user_email,
        "message": {
            "subject": "New post created",
            "html": f"Check this post out by {sender}",
        }
    }
    db.collection('mail').add(data)



#app.run(debug=True)