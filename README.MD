# Data Analysis Project Using SQL in MySQL
This project is a simple data analysis pipeline using a dataset from Kaggle. The dataset was downloaded via the Kaggle API, transformed using Python and Pandas, and loaded into a MySQL database. Finally, SQL queries were used to analyze the data.
## Table of Contents
1. Project Overview
2. Technologies Used
3. Installation
4. Dataset
5. Data Transformation
6. SQL Analysis
7. Results
8. Contributing
9. License
10. Contact

## Project Overview
The goal of this project was to perform basic data analysis using SQL in a MySQL database. The process involved:

1. Downloading a dataset from Kaggle.
2. Loading the dataset into a Pandas DataFrame.
3. Cleaning and transforming the data.
4. Loading the transformed data into a MySQL database.
5. Analyzing the dataset using SQL queries.

## Technologies Used
- Python: Used for data extraction, transformation, and loading (ETL).
- Pandas: For data manipulation and cleaning.
- SQLAlchemy & PyODBC: For connecting to the MySQL database.
- MySQL: For storing and querying the dataset.
- Jupyter Notebook: For developing the entire workflow.
- Kaggle API: To download the dataset programmatically.

## Installation
### Prerequisites
Make sure the following are installed on your system:

- Python 3.x
- MySQL Database (Running locally or on a remote server)
- Jupyter Notebook (For running the notebook)
- Kaggle API: For dataset downloading

### Steps
1. Clone the repository
```bash
git clone https://github.com/srinesh-vyd/Retail-Orders-Python-SQLProject.git
cd Retail-Orders-Python-SQLProject
```
2. Create a new python environment
3. Open the retail_orders.ipynb notebook and follow the steps inside.
3. Install required Python libraries:
```jupyter
!pip install kaggle
import kaggle
```
4. Set up the Kaggle API:
      - Create a Kaggle account and generate an API token.
      - Place the API token file (kaggle.json) in the appropriate directory (~/.kaggle/ for Linux/Mac or C:\Users\YourUsername\.kaggle\ for Windows).
5. Create a MySQL database and configure the DSN (Data Source Name) for pyodbc. Update the notebook with your connection details.

## Datasets
The dataset used for this project was sourced from Kaggle. It was downloaded using the Kaggle API and saved as a CSV file.

### Steps to download the dataset:
Inside the Jupyter notebook, use the Kaggle API to download and extract the dataset:
