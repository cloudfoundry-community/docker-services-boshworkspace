docker-services-boshworkspace
=======================
The fastest way to deploy [Docker Services](https://github.com/cf-platform-eng/docker-boshrelease) in combination with [Cloud Foundry](http://www.cloudfoundry.org) onto [bosh-lite](https://github.com/cloudfoundry/bosh-lite).

### Preparation
To get started you will need a running bosh-lite.
Get yours by following the instructions [here](https://github.com/cloudfoundry/bosh-lite#install-bosh-lite)

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
bosh prepare deploÂyment
bosh deploy
cf create-service-broker docker containers containers http://cf-containers-broker.10.244.0.34.xip.io
# List services
cf service-access
cf enable-service-access <service_name>
```

### Deploy on AWS VPC

Please note that subnet_id, nats, and director uuid id need to be changed in deployments/docker-aws-vpc.yml

Subnet need to be changed accordingly in templates/docker-aws-vpc.yml
