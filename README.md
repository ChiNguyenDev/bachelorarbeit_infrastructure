# bachelorthesis_infrastructure

I used this for my bachelor thesis with the title  
**"Hybrid cloud architectures: Scalability analysis of Microsoft Azure VPN gateways"**  

## How to Use  

1. Create a service principal in your Azure tenant and a `.tfvars` file with these credentials:  

    ```
    client_id       = "<your_client_id>"
    client_secret   = "<your_client_secret>"
    tenant_id       = "<your_tenant_id>"
    subscription_id = "<your_subscription_id>"
    ```

2. Make sure your current CLI session is authorized to Azure.  
3. Create an SSH key pair and place the `.pub` file in `modules/vm`.  
4. Change specific configurations in `config.tfvars` if needed.  
