from uuid import UUID
from pydantic import BaseModel
from typing import List, Optional
from fastapi import UploadFile,File
from datetime import date, datetime, time, timedelta
from .pydanticmodels import Create_PresMedicines, Create_Timings

class AddDoctor(BaseModel):
    clinic: int
    doctor: int
    owner: Optional[bool] = False
    
    
class AddRecopinist(BaseModel):
    clinic: int
    recopinist: int
    start_time : str = ""
    end_time : str = ""
    owner: Optional[bool] = False
    

class Properties(BaseModel):
    language: str = None
    author: str = None
    
class PrescriptionMedicines(BaseModel):
    morning_count : int = 0
    afternoon_count: int = 0
    invalid_count: int = 0
    night_count: int = 0
    qty_per_time: int = 0
    total_qty: int = 0
    command: str = ""
    is_drug: Optional[bool] = False
    before_food: Optional[bool] = False
    is_given: Optional[bool] = False
    days: int = 0
    medicine: int
class AddPrescription(BaseModel):
    active : bool = True
    personal_prescription : bool = False
    contains_drug: Optional[bool] = False
    is_template: Optional[bool] = False
    doctor_fees: int
    user : int
    clinic : Optional[int] = None
    doctor : Optional[int] = None
    receponist : Optional[int]
    diagonsis_list : List[str]
    report_list : Optional[List[str]] = []
    medicines: List[PrescriptionMedicines]

class AddExistingDoctor(BaseModel):
    doctor:int
    clinic:int
    timings: List[Create_Timings]
    owner_access: Optional[bool] = False
    doctor_access: Optional[bool] = False
class CreateClinic(BaseModel):
    name : str
    email: str
    mobile: str
    drug_license: Optional[str] = ""
    gst_no : Optional[str] = ""
    notificationId: Optional[str] = ""
    city: Optional[str] = ""
    state: Optional[str] = ""
    notificationId: Optional[str] = ""
    address: str
    lat: str
    lang: str
    pincode: str
    active: Optional[bool] = True
    
