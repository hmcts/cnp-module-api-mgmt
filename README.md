# moj-module-api-mgmt

A module that lets you create an Azure API Management Instance. Applying this module will create a new subnet in the core infra vnet and then deploy the API Management instance within it.

## SOURCE_RANGE

The value for the source range can be calculate but when running this module separately you need to provide the value as a parameter. Here are the current set of vaules based on the netnums for the various environments.

```
Sandbox: cidrsubnet("10.96.0.0/12", 6, "18") = 10.100.128.0/18
SAAT: cidrsubnet("10.96.0.0/12", 6, "17") = 10.100.64.0/18
Sprod: cidrsubnet("10.96.0.0/12", 6, "16" = 10.100.0.0/18

Demo: cidrsubnet("10.96.0.0/12", 6, "3") = 10.96.192.0/18
AAT: cidrsubnet("10.96.0.0/12", 6, "2") = 10.96.128.0/18
Prod: cidrsubnet("10.96.0.0/12", 6, "1") = 10.96.64.0/18
```
