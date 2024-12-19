# gcp-project

Here’s a step-by-step tutorial to **Build Serverless Applications using Cloud Functions and Cloud Run**. 

---

### **1. Prerequisites**
- **Google Cloud Platform (GCP) Account**.
- Install **gcloud CLI**.
- Enable necessary APIs:
- navigate to set up folder
  ```
sudo ./install.sh
sudo ./google-cloud-sdk/bin/gcloud init
sudo ./google-cloud-sdk/bin/gcloud auth login
sudo ./google-cloud-sdk/bin/gcloud services enable cloudfunctions.googleapis.com run.googleapis.com
  ```
- A basic understanding of Python/Node.js.

---

### **2. Setting Up the Environment**
- Authenticate your Google Cloud CLI:
  ```bash
  gcloud auth login
  ```
- Set your desired project:
  ```bash
  gcloud config set project [PROJECT_ID]
  ```
- Define a region for deployment:
  ```bash
  gcloud config set run/region [REGION]
  ```

---

### **3. Cloud Functions**
Cloud Functions execute in response to events. 

#### **Step 1: Create a Cloud Function**
- **Example: Hello World with HTTP Trigger (Python)**

1. Create a file `main.py`:
   ```python
   def hello_world(request):
       return "Hello, Serverless World!", 200
   ```

2. Create a `requirements.txt`:
   ```
   Flask==2.0.3
   functions-framework==3.0.0
   ```

3. Deploy the function:
   ```bash
   gcloud functions deploy hello_world \
       --runtime python311 \
       --trigger-http \
       --allow-unauthenticated
   ```

4. Test the function:
   ```bash
   curl $(gcloud functions describe hello_world --format 'value(httpsTrigger.url)')
   ```

---

### **4. Cloud Run**
Cloud Run allows you to deploy containerized applications.

#### **Step 1: Create a Simple Application**
- **Example: Flask App**

1. Create a file `app.py`:
   ```python
   from flask import Flask

   app = Flask(__name__)

   @app.route("/")
   def hello():
       return "Hello from Cloud Run!", 200
   ```

2. Create a `Dockerfile`:
   ```dockerfile
   # Use Python image
   FROM python:3.11-slim

   # Set working directory
   WORKDIR /app

   # Install dependencies
   COPY requirements.txt .
   RUN pip install -r requirements.txt

   # Copy application
   COPY app.py .

   # Expose the port Flask uses
   EXPOSE 8080

   # Command to run the app
   CMD ["python", "app.py"]
   ```

3. Create a `requirements.txt`:
   ```
   Flask==2.0.3
   ```

#### **Step 2: Build and Push the Container**
1. Build the container image:
   ```bash
   gcloud builds submit --tag gcr.io/[PROJECT_ID]/hello-cloud-run
   ```

2. Deploy the container on Cloud Run:
   ```bash
   gcloud run deploy hello-cloud-run \
       --image gcr.io/[PROJECT_ID]/hello-cloud-run \
       --platform managed \
       --allow-unauthenticated
   ```

3. Test the Cloud Run service:
   ```bash
   curl $(gcloud run services describe hello-cloud-run --format 'value(status.url)')
   ```

---

### **5. Use Cases**
- **Cloud Functions**: Ideal for event-driven tasks like file uploads, database triggers, or pub/sub events.
- **Cloud Run**: Perfect for stateless APIs, microservices, or batch jobs.

---

### **6. Clean Up**
To avoid unwanted costs, clean up the resources:
```bash
gcloud functions delete hello_world
gcloud run services delete hello-cloud-run
```

---

### **Code Repo Example**
Consider hosting the above code on GitHub and linking it to a CI/CD pipeline using **Cloud Build** or **GitHub Actions** for automatic deployment.

Would you like help with automating the deployment pipeline or adding advanced features like logging and monitoring?
