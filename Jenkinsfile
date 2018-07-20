#!groovy
@Library('Infrastructure') _

properties([
    parameters([
        string(name: 'ENVIRONMENT', defaultValue: 'dev', description: 'Suffix for resources created'),
        choice(name: 'SUBSCRIPTION', choices: 'nonprod\nprod\nsandbox\nhmctsdemo', description: 'Azure subscriptions available to build in'),
        booleanParam(name: 'PLAN_ONLY', defaultValue: false, description: 'set to true for skipping terraform apply'),
        string(name: 'EXISTING_VNET_RG_NAME', defaultValue: 'core-infra-<env>', description: 'Name of the core-infra-* resouce group for the existing VNET to deploy to. EG. core-infra-sandbox'),
        string(name: 'EXISTING_VNET_NAME', defaultValue: 'core-infra-vnet-<env>', description: 'Name of the existing core-infra-vnet-* VNET to deploy to. EG. core-infra-vnet-sandbox'),
        string(name: 'SOURCE_RANGE', defaultValue: '', description: 'Calculate as ${cidrsubnet("${var.root_address_space}", 6, "${var.netnum}")}. See README.md for more.'),
        string(name: 'NUM_EXISTING_SUBNETS', defaultValue: '4', description: 'Number of existing subnets in this VNET.')
    ])
])

env.TF_VAR_vnet_rg_name = params.EXISTING_VNET_RG_NAME
env.TF_VAR_vnet_name = params.EXISTING_VNET_NAME
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
