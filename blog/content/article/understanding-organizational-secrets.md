---
title: Understanding Organizational Secrets
author: Zachary Loeber
date: 2025-03-03
categories:
  - security
  - blog
tags:
  - automation
  - Kubernetes
  - YAML
  - blog
  - encryption
  - credentials
  - secrets
featuredImage: ./images/banners/banner-innovation-1-750x250.jpg
Permalink: /blog/2025/03/03/understanding_organizational_secrets/
draft: false
toc: true
---

Let's face it, IT often struggles with secrets management. From API keys that need to be registered/rotated, certificates that need to be requested/renewed, LDAP/AD credentials that need to be maintained, password complexity requirements to be enforced, and more. It can be cognitively difficult to manage the various secrets for a single project let alone an entire organization. This discussion will help define the credential categories and the tools used to manage them.

<!--more-->

It helps to understand the kinds of credentials we deal with in IT before we suss out tangible things we can do to better manage them. We can distill secrets into two base types, the static and the dynamic secret. I also believe it is important to understand the 'managed credential' secret type so we will define it as well.

## Static Secrets

These are provided by the system being accessed via some manual or even an automated process. Static secrets can be used at anytime by anyone that has the secret. Static secrets are often subject to rotation policies which make them seem semi-automated in some environments. Static secrets can and should be stored in external secret stores for additional security.

### Characteristics

- Often manually requested/handled
- Often remain valid until manually updated or revoked
- Typically used for long-term access or encryption

### Examples

- basic web passwords (htaccess)
- user passwords
- encryption keys
- root/self-signed certificates

### Advantages

- Simpler to implement and manage
- Suitable for long-term access or encryption

### Disadvantages

- Increased risk of compromised credentials due to manual handling
- Increased effort to secure and monitor
- Can be used by anyone that has access to the secret (no identity repudiation)
- Often difficult to rotate or update
- May not meet security regulations or compliance requirements

These are provided by the system being accessed via some manual or even an automated process and can be used anytime thereafter by any identity that owns the secret. Static secrets are often subject to rotation policies which make them seem semi-automated.

Static secrets are often found stored in:

- Vault KV
- CICD Pipeline variables
- Azure Vault
- AWS SSM
- Local .env files (developers/nodejs)
- Kubernetes secrets
- Post-it notes on a desk
- In safes (KeePass, BitWarden, physical, et cetera)

These secrets can be used 'as is' by anyone or anything that has access to it and knows where it should used.  In a corporation static secrets are subject to sprawl, introduce immediate technical debt, and are a pain to manage in general. I highly recommend minimizing the use of these as much as possible.

## Dynamic Secrets

On the opposite end of the scale from static secrets that might live forever and have no allegiance to anyone there are dynamic secrets. These time and identity bound secrets are also known as "just in time" or ephemeral secrets. They are dynamically requested before they are used and invalidated at some point automatically afterwards.

> **NOTE**: A token generation service that uses TOTP with truly random number generation and frequent enough rotation may seem to be dynamic but it is not! These are actually predetermined via an already generated/shared secret at registration time back to a database. These tokens are just high-frequency rotated static secrets as they are not generated on-demand.

In a world of unicorns and rainbows secrets would always be dynamic.

### Examples
- JWT tokens (GitLab/GitHub pipelines/actions create them for example)
- OAuth tokens (app)
- Refresh tokens (often seen with OIDC, with longer expiry times)
- HashiCorp Vault access tokens
- HashiCorp Vault generated AWS STS credentials (advanced but way cool way of delegating ephemeral rights to access AWS infrastructure)
- HashCorp Vault LDAP secret engine's 'dynamic' accounts (create/remove/rotate accounts on demand)
- HashiCorp Vault Database secret engine's roles (create/remove database roles on demand)
- Kerberos Tickets (AD auth)
- PKI signed certificates

### Characteristics

- Just in time access
- Typically short lifespan (usually no more than a day but can be longer)
- Time or usage bound
- Reduced surface area for secret sprawl/leakage
- Usually bound by some identifier (dns address, et cetera)

### Advantages

These are the golden standard of what we should attempt to achieve with all of our secrets. But it simply is not always possible nor even desirable to choke down the overhead and complexities involved in getting them working. Dynamic secrets tend to be propped up by some kind of static secret that need to still be managed (see next section). For instance, you still need a credential to login to an AD domain that then handles Kerberos ticketing behind the scenes (in your local network and only on supported systems!).

> **NOTE**: Technically certificate authorities generate dynamic secrets even if many of them sign secrets for years of validity like for signing CAs for instance. Certificates themselves are created by the owner and are only signed for validity by the upstream authority. Certificate protocols like ACME or automated PKI solutions found in HashiCorp Vault can be made into a fully dynamic secrets engines if you shorten the certificate lifespans significantly. Just beware that the cost for this is increased crl/oscp churn, size, and traffic.

In a serendipitous coincidence, LetsEncrypt is exploring reducing certificates to allow for 6 day validity periods.

### Disadvantages

- Difficult to grok
- Often difficult to configure/setup properly

## Managed Secrets

Somewhere in between static and dynamic secrets are managed secrets. These tend to take the form of wrapping ordinary credentials with superpowers.

### Characteristics
- Secrets are often managed outside of their system of origin
- Adds features or automated management for static secrets
- Can manage the interactive usage of secrets
- Great for long running service accounts
- Can add;
    - Dual access or approval rules on usage
    - Check-in/Check-out processes
    - Automatic credential rotation
      - on a schedule
      - on use
    - Session recording
    - More

### Examples

- HashiCorp Vault can manage LDAP accounts
  - Can be 'static' accounts wherein the credentials are rotated automatically on a schedule.
  - Can be libraries of accounts that are checked in and out as needed wherein the account credentials are rotated.
  - Can be dynamic accounts that are created when needed, deleted when TTL has expired (This is actually fully dynamic!)
- CyberArk is the 800lb gorilla in this space targeted squarely at the interactive use of secrets of all kinds.
  - Can vault and manage AD then have the credentials automatically rotated any number of ways with outside approval groups and a deep slew of options.
  - Has portals for recording sessions with proxied access to rdp endpoints and more.
- Azure itself has managed identities that can be configured.
- Azure Key Vault can automatically rotate credentials for certain types of secrets, such as:
  - Service Principal Credentials: Key Vault can automatically rotate credentials for service principals (e.g., Azure AD applications) by updating the client secret.
  - Certificate Credentials: Key Vault can automatically rotate certificates (e.g., SSL/TLS certificates) by renewing them before they expire.
  - SQL Connection Strings: Key Vault can automatically rotate SQL connection strings by updating the password.
- Active Directory LAPs for workstation local administrative rights

### Advantages

- Can simplify the long-term management of some credential types
- Additional features/security/metrics/auditing around secrets consumption available
- Can help meet some compliance requirements for privilege access management

### Disadvantages

- Additional complexity in some cases
- Additional infrastructure in some cases
- Can be more effort to automate credential usage in some cases
- Seamless use often requires additional initial considerations

Managed secrets are often necessary to wrangle things like service or local account credentials in an organization and add an additional approval layer to accessing them. Shared accounts can thus be given a layer of identity access control over an inherently bad practice of sharing credentials. If you are able to meet all your requirements using the default management tools in your secret source of origin that would be preferred. Otherwise you may need to pursue using CyberArk or HashiCorp Vault in your organization to manage some of them for you.

> **CyberArk or HashiCorp Vault?** CyberArk is a Windows platform driven solution that is ideal for the interactive user accessing a shared credential or that needs further approval to access one. It has the concept of safes that credentials can go in which can then tie into a number of providers for deeper management such as credential rotation or reconciliation. HashiCorp Vault is a purely REST API driven service that lends itself well for machine or automated usage of credentials. Vault does have a UI and can often meet lesser requirements for the interactive use case as well. Which on you choose should become readily apparent as you dig further into their respective feature sets and costs.

# Conclusion

Hopefully you are doing your best to keep your secrets secured from prying eyes, rotated frequently, and possibly even managed. Steering your organization towards more dynamic secrets will reap rewards despite their additional overhead. Where ever you are unable to be fully dynamic, then settle on managed secrets. If you don't know where to start then ask where the manual handling of secrets are occurring within your organization and see where that trail leads you.