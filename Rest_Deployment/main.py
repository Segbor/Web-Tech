import firebase_admin
from firebase_admin import firestore, credentials, initialize_app
import json
from flask import Flask, request, jsonify
from flask import escape
import functions_framework


@functions_framework.http
def election_http(request):
    request_json = request.get_json(silent=True)
    request_args = request.args
    if request.method == 'POST' and 'name' in request_json:
        return register_student()
    elif request.method == 'GET' and 'voter_id' in request_args:
        return retrieve_records()
    elif request.method == 'PUT' and 'major' in request_json:
        return update_voter()
    elif request.method == 'DELETE' and 'voter_id' in request_args:
        return deregister_student()
    elif request.method == 'POST' and 'candidates_and_votes' in request_json:
        return create_election()
    elif request.method == 'GET' and 'election_name' in request_args:
        return retrieve_election()
    elif request.method == 'DELETE' and 'election_name' in request_args:
        return delete_election()
    elif request.method == 'PUT' and 'candidate' in request_json:
        return vote()
    else:
        return jsonify({'error': 'Invalid request'}), 400

cred= credentials.Certificate('key.json')
firebase_admin.initialize_app(cred)
db = firestore.client()
app = Flask(__name__)

#@app.route('/voter', methods=['GET'])
def retrieve_records():
    voter_id = request.args.get('voter_id')
    voters_reg = db.collection('Ashesi_Voters')
    voter = voters_reg.document(voter_id).get()
    if voter.exists:
        return jsonify(voter.to_dict())
    
    return jsonify({'error': 'Voter not found'}), 404


#@app.route('/voter', methods=['POST'])
def register_student():
    student_record = json.loads(request.data)
    # Check if the student already exists in Firestore
    voters_reg = db.collection('Ashesi_Voters')
    voter_ids = [doc.id for doc in voters_reg.list_documents()]
    if student_record['voter_id'] in voter_ids:
        error_message = "Error: student with ID " + student_record['voter_id'] + " is already registered."
        return jsonify({"error": error_message}), 409
    else:
        voters_reg.document(student_record['voter_id']).set(student_record)
        return jsonify(student_record), 201


#@app.route('/voter', methods=['PUT'])
def update_voter():
    student_record = request.get_json()
    voter_id = student_record['voter_id']
    voters_reg = db.collection('Ashesi_Voters')
    voter = voters_reg.document(voter_id).get()
    if voter.exists:
        voters_reg.document(voter_id).update({'yeargroup': student_record['yeargroup'], 'major': student_record['major']})
        return voter.to_dict()
    
    return jsonify({'error': 'Student not found'}), 404


#@app.route('/voter', methods=['DELETE'])
def deregister_student():
    voter_id=request.args.get('voter_id')
    voters_reg = db.collection('Ashesi_Voters')
    voter=voters_reg.document(voter_id).get()
    if voter.exists:
        voters_reg.document(voter_id).delete()
        return jsonify({'Message':'Deleted Successfully'})
    return jsonify({'error': 'student not found'}), 404
    
        

#@app.route('/election', methods=['POST'])
def create_election():
    election_info = request.get_json()
    election_reg = db.collection('election')
    election_name = election_info['election_name']
    election = election_reg.document(election_name).get()
    if election.exists:
        return jsonify({'error': 'Election already exists'}), 409
    election_reg.document(election_name).set(election_info)
    return election_info, 201



#@app.route('/election', methods=['GET'])
def retrieve_election():
    election_name = request.args.get('election_name')
    election_reg = db.collection('election')
    election = election_reg.document(election_name).get()
    if election.exists:
        return jsonify(election.to_dict())
    return jsonify({'error': 'Election not found'}), 404

    
   

#@app.route('/election', methods=['DELETE'])
def delete_election():
    election_name=request.args.get('election_name')
    election_reg = db.collection('election')
    election=election_reg.document(election_name).get()
    if election.exists:
        election_reg.document(election_name).delete()
        return jsonify({'Message':'Deleted Successfully'})
    return jsonify({'error': 'Election not found'}), 404


#@app.route('/election', methods=['PUT'])
def vote():
    voting_info = request.get_json()
    voter_id = voting_info['voter_id']
    voters_reg = db.collection('Ashesi_Voters')
    election_reg = db.collection('election')
    election_name= voting_info['election_name']
    voter = voters_reg.document(voter_id).get()
    election=election_reg.document(election_name).get()
    if election.exists:
        if voter.exists:
            candidates_and_votes = election.to_dict()['candidates_and_votes']
            candidates_and_votes[voting_info['candidate']] += 1
            election_reg.document(election_name).update({'candidates_and_votes': candidates_and_votes})
            return election.to_dict()
        return jsonify({'error': 'Voter does not exist'}), 404
    return jsonify({'error': 'Election does not exist'}), 404
    







