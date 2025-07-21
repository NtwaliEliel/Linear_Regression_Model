from fastapi import FastAPI
from pydantic import BaseModel, Field
from fastapi.middleware.cors import CORSMiddleware
import joblib
import numpy as np
import pandas as pd

# Load the model
model = joblib.load("best_model.pkl")  # ✅ Make sure this file is in the same directory

# Create app
app = FastAPI(title="Freelance Salary Predictor")

# Enable CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allow all origins for testing; restrict in production
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Define input data model
class SalaryInput(BaseModel):
    experience_level: str = Field(..., example="SE")
    employment_type: str = Field(..., example="FT")
    job_title: str = Field(..., example="Data Scientist")
    employee_residence: str = Field(..., example="US")
    remote_ratio: int = Field(..., ge=0, le=100, example=100)
    company_location: str = Field(..., example="US")
    company_size: str = Field(..., example="M")

# Prediction endpoint
@app.post("/predict")
def predict(data: SalaryInput):
    input_df = pd.DataFrame([{
        "experience_level": data.experience_level,
        "employment_type": data.employment_type,
        "job_title": data.job_title,
        "employee_residence": data.employee_residence,
        "remote_ratio": data.remote_ratio,
        "company_location": data.company_location,
        "company_size": data.company_size
    }])

    prediction = model.predict(input_df)
    return {"predicted_salary_usd": round(prediction[0], 2)}
