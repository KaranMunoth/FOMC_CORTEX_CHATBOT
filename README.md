# 🧠 FOMC Chatbot App using Snowflake Cortex + Streamlit

Welcome to the **FOMC Chatbot App** – a conversational AI application that leverages **Snowflake Cortex Search** and **Streamlit in Snowflake** to extract insights from FOMC meeting minutes in PDF format.

> 💬 Ask contextual questions like:
> *"How did the Fed perceive inflation trends in Q4 2023?"*
> *"Summarize the key highlights from July 2024 meetings."*

---

## 🚀 Project Overview

This project follows a complete pipeline:

1. Load FOMC meeting PDFs
2. Parse & chunk content
3. Build a Cortex Search service
4. Create an interactive Streamlit chatbot interface

---

## 📁 Repository Structure

```bash
🗂 fomc-chatbot-app/
│
├── cortexsearch_obj_FOMC.sql               # Step 1 & 2: Stage creation and file upload
├── cortexsearchservice_FOMC.sql            # Step 3 & 4: Parsing and search service setup
├── FOMC_CHATBOT_APP.py                     # Step 5: Streamlit script to create the chatbot interface
├── fomc_minutes.zip                        # Step 1: Sample PDF dataset (FOMC minutes)
└── README.md                               # This file
```

---

## 🧹 Step-by-Step Guide

### 🔹 Step 1: Setup & Download PDF Data

* Download the `fomc_minutes.zip` and extract it.
* Upload the PDF files to a Snowflake **Stage**.

```sql
-- Create a stage
CREATE OR REPLACE STAGE cortex_search_tutorial_db.public.fomc
  DIRECTORY = (ENABLE = TRUE)
  ENCRYPTION = (TYPE = 'SNOWFLAKE_SSE');
```

> 📦 *See*: `cortexsearch_obj_FOMC.sql`

---

### 🔹 Step 2: Upload PDFs to Snowflake

* Use Snowsight → Data → Stages → Upload extracted `.pdf` files under your `fomc` stage.

---

### 🔹 Step 3: Parse PDF Files

Use Cortex functions to extract and chunk the text:

```sql
-- Extract raw text from PDFs
CREATE OR REPLACE TABLE raw_text AS
SELECT ...
FROM DIRECTORY('@cortex_search_tutorial_db.public.fomc');

-- Chunk the extracted layout into digestible segments
CREATE OR REPLACE TABLE doc_chunks AS
SELECT ...
FROM raw_text, LATERAL FLATTEN(...);
```

> 🔍 *See*: `cortexsearchservice_FOMC.sql`

---

### 🔹 Step 4: Create a Cortex Search Service

```sql
CREATE OR REPLACE CORTEX SEARCH SERVICE fomc_meeting
  ON chunk
  ATTRIBUTES language
  WAREHOUSE = cortex_search_tutorial_wh
  AS (
    SELECT chunk, relative_path, file_url, language
    FROM doc_chunks
  );
```

---

### 🔹 Step 5: Create the Chatbot App (Streamlit)

Edit and deploy the Streamlit app directly in Snowsight:

* Create a new Streamlit app
* Select the correct DB & schema
* Install:

  * `snowflake>=0.8.0`
  * `snowflake-ml-python`
* Paste code from `FOMC_CHATBOT_APP.py`

Preview, test, and deploy!

---

## 💡 Sample Queries to Try

* “What was the Fed’s stance on inflation in Q1 2024?”
* “Summarize major themes from the May 2023 meeting.”
* “How has the tone changed over the last three meetings?”

---

## 🛠️ Tech Stack

* **Snowflake Cortex Search**
* **Snowflake Stages + SQL**
* **Streamlit in Snowflake**
* **Python SDK**

---


## ⭐ Star this repo if you found it useful!
