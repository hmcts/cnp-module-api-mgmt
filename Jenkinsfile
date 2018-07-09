#!groovy
@Library('Infrastructure') _

properties([
    parameters([
        string(name: 'ENVIRONMENT', defaultValue: 'dev', description: 'Suffix for resources created'),
        choice(name: 'SUBSCRIPTION', choices: 'nonprod\nprod\nsandbox\nhmctsdemo', description: 'Azure subscriptions available to build in'),
        booleanParam(name: 'PLAN_ONLY', defaultValue: false, description: 'set to true for skipping terraform apply'),
        string(name: 'VNET_RG_NAME', defaultValue: '', description: 'Name of the resouce group for the VNET to deploy to. EG. core-infra-sandbox'),
        string(name: 'VNET_NAME', defaultValue: '', description: 'Name of the VNET to deploy to. EG. core-infra-vnet-sandbox'),
        string(name: 'SOURCE_RANGE', defaultValue: '', description: 'Calculate as ${cidrsubnet("${var.root_address_space}", 6, "${var.netnum}")}'),
        string(name: 'NUM_EXISTING_SUBNETS', defaultValue: '', description: 'Number of existing subnets in this VNET')
    ])
])

env.TF_VAR_vnet_rg_name = params.VNET_RG_NAME
env.TF_VAR_vnet_name = params.VNET_NAME
env.TF_VAR_source_range = params.SOURCE_RANGE
env.TF_VAR_source_range_index = params.NUM_EXISTING_SUBNETS
planOnly = params.PLAN_ONLY

node {
  env.PATH = "$env.PATH:/usr/local/bin"
  def az = { cmd -> return sh(script: "env AZURE_CONFIG_DIR=/opt/jenkins/.azure-$subscription az $cmd", returnStdout: true).trim() }

  stageCheckout('git@github.com:hmcts/moj-module-api-mgmt.git')

  withSubscription(subscription) {
    spinInfra("api-mgmt", params.ENVIRONMENT, planOnly, params.SUBSCRIPTION)
  }
}
