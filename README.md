# DevOps Assignment - Atlys

## Implementation Description
   The frontend written in html has been hosted as a static website on a GCS bucket, while the backend is a Flask API which is running in a VM instance. The API connects to a MySQL DB hosted in a cloud sql instance in the Google Cloud project.

## Setup

1. **Repository:**
    This repository contains the frontend html file and the backend Flask file in the **app-scripts** folder. The infrastructure code is written in Terraform and stored in the folder **tf-scripts**.

2. **Infrastructure Setup:**
    - The terraform scripts are written to get the infrastructure up and running including VM, VPC, subnet, firewall rules, cloud sql instance, DB and GCS bucket.
    ```bash
    cd infrastructure
    terraform init
    terraform plan
    terraform apply -auto-approve
    ```
    - Some future improvements can be added where automation scripts can be written for VM startup, SQL setup and configuration automation using Asible scripts.

3. **Database Configuration:**
    - Connected to the Cloud SQL instance and ran the following SQL command to create the users table:
    ```sql
    CREATE TABLE users (
        id INT AUTO_INCREMENT PRIMARY KEY,
        name VARCHAR(100),
        email VARCHAR(100)
    );
    ```
    - A persistent issue occurred here where the ROOT privileges were getting deleted on SQL Instance creating thus resulting in connection issues with the backend. This was resolved by debugging the user issues, and granting the required privileges.
    

4. **Backend Deployment:**
    - Navigated to the backend directory and deploy the Flask application. The API consisits of three endpoints, **GET**, **POST** and **DELETE**, which are respectively used for **fetching the user details**, **inserting new user details** and **deleting any existing users**.
    - Initially faced issues in connnectivity due to port issues which were resolved with updates to the firewall rules and adding a self-signed certificate. This certificate flags for some browsers as insecure, one of the future updates can be to point a Domain to the server or setup a load balancer which has a DNS configured.

5. **Frontend Deployment:**
    - Built the frontend application and uploaded the static files to the Cloud Storage bucket. After updating the authenticated user permissions, it can be accessed via the public URL by any IP.
    - Some issues were present here as the GCS URL was HTTPS, thus adding a self-signed certificate to the backend resolved this.

6. **Access the Application:**
    - Visit the provided URLs to access your frontend and backend APIs.
    - flask_backend_ip = "34.89.141.149"
    - Click on this link https://34.89.141.149:8443/users and on warning page click **Advanced** to bypass the warning.
    - frontend_url = "https://storage.googleapis.com/frontend-bucket-atlys-assignment-439100/index.html" (The browser may throw an insecure site popup due to the self signed certificate, this can also be improved upon by adding a DNS in future improvements.)

