# Terraform Examples: <span style="color: orange">AWS Glue</span>: <span style="color: green">Pyshell<span/>

An example on deploying a pyshell glue job using terraform

Terraform configuration is divided into 3 parts:
1. **Infrastructure**: Resource and services which are used regardless of code branch, e.g. S3 bucket, execution IAM role, any other persistent resources or services
2. **Deployment**: CodeBuild IAM and Project to deploy a branch or branches. I decided I wanted a separate CodeBuild ROle per branch, otherwise CodeBuild role would belong under infrastructure.
3. **Application**: The Glue Job(s). Created and updated as part of deployment

### Standing up a Glue Job:

A note on backend state: I have included backend_state files for all 3 parts, but infrastructure and state are _commented out_ using `.bak` extension. Simply rename to .tf to use.

The code terraform uses backend state, and uses the same s3 root as scripts and wheels:

`s3://${infrastructure_bucketname}/${deploy_branch}`
- tfstate: `/tfstate`
- scripts: `/scripts`
- wheels: `/wheels`

1. Stand Up Infrastructure
   1. initialize terraform
      ```shell
      cd infrastructure
      terraform init -backend-config="region=us-west-1" -backend-config="bucket=my-tfstate-project-bucket" -backend-config="key=$BRANCH/my-project/infrastructure.tfstate"
      ```
   2. terraform plan to check for errors and review resources to be created
      ```shell
      terraform plan
      ``` 
   3. terraform apply to stand up resources
      ```shell
      terraform apply -auto-approve
      ```
2. Stand Up CodeBuild for a branch (let's pretend we have a branch named `dev-branch`)
   1. initialize terraform
      ```shell
      cd deploy
      terraform init -backend-config="region=us-west-1" -backend-config="bucket=my-tfstate-project-bucket" -backend-config="key=dve-branch/my-project/infrastructure.tfstate"
      ```
   2. terraform plan to check for errors and review resources to be created
      ```shell
      terraform plan -var "branch=dev-branch"
      ```
   3. terraform apply to stand up resources
      ```shell
      terraform apply -auto-approve -var "branch=dev-branch"
      ```
3. Trigger a CodeBuild Build
   
    It is important to understand that Glue Jobs and code are decoupled. Scripts and wheels resides in S3, and a glue job reads that code at runtime.
    The CodeBuild deployment is therefore two-fold: 
    * package and upload the code to S3
    * create or update glue job as necessary

    Only changes to the terraform resources will trigger an update of the glue job (a change to buildspec will have no effect on terraform)  
    The terraform configuration for glue jobs is part of the code, and resides under code/terraform.
   
    Application deployment is managed through a CodeBuild project, which can be launched manually, or triggered by a webhook when changes are `push`ed to the branch

### Tearing down a Glue Job

The process is exactly opposite of standing up

1. Manually Destroy Glue Jobs: 
    I don't have a solution for properly cleaning up the glue job as part of a teardown.

    I currently manually delete the glue jobs created.

2. Tear down the CodeBuild using terraform

    ```shell
    cd deploy
    terraform destroy
    ```
 
3. Tear down the infrastructure using terraform

    ```shell
    cd infrastructure
    terraform destroy
    ```

## Some observations

### Script Does Not Exists

Not always the case: if S3 permissions are not set you will see the same error
  
