from flask import Flask, request
import mysql.connector
import os

app = Flask(__name__)

@app.route('/', methods=['GET', 'POST'])
def index():
    if request.method == 'POST':
        name = request.form['name']
        email = request.form['email']
        phone = request.form['phone']

        # establish database connection
    try:
        conn = mysql.connector.connect(
            user=os.environ.get('MYSQL_USER'),
            password=os.environ.get('MYSQL_PASSWORD'),
            host=os.environ.get('MYSQL_HOST'),
            database=os.environ.get('MYSQL_DATABASE')
        )
        print("Database connection successful")
    except mysql.connector.Error as e:
        print(f"Error connecting to database: {e}")
        return "Error: Could not connect to database"

    # create table if not exists
    try:
        cursor = conn.cursor()
        cursor.execute(
            "CREATE TABLE IF NOT EXISTS contacts (id INT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(255), email VARCHAR(255), phone VARCHAR(255))"
        )
        print("Table created successfully")
    except mysql.connector.Error as e:
        print(f"Error creating table: {e}")
        return "Error: Could not create table"

    # insert data into table
    try:
        cursor = conn.cursor()
        cursor.execute(
            "INSERT INTO contacts (name, email, phone) VALUES (%s, %s, %s)", (name, email, phone))
        conn.commit()
        print("Data inserted successfully")
    except mysql.connector.Error as e:
        print(f"Error inserting data: {e}")
        return "Error: Could not insert data"

        # Close the database connection
        conn.close()

        return 'Contact information saved'

    else:
        return '''
            <form method="post">
                <label for="name">Name:</label>
                <input type="text" id="name" name="name" required><br><br>
                <label for="email">Email:</label>
                <input type="email" id="email" name="email" required><br><br>
                <label for="phone">Phone:</label>
                <input type="tel" id="phone" name="phone" required><br><br>
                <input type="submit" value="Submit">
            </form>
        '''


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080, debug=True)