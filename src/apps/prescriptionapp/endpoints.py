import uuid
from starlette.responses import JSONResponse
# from starlette.requests import Request
from src.apps.users.models import User
from .models import *
from src.config.settings import BASE_DIR, STATIC_ROOT, MEDIA_ROOT
from src.apps.users.views import get_current_login
from fastapi import APIRouter, Depends, BackgroundTasks, Response, status, Request, File, UploadFile, Body
import pathlib
from typing import List , Optional

import os
import shutil
from .service import *
from .schema import *
from .pydanticmodels import *

clinto_router = APIRouter(dependencies=[Depends(get_current_login)])

days = ["Monday", "Tuesday", "Wednesday",
        "Thursday", "Friday", "Saturday", "Sunday"]
@clinto_router.get('/doctorClinics/{userid}')
async def getClinics(userid: int):
    user = await User.get(id=userid).prefetch_related("workingclinics")
    clinics = [{"name": clinic.name, "email": clinic.email}async for clinic in user.workingclinics.all()]

@clinto_router.post('/createClinic')
async def createClinic(clinic: Create_Clinic):
    create_clinic = await clinic_view.create(clinic)
    print(create_clinic)
    
@clinto_router.get('/getClinics')
async def get_clinics(limit:int = 10,offset:int = 0):
    clinics = await clinic_view.limited_data(limit=limit, offset=offset)
    clinics_objs = []
    for clinic in clinics:
        timings = await clinic.timings.all().values('timings','day')
        print(timings,"imhere")
        clinics_objs.append({"clinic_data": clinic, "timings": timings})
    return clinics_objs

@clinto_router.post('/addDoctors')
async def add_doctors(clinic:int,user:int,data:Create_Doctor):
    create_doctor = await ClinicDoctors.create(clinic_id=clinic, user_id=user, **data.dict(exclude_unset=True))
    return create_doctor

@clinto_router.post("/addClinicImages")
async def clinic_images(clinic: int,files: List[UploadFile] = File(...)):
    file_paths = []
    clinic_obj = await Clinic.get(id=clinic)
    for file in files:
        sample_uuid = uuid.uuid4()
        path = pathlib.Path(
        MEDIA_ROOT, f"clinicimages/{str(sample_uuid)+file.filename}")
        os.makedirs(os.path.dirname(path), exist_ok=True)
        file_paths.append(str(path))
        with path.open('wb') as write:
            shutil.copyfileobj(file.file, write)
    clinic_obj.clinic_images = file_paths
    await clinic_obj.save()
    return clinic_obj

@clinto_router.post("/addTimings")
async def add_timings(clinic: bool, clinicid: int, timings: List[Create_Timings]):
    if clinic:
        for time in timings:
            timings_obj = ClinicTimings.get(clinic_id=clinicid,day=time.day)
            timings_obj.timings = time.timings
            await timings_obj.save()
    if not clinic:
        for time in timings:
            timings_obj = ClinicTimings.get(doctor_id=clinicid,day=time.day)
            timings_obj.timings = time.timings
            await timings_obj.save()
    return {"success":"timing updated"}

@clinto_router.post("/getDoctorClinics")
async def get_doctor_clinics(doctor:int):
    doctor_obj = await User.get(id=doctor).prefetch_related("workingclinics")
    working_clinics = await doctor.workingclinics.all()
    return {"working_clinics": working_clinics,"user":doctor_obj}

@clinto_router.post('/addRecopinist')
async def add_recopinist(data: Create_Recopinist):
    create_recopinist = await ClinicReceponists.create(clinic_id=clinic, user_id=user, **data.dict(exclude_unset=True))
    return create_recopinist

@clinto_router.post('/addSlot')
async def add_slots(data: Create_AppointmentSlots,clinicid:int):
    create_slot = await AppointmentSlots.create(clinic_id=clinicid, user_id=user, **data.dict(exclude_unset=True))
    return create_slot

@clinto_router.post('/addAppointments')
async def add_appointments(data: Create_AppointmentSlots, clinicid: int,user:int,slot:int,accepted_slot:Optional[int]=None):
    if accepted_slot is None:
        create_appointment = await Appointments.create(clinic_id=clinicid,user_id=user,requested_slot_id=slot,**data.dict(exclude_unset=True))
    if accepted_slot is not None:
        create_appointment = await Appointments.create(clinic_id=clinicid, user_id=user, requested_slot_id=slot,accepted_slot_id=accepted_slot **data.dict(exclude_unset=True))
    return create_appointment


@clinto_router.get('/getAppointments')
async def get_appointments(limit: int, offset: int, status: Optional[AppointmentStatus]):
    if status is  None:
        toReturn = appointment_view.limited_data(limit=limit,offset=offset)
        return toReturn
    toReturn = appointment_view.limited_data(limit=limit,offset=offset,status=status)
    return toReturn

@clinto_router.get('/getSlots')
async def get_appointments(limit: int, offset: int, doctor:Optional[int]):
    if status is  None:
        toReturn = appointment_view.limited_data(limit=limit,offset=offset)
        return toReturn
    toReturn = appointment_view.limited_data(limit=limit,offset=offset,status=status)
    return toReturn


    
        
        
    
    


        













    









    
    

