# TF

The main.tf script works and deploys the ressources without errors.

(Script commited on git commit d19ec74f4d955822d1022b8d5e78fec704c8a2c0)


1. After this script has successfull run, please use the upload script for the files sho


az ad sp create-for-rbac \
  --name margies-terraform-ci \
  --role Contributor \
  --scopes /subscriptions/ed303178-6b93-47ba-a666-b5ff8724fba0 \
  --sdk-auth