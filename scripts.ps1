docker build -t blog-greenwolf-app:latest .

docker run -d -p 8080:8080 --name blog-greenwolf-app blog-greenwolf-app:latest

az login 

# Create a resource group for the container app
az group create --name containerappslab03 --location eastus

# Create Container Registry
az acr create --resource-group containerappslab03 --name bloggreenwolfacr --sku Basic

# Log in to the ACR
az acr login --name bloggreenwolfacr

# Tag the image with the ACR login server name
docker tag blog-greenwolf-app:latest bloggreenwolfacr.azurecr.io/blog-greenwolf-app:latest

# Push the image to the ACR
docker push bloggreenwolfacr.azurecr.io/blog-greenwolf-app:latest

# Container ID = bloggreenwolfacr.azurecr.io/blog-greenwolf-app:latest
# User = bloggreenwolfacr
# Password = [password from ACR]

# Create environment container app
az containerapp env create --name blog-greenwolf-env --resource-group containerappslab03 --location eastus

# Create the container app
az containerapp create --name blog-greenwolf-app --resource-group containerappslab03 --environment blog-greenwolf-env --image bloggreenwolfacr.azurecr.io/blog-greenwolf-app:latest --target-port 80 --ingress 'external' --cpu 0.5 --memory 1.0Gi --min-replicas 1 --max-replicas 3 --registry-username bloggreenwolfacr --registry-server bloggreenwolfacr.azurecr.io --registry-password [Password from ACR Login] --revision-suffix greenwolf