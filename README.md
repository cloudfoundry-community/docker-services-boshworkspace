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

Change and target the `deployments/docker-aws-vpc.yml` to deploy it into a VPC.

By default, it assumes you are deploying into a `10.10.5.0/24` subnet. This is an optimization for users of [terraform-aws-cf-install](https://github.com/cloudfoundry-community/terraform-aws-cf-install) which creates this subnet for us.

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
