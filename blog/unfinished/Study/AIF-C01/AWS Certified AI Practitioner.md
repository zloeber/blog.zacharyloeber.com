# Fundamentals

**Artificial Intelligence (AI)**: The broadest field encompassing all aspects of creating machines that can perform tasks that typically require human intelligence.

**Machine Learning (ML)**: A subset of AI focused on algorithms and statistical models that enable machines to improve their performance on tasks through experience.

**Deep Learning (DL)**: A subset of ML that uses neural networks with many layers to learn from large amounts of data, allowing for more complex and abstract representations.

**Generative AI (GenAI)**: A subset of Deep Learning focused on models that can generate new content, such as text, images, or music, by learning from existing data.

**Deterministic Training**  - Approach where the output is predictable. Focuses on the accuracy and the amount of data collected, so efficiency is prioritized over uncertainty

**Non-deterministic (Probabilistic) Training** - Approach designed to manage the chance factor.

**Supervised Learning** - Using labeled data to train systems

**Unsupervised Learning** - Using unlabeled data to train systems

**Self-Supervised Learning** - Models are provided vast amounts of raw, almost entirely, or completely unlabeled data and then generate the labels themselves. Foundation models use self-supervised learning to create labels from input data. In self-supervised learning, models are provided vast amounts of raw completely unlabeled data and then the models generate the labels themselves. This means no one has instructed or trained the model with labeled training data sets.

**Semi-Supervised Learning** -  Apply both supervised and unsupervised learning techniques to a common problem. This technique relies on using a small amount of labeled data and a large amount of unlabeled data to train systems. First, the labeled data is used to partially train the machine learning algorithm. After that, the partially trained algorithm labels the unlabeled data. This process is called pseudo-labeling. The model is then re-trained on the resulting data mix without being explicitly programmed. Examples of this kind of learning are Sentiment Analysis and Fraud Detection

**Multi-class classification** - assigns each instance to one of several possible classes

**Multi-label classification** - assigns each instance to one or more classes

**Convolutional Neural Networks (CNNs)** - A type of deep learning model particularly well-suited for processing grid-like data, such as images. They are designed to automatically and adaptively learn spatial hierarchies of features from input images. 

**Recurrent Neural Networks (RNNs)** - Designed to handle sequential data, where the order of the data points matters. They are particularly well-suited for time-series data and tasks where temporal dependencies are crucial. Well suited to video or audio streams.

**Bias** - Error due to overly simplistic assumptions in the model, leading to underfitting

**Variance** - Error due to the model being too sensitive to small fluctuations in the training data, leading to overfitting.

**Overfitting** - occurs when the model is overly complex and captures noise or random fluctuations in the training data rather than the underlying patterns

# ALGORITHMS

**K-Means** - An unsupervised learning algorithm used to partition a dataset into distinct clusters by minimizing the variance within each cluster. 

**K-Nearest Neighbors (KNN)** - a supervised learning algorithm that classifies new data points based on the majority class among its k-nearest neighbors in the training data.

**Decision Trees** - The decision tree is a supervised machine learning technique that takes some given inputs and applies an if-else structure to predict an outcome. An example of a decision tree problem is predicting customer churn. These are highly interpretable models that provide a clear and straightforward visualization of the decision-making process.

**Sentiment analysis** - This is an example of semi-supervised learning. Semi-supervised learning is when you apply both supervised and unsupervised learning techniques to a common problem. This technique relies on using a small amount of labeled data and a large amount of unlabeled data to train systems. When considering the breadth of an organization’s text-based customer interactions, it may not be cost-effective to categorize or label sentiment across all channels. An organization could train a model on the larger unlabeled portion of data first, and then a sample that has been labeled.

**Logistic Regression** - Logistic Regression is primarily designed for binary classification problems.

**Neural Networks** - a more complex supervised learning technique. To produce a given outcome, it takes some given inputs and performs one or more layers of mathematical transformation based on adjusting data weightings. An example of a neural network technique is predicting a digit from a handwritten image. These are powerful tools for handling large and complex datasets, they are often considered "black-box" models due to their lack of transparency.

**Support Vector Machines (SVMs)** - effective for classification tasks, especially in high-dimensional spaces, they do not inherently provide an interpretable way to understand the decision-making process.

## Embeddding Models

**Bidirectional Encoder Representations from Transformers (BERT)** - specifically designed to capture the contextual meaning of words by looking at both the words that come before and after them (bidirectional context).

**Linear regression** - Linear regression refers to supervised learning models that, based on one or more inputs, predict a value from a continuous scale. An example of linear regression is predicting a house price. You could predict a house’s price based on its location, age, and number of rooms after you train a model on a set of historical sales training data with those variables.

**Neural network** - A neural network solution is a more complex supervised learning technique. To produce a given outcome, it takes some given inputs and performs one or more layers of mathematical transformation based on adjusting data weightings. An example of a neural network technique is predicting a digit from a handwritten image.

**Document classification** - This is an example of semi-supervised learning. Semi-supervised learning is when you apply both supervised and unsupervised learning techniques to a common problem. This technique relies on using a small amount of labeled data and a large amount of unlabeled data to train systems. When applying categories to a large document base, there may be too many documents to physically label. For example, these could be countless reports, transcripts, or specifications. Training on the unlabeled data helps identify similar documents for labeling.

**Association rule learning** - This is an example of unsupervised learning. Association rule learning techniques uncover rule-based relationships between inputs in a dataset. For example, the Apriori algorithm conducts market basket analysis to identify rules like coffee and milk often being purchased together.

**Dimensionality reduction** - An unsupervised learning technique that reduces the number of features in a dataset. It’s often used to preprocess data for other machine learning functions and reduce complexity and overheads. For example, it may blur out or crop background features in an image recognition application.

**Clustering** - Clustering is an unsupervised learning technique that groups certain data inputs, so they may be categorized as a whole. There are various types of clustering algorithms depending on the input data. An example of clustering is identifying different types of network traffic to predict potential security incidents.

**Transfer Learning** - Allows a model to utilize the knowledge learned from one task or dataset to improve its performance on a new, but related task. *For a company using multiple models for different use cases, transfer learning can help optimize performance* by adapting insights from the latest data generated by other models. This approach reduces the need for extensive data and computational resources while ensuring that the models benefit from shared knowledge across related domains or tasks.

**Incremental Training** - an approach that allows models to be updated incrementally with new data without needing a complete retraining from scratch

**Self-Supervised Learning** - a technique where the model learns patterns and representations from unlabeled data without relying on explicit supervision or labeled datasets - Self-supervised learning is effective for tasks where labeled data is scarce or unavailable, as it allows models to learn useful representations from large amounts of unlabeled data. However, it does not directly address the need to optimize multiple models using the latest data from other models. This approach is more suitable for foundational training rather than model optimization across different use cases.

**Reinforcement Learning** - a strategy where an agent learns to make decisions by interacting with an environment and receiving rewards or penalties based on its actions - Reinforcement learning is designed for scenarios where a model needs to learn a sequence of actions to achieve a specific goal by maximizing cumulative rewards. It is primarily used in decision-making problems, such as game playing or robotic control. It is not well-suited for optimizing multiple models by learning from the latest data of other models, as it does not involve leveraging cross-model data or knowledge sharing.
# METRICS

**BLEU** - is one of the most widely used metrics for evaluating machine translation quality. BLEU compares machine-generated translations with one or more human reference translations by analyzing n-gram overlaps. It provides a quantitative measure of translation accuracy, where a higher BLEU score indicates closer alignment with the reference translation. This makes BLEU particularly suited for assessing the performance of translation models. A BLEU score is typically a number between 0–1; it calculates the similarity of the machine translation to the reference human translation. The higher score represents better quality in natural language understanding (NLU).

**ROUGE (Recall-Oriented Understudy for Gisting Evaluation)** - a metric primarily used for evaluating the quality of text summarization and comparing the overlap between predicted and reference summaries - ROUGE is a metric used mainly for evaluating the quality of automatic text summarization by measuring the overlap of n-grams, word sequences, and word pairs between machine-generated and reference summaries. Although it measures some aspects of textual similarity, it is not specifically tailored for translation tasks and does not effectively capture the nuances needed to evaluate translation accuracy.

**Accuracy** - a general metric that measures the proportion of correctly predicted outputs - Accuracy is a broad metric typically used to evaluate classification tasks where the model's output is compared against the correct label. For translation, which involves producing contextually and semantically accurate text rather than simply classifying outputs, accuracy is too simplistic and does not account for the complexities of language, such as syntax and grammar, making it an unsuitable metric for this purpose.

**BERT** score - a metric that leverages contextual embeddings from BERT to evaluate the semantic similarity between machine-generated translations and reference translations - While BERT score is a more advanced metric that uses contextual embeddings to assess the semantic similarity between translated and reference texts, it is less established than BLEU score for evaluating translation tasks. BERT score may provide deeper insights into semantic similarities, but BLEU score remains the standard and most commonly used metric for translation evaluation due to its simplicity and effectiveness in capturing n-gram overlaps, making it the preferred choice.

**Confusion matrix** - a tool specifically designed to evaluate the performance of classification models by displaying the number of true positives, true negatives, false positives, and false negatives. This matrix provides a detailed breakdown of the model's performance across all classes, making it the most suitable choice for evaluating a classification model's accuracy and identifying potential areas for improvement. It provides a comprehensive overview of the model's performance by detailing how many instances were correctly or incorrectly classified in each category. This enables the company to understand where the model is performing well and where it may need adjustments, such as improving the classification of specific material types.

**Root Mean Squared Error (RMSE)** - Root Mean Squared Error (RMSE) is a metric commonly used to measure the average error in regression models by calculating the square root of the average squared differences between predicted and actual values. However, RMSE is not suitable for classification tasks, as it is designed to measure continuous outcomes, not discrete class predictions.

**Mean Absolute Error (MAE)** - Mean Absolute Error (MAE) measures the average magnitude of errors in a set of predictions without considering their direction. MAE is typically used in regression tasks to quantify the accuracy of a continuous variable's predictions, not for classification tasks where the outputs are categorical rather than continuous.

**Correlation matrix** - Correlation matrix measures the statistical correlation between different variables or features in a dataset, typically used to understand the relationships between continuous variables. A correlation matrix is not designed to evaluate the performance of a classification model, as it does not provide any insight into the accuracy or errors of categorical predictions.

**Precision**: Measures the accuracy of the positive predictions, calculated as the ratio of true positives to the sum of true positives and false positives.

**Recall (Sensitivity)**: Measures the ability of the classifier to identify all positive instances, calculated as the ratio of true positives to the sum of true positives and false negatives.

**F1-Score:** The harmonic mean of Precision and Recall, providing a single metric that balances both concerns.

**Throughput, Latency and Uptime** - Throughput, Latency, and Uptime are performance metrics used to measure system performance and reliability, not specific to classification system

# Foundation Models (FMs)

FMs use self-supervised learning to create labels from input data, however, fine-tuning an FM is a supervised learning process

**Continued pre-training** uses `unlabeled` data to pre-train a model, whereas, fine-tuning uses `labeled` data to train a model

# Services

## Bedrock

**Model invocation logging** - You can use model invocation logging to collect invocation logs, model input data, and model output data for all invocations in your AWS account used in Amazon Bedrock.

**Vector Database** - Supports OpenSearch serverless 

**Amazon Q** - Amazon Q is a generative AI–powered assistant for accelerating software development and leveraging companies' internal data.

## Hardware

**AWS Trainium** - AWS Trainium is the machine learning (ML) chip that AWS purpose-built for deep learning (DL) training of 100B+ parameter models. Each Amazon Elastic Compute Cloud (Amazon EC2) Trn1 instance deploys up to 16 Trainium accelerators to deliver a high-performance, low-cost solution for DL training in the cloud.

**AWS Inferentia** - AWS Inferentia is an ML chip purpose-built by AWS to deliver high-performance inference at a low cost. AWS Inferentia accelerators are designed by AWS to deliver high performance at the lowest cost in Amazon EC2 for your deep learning (DL) and generative AI inference applications.

**Benchmark datasets** - A suitable option for evaluating an LLM for bias and discrimination with the least administrative effort. These datasets are specifically designed and curated to include a variety of scenarios that test for potential biases in model outputs. They are pre-existing and standardized, meaning that the company does not need to spend time or resources creating or manually curating data. Using these datasets allows for a quick, cost-effective, and consistent evaluation of model fairness across different contexts.

**Feature Engineering** - Every unique attribute of the data is considered a “feature” (also known as “attribute”). For example, when designing a solution for predicting customer churn, the data used typically includes features such as customer location, age, income level, and recent purchases.

- **Feature creation** refers to the creation of new features from existing data to help with better predictions. Examples of feature creation include: one-hot-encoding, binning, splitting, and calculated features.
    
- **Feature transformation and imputation** include steps for replacing missing features or features that are not valid. Some techniques include: forming Cartesian products of features, non-linear transformations (such as binning numeric variables into categories), and creating domain-specific features.
    
- **Feature extraction** involves reducing the amount of data to be processed using dimensionality reduction techniques. These techniques include: Principal Components Analysis (PCA), Independent Component Analysis (ICA), and Linear Discriminant Analysis (LDA). This reduces the amount of memory and computing power required, while still accurately maintaining original data characteristics.
    
- **Feature selection** is the process of selecting a subset of extracted features. This is the subset that is relevant and contributes to minimizing the error rate of a trained model. Feature importance score and correlation matrix can be factors in selecting the most relevant features for model training.
# PROMPTING

**Zero shot Prompting**

Zero-shot prompting is a technique used in generative AI where the model is asked to perform a task or generate content without having seen any examples of that specific task during training. Instead, the model relies on its general understanding and knowledge to provide a response.

For example, classifying text into categories (e.g., sentiment analysis, topic detection) without providing specific training examples for those categories.

**Negative prompting** - Negative prompting refers to guiding a generative AI model to avoid certain outputs or behaviors when generating content. In the context of AWS generative AI, like those using Amazon Bedrock, negative prompting is used to refine and control the output of models by specifying what should not be included in the generated content. For example, when generating text for a marketing campaign, a company can use negative prompts to exclude competitive brand names or sensitive topics.

**Chain-of-thought prompting** - Chain-of-thought prompting is a technique that breaks down a complex question into smaller, logical parts that mimic a train of thought. This helps the model solve problems in a series of intermediate steps rather than directly answering the question. This enhances its reasoning ability. It involves guiding the model through a step-by-step process to arrive at a solution or generate content, thereby enhancing the quality and coherence of the output.

**Few shot Prompting** - In few shot prompting, you provide a few examples of a task to the model to guide its output.

# INFERENCE

## Parameters

**Top K** - represents the number of most likely candidates that the model considers for the next token. Choose a lower value to decrease the size of the pool and limit the options to more likely outputs. Choose a higher value to increase the size of the pool and allow the model to consider less likely outputs.

![](https://assets-pt.media.datacumulus.com/aws-aif-pt/assets/pt1-q15-i1.jpg)

via - [https://docs.aws.amazon.com/bedrock/latest/userguide/inference-parameters.html](https://docs.aws.amazon.com/bedrock/latest/userguide/inference-parameters.html)

**Temperature** - Temperature is a value between 0 and 1, and it regulates the creativity of the model's responses. Use a lower temperature if you want more deterministic responses, and use a higher temperature if you want more creative or different responses for the same prompt on Amazon Bedrock.
- Higher values == more creative responses

**Top P** - Top P represents the percentage of most likely candidates that the model considers for the next token. Choose a lower value to decrease the size of the pool and limit the options to more likely outputs. Choose a higher value to increase the size of the pool and allow the model to consider less likely outputs.

**Stop sequences** - Stop sequences specify the sequences of characters that stop the model from generating further tokens. If the model generates a stop sequence that you specify, it will stop generating after that sequence.
### **Top K Sampling**

- **Definition**: Top K sampling restricts the model to consider only the top KK most likely tokens at each step of text generation.  
- **How it works**:
    - The model predicts a probability distribution over all possible tokens.
    - Only the KK tokens with the highest probabilities are retained.
    - The model then samples from this subset of KK tokens.
- **Effect**:
    - A smaller KK value makes the output more deterministic and focused, as the model is limited to a narrow set of high-probability tokens.
    - A larger KK value allows for more diversity and creativity, as the model has a broader range of tokens to choose from.
- **Use case**: Useful when you want to control the diversity of the output while maintaining some level of coherence.
    

### **Top P (Nucleus Sampling)**

- **Definition**: Top P sampling, or nucleus sampling, restricts the model to consider the smallest set of tokens whose cumulative probability exceeds a threshold PP (where 0<P≤10<P≤1).
- **How it works**:
    - The model predicts a probability distribution over all possible tokens.
    - Tokens are sorted in descending order of probability.
    - The smallest set of tokens is selected such that their cumulative probability is greater than or equal to PP.
    - The model then samples from this subset.
- **Effect**:
    - A lower PP value (e.g., 0.1) results in a smaller set of high-probability tokens, making the output more deterministic.
    - A higher PP value (e.g., 0.9) allows for a larger set of tokens, increasing diversity and creativity.
- **Use case**: Useful when you want to dynamically adjust the size of the token set based on the confidence of the model's predictions.

### **Key Differences**

1. **Selection Mechanism**:
    - **Top K**: Fixed number of tokens (KK) are selected.
    - **Top P**: A variable number of tokens are selected based on cumulative probability.
2. **Flexibility**:
    - **Top K**: Less flexible, as the number of tokens is fixed regardless of the probability distribution.
    - **Top P**: More flexible, as the number of tokens adapts to the confidence of the model's predictions.
3. **Use Cases**:
    - **Top K**: Better for scenarios where you want consistent control over the diversity of the output.
    - **Top P**: Better for scenarios where you want to dynamically balance creativity and coherence.

### **Example**

Suppose the model predicts the following probabilities for the next token:

- Token A: 0.5
- Token B: 0.3
- Token C: 0.1
- Token D: 0.05
- Token E: 0.05

- **Top K (K=2)**: Only tokens A and B are considered.
- **Top P (P=0.8)**: Tokens A, B, and C are considered (cumulative probability = 0.9, which exceeds 0.8).
### **Combining Top K and Top P**

In practice, Top K and Top P can be used together for finer control over text generation. For example, you might first apply Top K to narrow down the tokens and then apply Top P to further refine the selection.

## Models

**Asynchronous** - Allows the company to process smaller payloads without requiring real-time responses by queuing the requests and handling them in the background. This method is cost-effective and efficient when some delay is acceptable, as it frees up resources and optimizes compute usage. Asynchronous inference is ideal for scenarios where the payload size is less than 1 GB and immediate results are not critical.
**Batch** - generally used for processing large datasets all at once. While it does not require immediate responses, it is typically more efficient for handling larger payloads (several gigabytes or more). For smaller payloads of less than 1 GB, batch inference might be overkill and less cost-efficient compared to asynchronous inference.
**Real-Time** - Optimized for scenarios where low latency is essential, and responses are needed immediately.
**Serverless** - A good choice for workloads with unpredictable traffic or sporadic requests, as it scales automatically based on demand. However, it may not be as cost-effective for scenarios where workloads are predictable, and some waiting time is acceptable.
# Transformers

Transformer models use a self-attention mechanism and implement contextual embeddings

# Bias Types

**Sampling bias** - Occurs when the data used to train the model does not accurately reflect the diversity of the real-world population. If certain ethnic groups are underrepresented or overrepresented in the training data, the model may learn biased patterns, causing it to flag individuals from those groups more frequently.

**Measurement bias** - Involves inaccuracies in data collection, such as faulty equipment or inconsistent measurement processes.

**Observer bias** - Relates to human errors or subjectivity during data analysis or observation. Since the AI model processes the data autonomously without human intervention, observer bias is not a factor in the biased outcomes of the model.

**Confirmation bias** - Involves selectively searching for or interpreting information to confirm existing beliefs. 

# AWS - General

**Availability Zones/Regions**
- Each AWS Region consists of a minimum of three Availability Zones (AZ)
- Each Availability Zone (AZ) consists of one or more discrete data centers

**AWS Audit Manager** - Helps automate the collection of evidence to continuously audit your AWS usage. It simplifies the process of assessing risk and compliance with regulations and industry standards, making it an essential tool for governance in AI systems.

**AWS Artifact** - AWS Artifact provides on-demand access to AWS’ compliance reports and online agreements. It is useful for obtaining compliance documentation.

**AWS Trusted Advisor** - AWS Trusted Advisor offers guidance to help optimize your AWS environment for cost savings, performance, security, and fault tolerance.

**AWS CloudTrail** - AWS CloudTrail records AWS API calls for auditing purposes and delivers log files for compliance and operational troubleshooting. It is crucial for tracking user activity.

# Services

**AI Service Cards** - Introduces transparency in the model selection process. Each AI Service Card contains four sections covering:
- Basic concepts to help customers better understand the service or service features
- Intended use cases and limitations
- Responsible AI design considerations
- Guidance on deployment and performance optimization

**Amazon Textract** - Amazon Textract is a machine learning (ML) service that automatically extracts text, handwriting, layout elements, and data from scanned documents. It goes beyond simple optical character recognition (OCR) to identify, understand, and extract specific data from documents.

**Amazon SageMaker Data Wrangler** - Amazon SageMaker Data Wrangler reduces the time it takes to aggregate and prepare tabular and image data for ML from weeks to minutes. With SageMaker Data Wrangler, you can simplify the process of data preparation and feature engineering, and complete each step of the data preparation workflow (including data selection, cleansing, exploration, visualization, and processing at scale) from a single visual interface.

**Amazon Mechanical Turk** - provides an on-demand, scalable, human workforce to complete jobs that humans can do better than computers. Amazon Mechanical Turk software formalizes job offers to the thousands of Workers willing to do piecemeal work at their convenience. The software also retrieves work performed and compiles it for you, the Requester, who pays the Workers for satisfactory work (only). Optional qualification tests enable you to select competent Workers.

**Amazon Ground Truth** - helps you build high-quality training datasets for your machine learning models. With Amazon Ground Truth, you can use workers from either Amazon Mechanical Turk, a vendor company that you choose, or an internal, private workforce along with machine learning to enable you to create a labeled dataset. You can use the labeled dataset output from Amazon Ground Truth to train your own models. You can also use the output as a training dataset for an Amazon SageMaker model.

**Amazon SageMaker Model Monitor** - A service that continuously monitors the quality of machine learning models in production and helps detect data drift, model quality issues, and anomalies. It ensures that models perform as expected and alerts users to issues that might require human intervention.

**Amazon SageMaker Ground Truth** - Used for building highly accurate training datasets for machine learning quickly. It does involve human annotators for labeling data, but it is not specifically designed for monitoring or human review of model predictions in production.

**Amazon QuickSight** - specifically designed for creating interactive visualizations and dashboards for a wide range of data sources, including sales data. It provides an easy-to-use interface for business intelligence tasks, enabling the company to quickly generate insights and monitor trends. QuickSight also supports real-time data analysis, making it ideal for up-to-date reporting on sales performance over the last 12 months.

**Amazon SageMaker Feature Store** - A fully managed repository for storing, updating, and retrieving machine learning features.

**Amazon Comprehend** - Amazon Comprehend is a natural language processing (NLP) service that uses machine learning to find meaning and insights in text. By utilizing NLP, you can extract important phrases, sentiments, syntax, key entities such as brand, date, location, person, etc., and the language of the text. Comprehend can analyze text, but cannot extract it from documents or images.

**Amazon Kendra** - a highly accurate and easy-to-use enterprise search service that’s powered by machine learning (ML). It allows developers to add search capabilities to their applications so their end users can discover information stored within the vast amount of content spread across their company. This includes data from manuals, research reports, FAQs, human resources (HR) documentation, and customer service guides, which may be found across various systems such as Amazon Simple Storage Service (S3), Microsoft SharePoint, Salesforce, ServiceNow, RDS databases, or Microsoft OneDrive.

**Amazon Bedrock** - An AI service that provides access to foundation models (large language models, including those for NLP tasks) via an API. While Amazon Bedrock is not specifically an NLP service like Amazon Comprehend, it can be used to fine-tune pre-trained foundation models for various tasks, including sentiment analysis. With the proper configuration and fine-tuning, Bedrock can analyze text data to determine sentiment, making it a versatile option for advanced users who may need more customizable solutions than Amazon Comprehend.

**Amazon Rekognition** - Amazon Rekognition is a service designed for analyzing images and videos, not text. It can identify objects, people,<u>text within images</u>, and even detect inappropriate content in images and videos.

**Amazon Personalize** - Amazon Personalize is a service that provides personalized recommendations, search, and ranking for websites and applications based on user behavior and preferences.

**Amazon Augmented AI (A2I)** - A service that helps implement human review workflows for machine learning predictions. It integrates human judgment into ML workflows, allowing for reviews and corrections of model predictions, which is critical for applications requiring high accuracy and accountability.

**SageMaker Clarify** - Specifically designed to help identify and mitigate bias in machine learning models and datasets. It provides tools to analyze both data and model predictions to detect potential bias, generate reports, and help ensure that models are fair and transparent.

**Amazon Lex** - Amazon Lex is a fully managed artificial intelligence (AI) service with advanced natural language models to design, build, test, and deploy conversational interfaces in applications. Amazon Lex leverages the power of Generative AI and Large Language Models (LLMs) to enhance the builder and customer experience. Lex integrates with AWS Lambda, used to easily trigger functions for execution of your back-end business logic for data retrieval and updates. Once built, your bot can be deployed directly to contact centers, chat and text platforms, and IoT devices. Lex provides rich insights and pre-built dashboards to track metrics for your choice.

**AWS DeepRacer** - A Wi-Fi-enabled physical vehicle that can drive itself on a physical track by using a reinforcement learning model.

**Globally Scoped Services**:  
- AWS Identity and Access Management (AWS IAM)
- Amazon CloudFront
- Amazon Route 53
- Web Application Firewall (AWS WAF)

**Region Scoped Services:**
- Lambda
- Rekognition

**Amazon S3** - Amazon S3 is a unique service in the sense that it follows a global namespace but the buckets are regional. You specify an AWS Region when you create your Amazon S3 bucket. This is a regional service.

# Model Explainability

**Shapley values** are a local interpretability method that explains individual predictions by assigning each feature a contribution score based on its marginal effect on the prediction. This method is useful for understanding the impact of each feature on a specific instance's prediction.

**Partial Dependence Plots (PDP)**, on the other hand, provide a global view of the model’s behavior by illustrating how the predicted outcome changes as a single feature is varied across its range, holding all other features constant. PDPs help understand the overall relationship between a feature and the model output across the entire dataset.

Thus, Shapley values are suited for explaining individual decisions, while PDP is used to understand broader trends in model behavior.