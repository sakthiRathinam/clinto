import uuid
from starlette.responses import JSONResponse
# from starlette.requests import Request
from src.apps.users.models import User
from starlette import status
from .models import *
from src.config.settings import BASE_DIR, STATIC_ROOT, MEDIA_ROOT
from src.apps.users.views import get_current_login
from src.apps.base.service_base import CustomPage
from fastapi import APIRouter, Depends, BackgroundTasks, Response, status, Request, File, UploadFile, Body
from tortoise.query_utils import Q
import pathlib
from typing import List , Optional
from src.apps.users.models import User, User_Pydantic
from src.apps.users.service import user_service
import os
import shutil
from .service import *
from .schema import *
from .pydanticmodels import *
from fastapi_pagination import LimitOffsetPage, Page, add_pagination
from fastapi_pagination.ext.tortoise import paginate
import datetime
clinto_router = APIRouter(dependencies=[Depends(get_current_login)])
days = ["Monday", "Tuesday", "Wednesday",
        "Thursday", "Friday", "Saturday", "Sunday"]
@clinto_router.get('/doctorClinics/{userid}')
async def getClinics(userid: int):
    user = await User.get(id=userid).prefetch_related("workingclinics")
    clinics = [{"name": clinic.name, "email": clinic.email}async for clinic in user.workingclinics.all()]



@clinto_router.post('/createClinic')
async def createClinic(clinic: Create_Clinic = Body(...)):
    clinic_obj = await Clinic.create(**clinic.dict(exclude_unset=True))
    # path = pathlib.Path(
    #     MEDIA_ROOT, f"clinicmainimages/{str(clinic_obj.id)+file.filename}")
    # os.makedirs(os.path.dirname(path), exist_ok=True)
    # with path.open('wb') as write:
    #     shutil.copyfileobj(file.file, write)
    # clinic_obj.display_picture = path
    # await clinic_obj.save()
    # print(file.filename)
    # print(create_clinic)
    return clinic_obj
    
@clinto_router.get('/getClinics')
async def get_clinics(limit: int = 10, offset: int = 0, type: Optional[SubTypes]=SubTypes.normal):
    clinics = await clinic_view.limited_data(limit=limit, offset=offset)
    clinics_objs = []
    for clinic in clinics:
        timings = await clinic.timings.all().values('timings','day')
        clinics_objs.append({"clinic_data": clinic, "timings": timings})
    return clinics_objs

@clinto_router.post('/addDoctors')
async def add_doctors(data: Create_Doctor, user: User_Pydantic,clinic: int = Body(...)):
    if await User.filter(Q(username=user.username) | Q(email=user.email)).exists():
        user = await User.filter(Q(username=user.username) | Q(email=user.email)).first()
    else:
        user = await user_service.create_user(user)
    create_doctor = await ClinicDoctors.create(clinic_id=clinic, user_id=user, **data.dict(exclude_unset=True))
    return create_doctor

@clinto_router.post('/addRecoponist')
async def add_doctors(data: Create_Recopinist, user: User_Pydantic, clinic: int = Body(...)):
    if await User.filter(Q(username=user.username) | Q(email=user.email)).exists():
        user = await User.filter(Q(username=user.username) | Q(email=user.email)).first()
    else:
        user = await user_service.create_user(user)
    create_recopinist = await ClinicReceponists.create(clinic_id=clinic, user_id=user.id, **data.dict(exclude_unset=True))
    return create_recopinist

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
async def add_timings(timings: List[Create_Timings],clinic: bool=Body(...), clinicid: int=Body(...)):
    if clinic:
        for time in timings:
            clinic_timings = await Clinic.get(id=clinicid).prefetch_related('timings')
            timings_obj = await clinic_timings.timings.filter(day=time.day).first()
            timings_obj.timings = time.timings
            await timings_obj.save()
    if not clinic:
        for time in timings:
            timings_obj =await ClinicTimings.get(doctor_id=clinicid,day=time.day)
            timings_obj.timings = time.timings
            await timings_obj.save()
    return {"success":"timing updated"}

@clinto_router.post("/getDoctorClinics")
async def get_doctor_clinics(doctor:int):
    doctor_obj = await User.get(id=doctor).prefetch_related("workingclinics")
    working_clinics = await doctor.workingclinics.all()
    return {"working_clinics": working_clinics,"user":doctor_obj}

# @clinto_router.post('/addRecopinist')
# async def add_recopinist(data: Create_Recopinist):
#     create_recopinist = await ClinicReceponists.create(clinic_id=clinic, user_id=user, **data.dict(exclude_unset=True))
#     return create_recopinist

@clinto_router.post('/addSlot')
async def add_slots(data: Create_AppointmentSlots,clinicid: int = Body(...)):
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



@clinto_router.post('/addPrescription')
async def add_prescription(data:AddPrescription):
    pres_obj = Prescription()
    if data.personal_prescription:
        if data.doctor is None:
            raise HTTPException(
                status_code=status.HTTP_500_BAD_REQUEST, detail="Doctor is mandatory"
            )
        else:
            doctor_obj = await User.get(id=data.doctor_id)
            pres_obj = await Prescription.create(**data.dict(exclude_unset=True))
            for diag in data.diagonsis:
                diag_obj = await Diagonsis.get_or_create(title=diag.diagonsis)
                if diag.template:
                    pres_template = await PrescriptionTemplates.create(diagonsis=diag_obj,personal=True,doctor=doctor_obj,command=diag.command)
                for medicine in medicines_list:
                    medicine_obj = await PresMedicines.create(**medicine.dict(exclude_unset=True))
                    await pres_obj.medicines.add(medicine_obj)
                    if diag.template:
                        await pres_template.medicines.add(medicine_obj)
                await pres_obj.diagonsis.add(diag_obj)
            for report in data.reports:
                report_obj = await MedicalReports.get_or_create(title=report)
                await pres_obj.reports.add(report_obj)
    else:
        if data.clinic_id is None and data.doctor_id is None:
            raise HTTPException(
                status_code=status.HTTP_500_BAD_REQUEST, detail="Clinic is mandatory"
            )
        else:
            clinic_obj = await Clinic.get(id=data.clinic_id)
            doctor_obj = await User.get(id=data.doctor_id)
            pres_obj = await Prescription.create(**data.dict(exclude_unset=True))
            for diag in data.diagonsis:
                diag_obj = await Diagonsis.get_or_create(title=diag.diagonsis)
                if diag.template:
                    pres_template = await PrescriptionTemplates.create(diagonsis=diag_obj, personal=False, clinic=clinic_obj, command=diag.command)
                for medicine in medicines_list:
                    medicine_obj = await PresMedicines.create(**medicine.dict(exclude_unset=True))
                    await pres_obj.medicines.add(medicine_obj)
                    if diag.template:
                        await pres_template.medicines.add(medicine_obj)
                await pres_obj.diagonsis.add(diag_obj)
            for report in data.reports:
                report_obj = await MedicalReports.get_or_create(title=report)
                await pres_obj.reports.add(report_obj)
            return JSONResponse({"success":"prescription created successfully","pres_obj":pres_obj.id},status_code=500)
        
@clinto_router.get('/getPrescriptions')
async def get_prescriptions(clinic:Optional[int]=None,doctor:Optional[int]=None,user:Optional[int]=None,limit:int=10,offset:int=0):
    if clinic is not None:
        pres_objs = await Prescription.filter(clinic_id=clinic)
    if doctor is not None:
        doctor_objs = await Prescription.filter(doctor)
            
        
        


@clinto_router.post('/addExistingDoctor')
async def add_prescription(data: AddExistingDoctor):
    clinic_doctor,created = await ClinicDoctors.get_or_create(user_id=data.doctor,clinic_id=data.clinic,owner_access=data.owner_access,doctor_access=data.doctor_access)
    for time in data.timings:
        timings_obj = await clinic_doctor.timings.filter(day=time.day)
        timings_obj = timings_obj[0]
        if timings_obj is not None:
            timings_obj.timings = time.timings
            await timings_obj.save()
        else:
            print("not found")
    return {"success":"doctor added success"}


    

@clinto_router.get('/getFullDetail')
async def clinic_full_detail(clinic_id:int):
    clinic_obj = await Clinic.get(id=clinic_id).prefetch_related('workingreceponists','doctors')
    working_doctors =await clinic_obj.doctors.all().prefetch_related('user','timings')
    doctors = []
    for doctor in working_doctors:
        timings = [{"day":doctortiming.day,"timings":doctortiming.timings} for doctortiming in await doctor.timings.all().only('day','timings')]
        user = await doctor.user
        basic_detials = {"dp": user.display_picture, "name": user.first_name +
                         user.last_name, "id": doctor.id, "email": user.email}
        doctors.append({"details":basic_detials,"timings":timings})
    recopinists =await clinic_obj.workingreceponists.all().prefetch_related('user')
    recoponists_array = []
    for recop in recopinists:
        user = await recop.user
        basic_detials = {"dp": user.display_picture, "name": user.first_name +
                         user.last_name, "id": recop.id, "email": user.email, "startime": recop.starttime_str, "endtime": recop.endtime_str}
        recoponists_array.append(basic_detials)
    return {"doctors": doctors, "recoponists": recoponists_array}

clinto_router.redirect_slashes = False

@clinto_router.delete('/clinicWorkers')
async def delete_clinic_members(worker:int,doctor:Optional[bool]=False):
    if doctor:
        s = await ClinicDoctors.get(id=worker).delete()
        if s:
            return {"success":"doctor deleted"}
        else:
            return {"failed":"doctor does not exist"}
    s = await ClinicReceponists.get(id=worker).delete()
    if s:
        return {"success": "recoponist deleted"}
    else:
        return {"failed": "recoponist does not exist"}
    



def age(date) -> int:
    if date is not None:
        year = 365.2425
        start_date = date
        end_date = datetime.date.today()
        age = round((end_date - start_date).days // year)
        return age
    return 0

@clinto_router.get('/doctorList')
async def get_doctors():
    doctors = await User.filter(roles="Doctor")
    doctors_detail = []
    for doctor in doctors:
        doctor_profile = {"name": doctor.first_name + doctor.last_name, "age": age(doctor.date_of_birth), "qualification": doctor.qualifications,
                          "specialization": doctor.specialization, "email": doctor.email, "address": doctor.address, "state": doctor.state, "city": doctor.city,"working_clinics":[]}
        working_clinics = await doctor.workingclinics.all()
        for clinic in working_clinics:
            clinic_obj = await clinic.clinic
            doctor_profile['working_clinics'].append({"clinicname": clinic_obj.name, "city": clinic_obj.city, "state": clinic_obj.state,
                                                      "address": clinic_obj.address, "pincode": clinic_obj.pincode, "display_picture": clinic_obj.display_picture, "lat": clinic_obj.lat, "lang": clinic_obj.lang})
        doctors_detail.append(doctor_profile)
    return doctors_detail

@clinto_router.delete('/deleteClinicImages')
async def delete_image(index:int,clinic:int):
    clinic_obj = await Clinic.get(id=clinic)
    image_path = clinic_obj.clinic_images.pop(index)
    media_path = os.remove(image_path)
    await clinic_obj.save()
    return {"success":"image deleted"}
            
@clinto_router.post('/addMedicines')
async def add_medicines(data: Create_Medicine = Body(...)):
    add_medicine = await medicine_view.create(data)
    return {"medicine":"medicine created successfully","medicine_obj":add_medicine}

@clinto_router.delete('/deleteMedicines')
async def delete_medicines(id:int):
    await medicine_view.delete(id=id)
    return {"success":"deleted"}

@clinto_router.put('/updateMedicines')
async def update_medicines(id:int,data:Create_Medicine= Body(...)):
    await medicine_view.update(data,id=id)
    return {"success":"updated"}

@clinto_router.put('/filtermedicines')
async def filter_medicines(data: GET_Medicine = Body(...)):
    await medicine_view.filter(**data.dict(exclude_unset=True))
    return {"success":"updated"}

@clinto_router.get('/mainMedicines')
async def main_medicines(limit:int=10,offset:int=0,active:bool=True,search:bool=False):
    next_items = False
    previous_items = False
    total_items = await Medicine.filter(active=active).count()
    medicines = await Medicine.filter(active=active)
    if not search:
        if offset > 0:
            previous_items = True
        if total_items < (offset/limit) * limit:
            next_items = True
    return medicines

@clinto_router.post('/addReports')
async def add_medicines(data: Create_Reports = Body(...)):
    add_medicine = await report_view.create(data)
    return {"medicine":"medicine created successfully","medicine_obj":add_medicine}

@clinto_router.delete('/deleteReports')
async def delete_medicines(id:int):
    await report_view.delete(id=1)
    return {"success":"deleted"}

@clinto_router.put('/updateReports')
async def update_medicines(id: int, data: Create_Reports = Body(...)):
    await report_view.update(data, id=id)
    return {"success":"updated"}

@clinto_router.put('/filterReports')
async def filter_medicines(data: GET_Reports = Body(...)):
    await report_view.filter(**data.dict(exclude_unset=True))
    return {"success":"updated"}

@clinto_router.get('/paginateMedicines', response_model=CustomPage[GET_Medicine])
async def paginate_mediciens(request: Request) -> any:
    medicines = await paginate(Medicine.all())
    extra = {'previous':False,"next":True}
    if request.query_params['page'] != str(1):
        extra['previous'] = True
    if (int(request.query_params['page']) * int(request.query_params['size']))+1 > medicines.total:
        extra['next'] = False
    data = {**medicines.dict(),**extra}
    return medicines




# @clinto_router.post('/addMedicines')
# async def add_medicines(data: Create_Medicine = Body(...)):
#     add_medicine = await medicine_view.create(data)
#     return {"medicine":"medicine created successfully","medicine_obj":add_medicine}

# @clinto_router.delete('/deleteMedicines')
# async def delete_medicines(id:int):
#     await medicine_view.delete(id=1)
#     return {"success":"deleted"}

# @clinto_router.put('/updateMedicines')
# async def update_medicines(id:int,data:Create_Medicine= Body(...)):
#     await medicine_view.update(data,id=id)
#     return {"success":"updated"}

# @clinto_router.put('/filtermedicines')
# async def filter_medicines(data: GET_Medicine = Body(...)):
#     await medicine_view.filter(**data.dict(exclude_unset=True))
#     return {"success":"updated"}
        


    
    
    
    
    
    
    
    




    
        
        
    
    


        













    









    
    

