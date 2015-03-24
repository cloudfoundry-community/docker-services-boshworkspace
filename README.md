docker-services-boshworkspace
=============================

The fastest way to deploy [Docker Services](https://github.com/cf-platform-eng/docker-boshrelease) in combination with [Cloud Foundry](http://www.cloudfoundry.org) onto [bosh-lite](https://github.com/cloudfoundry/bosh-lite).

### Preparation

To get started you will need a running bosh-lite. Get yours by following the instructions [here](https://github.com/cloudfoundry/bosh-lite#install-bosh-lite)

Next step is setting up this repository

```
git clone https://github.com/cloudfoundry-community/docker-services-boshworkspace.git
cd docker-services-boshworkspace
bundle install
```

### Deploy Cloud Foundry

With all prerequisites in place let deploy Cloud Foundry.

```
bosh deployment cf-warden
bosh prepare deployment
bosh deploy
```

### Deploy Docker Services

```
bosh deployment docker-warden
bosh prepare deployment
bosh deploy
cf create-service-broker docker containers containers http://cf-containers-broker.10.244.0.34.xip.io
# List services
cf service-access
cf enable-service-access <service_name>
```

### Deploy on AWS VPC

Assuming you used [terraform-aws-cf-install](https://github.com/cloudfoundry-community/terraform-aws-cf-install), ssh onto the Bastion server and run:
```
cd ~/workspace/deployments
git clone https://github.com/cloudfoundry-community/docker-services-boshworkspace.git
cd docker-services-boshworkspace
```

There is a helper script in `shell/populate-docker-aws-vpc` which will extract information from the cf-boshworkspace deployment on the bastion server and populate the variables in `deployments/docker-aws-vpc.yml`, a copy of the original file will be left in `deployments/docker-aws-vpc.yml.orig`.  Run the following on the bastion server:
```
cd ~/workspace/deployments/docker-services-boshworkspace/shell
./populate-docker-aws-vpc
```

You will still need to modify the SUBNET_ID in `deployments/docker-aws-vpc.yml`.  In AWS Console navigate to VPC > Subnets and select a subnet named "docker", the subnet id will be in the format "subnet-xxxxxxxx" and replace the value SUBNET_ID in the file

Your deployment manifest is now populated, launch the deployment from the bastion server:
```
cd ~/workspace/deployments/docker-services-boshworkspace
bosh deployment docker-aws-vpc
bosh prepare deployment
bosh -n deploy
```

By default, it assumes you are deploying into a `10.10.5.0/24` subnet. This is an optimization for users of [terraform-aws-cf-install](https://github.com/cloudfoundry-community/terraform-aws-cf-install) which creates this subnet for us.

#### Alternate Network Configurations
If you want to deploy into another subnet CIDR, then add a `meta.subnets` to your deployment file to look something like:

```yaml
meta:
  subnets:
  - range: 10.10.5.0/24
  name: default_unused
  reserved:
    - 10.10.5.2 - 10.10.5.9
    static:
      - 10.10.5.10 - 10.10.5.250
      gateway: 10.10.5.1
      dns:
        - 10.10.0.2
        cloud_properties:
          security_groups: (( meta.security_groups ))
          subnet: (( meta.subnet_ids.docker ))
```
