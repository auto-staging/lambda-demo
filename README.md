# Auto Staging Lambda demo

> This demo is intendet to demonstrate the function of Auto Staging in combination with a Lambda Function and an API Gateway

:warning: This repository contains references to a specific AWS account, which was used for testing Auto Staging. Additionally there may be some definitions like domains, which are hardcoded in the Terraform definitions.

## Requirements

- [stagectl](https://github.com/auto-staging/stagectl)
- Working Auto Staging system

## Commands

### Resolve dependencies

``` make
make prepare
```

### Build binary

``` make
make build
```

### Create Auto Staging repository

``` bash
stagectl add repository
```

## Infrastructure

The infrastructure of this lambda-demo includes the following elements.

- API Gateway based on OpenAPI specification
- Lambda function
- DNS entry for the API Gateway
- Build and deployment pipeline
