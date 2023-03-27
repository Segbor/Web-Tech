# from https://pythonbasics.org/flask-rest-api/  

import json
from flask import Flask, request, jsonify

app = Flask(__name__)

@app.route('/voter', methods=['GET'])
def retrieve_records():
    student_record = json.loads(request.data)
    with open('./tmp/data.txt', 'r') as f:
        data = f.read()
        records = json.loads(data)
        for record in records:
            if  record['name']== student_record['name'] :
                return jsonify(record)
        return jsonify({'error': 'student not found'}), 404

@app.route('/voter', methods=['POST'])
def register_student():
    student_record = json.loads(request.data)
    with open('./tmp/data.txt', 'r') as f:
        data = f.read()
    if not data:
        records = [student_record]
    else:
        records = json.loads(data)
        voter_ids = [record['voter_id'] for record in records]
        if student_record['voter_id'] in voter_ids:
            error_message = "Error: student with ID " + student_record['voter_id'] + " is already registered."
            return jsonify({"error": error_message}), 400
        else:
            records.append(student_record)
    with open('./tmp/data.txt', 'w') as f:
        f.write(json.dumps(records, indent=2))
    return jsonify(student_record)


@app.route('/voter', methods=['PUT'])
def update_voter():
    student_record = json.loads(request.data)
    new_records = []
    with open('./tmp/data.txt', 'r') as f:
        data = f.read()
        records = json.loads(data)
    for r in records:
        if r['voter_id'] == student_record['voter_id']:
            r['yeargroup'] = student_record['yeargroup']
            r['major'] = student_record['major']
        new_records.append(r)
    with open('./tmp/data.txt', 'w') as f:
        f.write(json.dumps(new_records, indent=2))
    return jsonify(new_records)
    
@app.route('/voter', methods=['DELETE'])
def deregister_student():
    student_record = json.loads(request.data)
    new_records = []
    with open('./tmp/data.txt', 'r') as f:
        data = f.read()
        records = json.loads(data)
        for r in records:
            if r['voter_id'] == student_record['voter_id']:
                continue
            new_records.append(r)
    with open('./tmp/data.txt', 'w') as f:
        f.write(json.dumps(new_records, indent=2))
    return jsonify(student_record)




@app.route('/election', methods=['POST'])
def create_election():
    election_info=json.loads(request.data)
    with open('./tmp/election_data.txt', 'r') as f:
        data = f.read()
    if not data:
        records = [election_info]
    else:
         records = json.loads(data)
         records.append(election_info)
    with open('./tmp/election_data.txt', 'w') as f:
        f.write(json.dumps(records, indent=2))
    return jsonify(election_info)

@app.route('/election', methods=['GET'])
def retrieve_election():
    election_info = json.loads(request.data)
    with open('./tmp/election_data.txt', 'r') as f:
        data = f.read()
        records = json.loads(data)
        for record in records:
            if  record['election_name']== election_info['election_name'] :
                return jsonify(record)
        return jsonify({'error': 'Election not found'}), 404


@app.route('/election', methods=['DELETE'])
def delete_election():
    election_info = json.loads(request.data)
    new_records = []
    with open('./tmp/election_data.txt', 'r') as f:
        data = f.read()
        records = json.loads(data)
        for r in records:
            if r['election_name'] == election_info['election_name']:
                continue
            new_records.append(r)
    with open('./tmp/election_data.txt', 'w') as f:
        f.write(json.dumps(new_records, indent=2))
    return jsonify(election_info)



@app.route('/election', methods=['PUT'])
def vote():
    voting_info = json.loads(request.data)
    new_records = []
    with open('./tmp/data.txt', 'r') as g:
        data = g.read()
        student_records = json.loads(data)
        for record in student_records:
            #check whether voter is registered
            if voting_info['voter_id'] == record['voter_id']:
                with open('./tmp/election_data.txt', 'r') as f:
                    data = f.read()
                    records = json.loads(data)
                for r in records:
                    #check election name and increment candidate's vote by 1
                    if r['election_name'] == voting_info['election_name']:
                        r['candidates_and_votes'][voting_info['candidate']] +=1   
                    new_records.append(r)
                with open('./tmp/election_data.txt', 'w') as f:
                    f.write(json.dumps(new_records, indent=2))
                return jsonify(new_records)
            return jsonify({'error': 'Voter does not exist'}), 404
        



app.run(debug=True)