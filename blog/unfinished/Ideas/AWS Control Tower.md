
Walk me through creating a centralized git project that is used to deploy AWS control tower along with current and future accounts using terraform. Each control tower managed account should be configured from a simple 

I'm going to be migrating several disparate aws accounts from the same company  into a new aws control tower deployment. I'll have between 5 and 20 accounts to start with different owners and configurations. I'd like to do this all via infrastructure as code, specifically terraform. I'd like you to give me an inventory of terraform modules I might need to accomplish this task effectively.

Additionally, please create a powershell script that can automate the creation of a read-only auditing account for an entire AWS account.