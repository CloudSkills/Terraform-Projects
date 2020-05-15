## Module 1: Terraform on Azure: The Big Picture

Benefits of IaC, we gain the following abilities for ALL infrastructure components in code without having to rely on the vendor to "enhance" their product with these features:
- **Transparency** - Living documentation of environment
- **Copy Paste Infrastructure** - Reproducible infrastructure with a copy and paste.
- **Testing** - Infrastructure that is in code can now be tested like software code. 
- **Infrastructure Versioning** - Can now version our code in source control like an application.
- **Change Auditing** - ANY change made to infrastructure is tracked and logged.
- **Rollback** - We can now roll back to a previous version of any infrastructure defined in code.


What happens when we use Infrastructure as Code in a team setting?

- **Removes Specialty In Provisioning** - If deploying a SQL server is automated, we no longer need an engineer specialized in SQL to deploy it every time. This task can be handed to other teams, freeing up time.
-**Consistency**- Automated deployments of infrastructure enforce infrastructure to always be deployed with the same configuration, reducing time spent on troubleshooting due to one off configurations.
-**Visibility** - Teams can see each others infrastructure code in one place. No longer need access to the network or security team's equipment to see how something is configured. Just look at their Read-Only access code.