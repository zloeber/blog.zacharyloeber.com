I've recently been provided a digital copy of "[Platform Engineering on Kubernetes](https://www.manning.com/books/platform-engineering-on-kubernetes)" for an honest review. This is my review in full.

Platform engineering is the art of giving developers and non-developers the tools to be self sufficient, secure, and productive in their use of organization sanctioned platforms. Platform engineering strives for sane and secure defaults by eating the complexity for average consumers of the platforms being used. This is all done in an effort to harness the powers of modern developers and tech savvy business users for the purpose of adding value to the business and reducing technical debt.

Platform engineering is the positive and forward thinking response to what was previously known as "Shadow IT". Shadow IT was often seen as the enemy of sysadmin's that needed to know the workloads running on their networks in order to support them. These workloads often had a malignant growth quality to them, especially if they became cornerstones of business operations. How many Microsoft Access databases have been the black box of value for HR, Accounting, or other departments to the horror of IT staff and business leaders? As such, many shadow IT efforts have been squashed over the years. This is sad as the efforts themselves were born from real needs and often had the markings of a very powerful force, innovation.

As our workforce became more and more technically savvy, it soon became unreasonable and obstinate to attempt to stifle employee innovation. Couple this with the explosion of cloud native workloads and infrastructure as code and you have a recipe for a new kind of employee driven energy. Embracing and harnessing this energy via platform engineering can help ensure secure and compliant workloads are deployed with appropriate IT life cycles.

Kubernetes is a very capable platform with many ways to be used so writing a whole book on platform engineering for it is quite an endeavor. I found that the author did quite well in encapsulating a large amount of information in a relatively small book.

# Review

The author gets right to defining platform engineering around page 16 and gives a succinct definition: "Platform teams take the work done by developers safely to production."

The author then uses a simple but apropos "walking skeleton" example application of a conference organization application that is used throughout the book. This is the kind of application that you'd see being used for HashiConf.

There is a short overview of the pros/cons of various platform options that include local workstation, on premise (bare metal), or cloud managed Kubernetes clusters. Cloud managed clusters are generally recommended but KinD (Kubernetes in Docker) is used as the target testing platform for most examples. There are other options I might have included (k3s, minikube, or docker engine's built in kubernetes cluster) but I don't blame the author for keeping this part light in order to focus on the platform engineering content. By the end of chapter 2 you will have covered most of the basics of hand delivering an application into a Kubernetes cluster without platform engineering. This gives the reader most requisite knowledge for the remainder of the book's contents.

From here the author dives into;

- Service Pipelines
- Environment Pipelines
- Multi-Cloud
- Building a platform
- Challenge: Shared apps
- Challenge: Enabling experimentation
- Measuring Platforms

# Pros

I liked this book quite a bit for the following reasons.

- Strong push for using existing not custom tools in platform engineering solutions.
- I really like that practical examples of how to use platform agnostic tools such as Tekton and Dagger.io are included. Being tethered by a particular DevOps platform is one aspect of my industry that I've come to realize is limiting.
- Covers of a good number of modern tools used in the industry (ArgoCD, Tekton, Github Actions, Crossplane, Dapr, Knative, et cetera) but is careful not to be bound by any of them.
- Author exhibits a good knowledge of the many challenges of platform engineering specific to Kubernetes. Things like service discovery, async, workload isolation, and more have coverage.
- Standard Kubernetes release patterns are covered; A/B, Blue/Green, and Canary.
- GitOps is covered, specifically one of the most popular choices for Kubernetes GitOps deployments was covered quite well, ArgoCD.
- A relatively concise tome of knowledge. Good links to additional information throughout. This means there is not too much recreating the wheel and is appreciated in any technical book. The size of the book is actually a bit misleading as...
- The additional github project for the book is brimming with additional content. It can be a book of its own. I like that the author doesn't just copy and paste his examples into the book as filler. This shows respect for the target audience's technical acumen and saves some trees.
- Crossplane is covered as the preferred Kubernetes way of doing infrastructure as code. I've been dying to really see more of this in action :)

# Cons

A book covering such a broad topic area is never going to be perfect. Here are some areas I found a bit lacking.

- Management of multiple environment deployments in GitOps workflows that span multiple project repos is lacking clear direction. There is mention of "Golden Paths" but how to develop a such a path is missing.
- Secrets management is mentioned a few times (external-secrets and HashiCorp Vault) but not specifically addressed. I find this to be a crucial and often overlooked aspect of a well oiled platform engineering engine for Kubernetes workloads.
- There are no clear examples of how to handle brand new applications in the platform engineering workflow.
- Often a Kubernetes application is only a small part of the numerous applications that comprise the cluster's overall functionality. Certificate manager, HashiCorp Vault, Cloud specific but integrated services like AWS IAM role integration, External DNS, and more are all part of the services that an application may need to integrate with when being deployed to a cluster. Though a whole book could be written on such things, a chapter on how one might setup the actual platform itself would have been a welcome addition for contextual awareness of such things.
- Conspicuously absent from this book is any mention of policy management. Open policy agent and Kyverno don't even have a presence in the index.
- Identity management for how you grant developers rights to deploy into specific environments is not well covered, nor is workload identity management covered (Spiffe/Spire as an abstraction to such things for example)
- The publisher made the odd choice of a non-black font for the majority of the pdf I reviewed. This is normally something I'd look past but it made reading the digital copy of this book a bit of a visual chore.

# Conclusion

When I read a book like this I always ask myself a few questions;

**Question 1:** Did I learn about some new tool or gain a better appreciation about a tool I was already aware of?

**Answer:** Yes! "vcluster" and "Knative Serving" is now on my shortlist of tools to become more familiar with.

**Question 2:** Does the book offer unique insight into my industry that I might not have knowledge of otherwise?

**Answer:** Yes! The author is clearly experienced with delivering Kubernetes workloads and adds his unique perspective and experiences to the table repeatedly throughout the book.

Platform engineering has a bit of a niche audience that the author does a good job catering towards. I am comfortable recommending this book to a mid-level or higher developers or DevOps practitioners looking to better understand some options for streamlining applications into Kubernetes at their organization. The many practical examples provided add good context to the points being made. I believe that this book will help many readers get a better understanding of some of the tools available to them and be a good point of reference for their own efforts. Just beware that this book is not a compendium of all Kubernetes platform engineering knowledge. But it is a very well rounded and good book for most technical professionals' library.