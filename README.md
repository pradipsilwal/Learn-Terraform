# :rocket: :terraform: Learn Terraform :terraform: :rocket:	

```
:information_source: :rocket: NOTE TO READER: If you feel something could be better, wrritten more clearly please feel free to PR. ALl the approriate changes are accepted.
```

## Getting started
This documentation aims to help use get start with terraform on different cloud providers.

## Requirements:
Please install following on your computer before we get started:
1. Python 3.5 or 3.7
2. Install google cloud sdk 
3. Install terraform

## Firstly
1. Make sure your python is installed and running 
Use: <code>python -v</code>

2. Make sure gcloud is installed and running
Use: <code>gcloud -v</code>

3. Make sure terraform is installed and running
Use : <code>terraform --help</code>

4. (Optional) Install terraform autocomplete
Use : <code>terraform -install-autocomplete</code>

## Secondly

### For GCP users
Before you start make sure you already have signed up for google cloud service.

#### gcloud CLI login
1. Login into GCP using command <code>gcloud auth application-default login</code>. This will open browser asking which account you want to use.
2. Provide google auth library to access google account.

#### gcloud CLI project list
1. Check projects associated with given account using <code>gcloud projects list</code>
2. There might be default project created automatically.

#### gcloud Service account
1. Create gcloud service account using command <code>gcloud iam service-accounts create terraform-admin --display-name "Terraform Gcloud"</code>
2. verify the service account using command <code>gcloud iam service-accounts list</code>
3. Download service account key using command <code>gcloud iam service-accounts keys create ~/terraform-admin.json --iam-account SERVICE_ACCOUNT_EMAIL</code>
4. Go to gcp console > IAM > service accounts to verify id your service account has been created or not.

#### Set project and service account to use
1. You can list projects using <code>gcloud projects list</code>
2. Select which project to use using command <code>gcloud config set project project ID</code>

#### Associate role to the service account
1. In order for service account to make changes to google cloud console, we need to add role. Let's try to give editor role to service account.Use this command to provide editor role to service account created above.
<code>gcloud projects add-iam-policy-binding PROJECT ID --member "serviceAccount:SERVICE ACCOUNT EMAIL" --role "roles/editor"</code>
2. Now, go and verify in google cloud console to see if service account as been associated with IAM role.

#### Activate service account
1. Active service account created above using command <code>gcloud auth activate-service-account SERVICE_ACCOUNT_EMAIL --key-file=PATH_TO_SERVICE_ACCOUNT_KEY DOWNLOADED</code>
2. We will be using this service account to interact with GCP console

## Now, Let's do some Terraforming ...
[Getting Started](https://github.com/pgaijin66/Learn-Terraform/blob/master/getting-started/README.md)