from src.apps.prescriptionapp.models import *
from tortoise.contrib.pydantic import pydantic_model_creator


#######clinic########
Create_Clinic = pydantic_model_creator(
    Clinic, name="ClinicGet", exclude=("timings", "created", "updated", "id", "clinicTimings", "clinic_images"))
Create_Recopinist = pydantic_model_creator(
    ClinicReceponists, name="createrecoponist", exclude=("id", "created", "updated"))
Create_Doctor = pydantic_model_creator(
    ClinicDoctors, name="ClinicDoctors", exclude=("id", "created", "updated", 'timings'))
Create_Timings = pydantic_model_creator(
    ClinicTimings, name="timings", exclude=("id","created","updated"))
Create_AppointmentSlots = pydantic_model_creator(
    AppointmentSlots, name="timings", exclude=("id", "created", "updated"))
Create_Medicine = pydantic_model_creator(
    Medicine, name="medicines", exclude=("id", "created", "updated"))
Create_Prescription = pydantic_model_creator(
    Prescription, name="prescription", exclude=("id", "created", "updated"))
Create_PresMedicines = pydantic_model_creator(
    PresMedicines, name="presmedicines", exclude=("id", "created", "updated"))
GET_Clinic = pydantic_model_creator(
    Clinic, name="ClinicGet")
GET_Recopinist = pydantic_model_creator(
    ClinicReceponists, name="createrecoponist")
GET_Doctor = pydantic_model_creator(
    ClinicDoctors, name="doctors")
GET_Appointments = pydantic_model_creator(
    Appointments, name="appointments")
GET_Appointments = pydantic_model_creator(
    Appointments, name="appointments")
GET_Slots = pydantic_model_creator(
    AppointmentSlots, name="slots")
GET_Prescription = pydantic_model_creator(
    Prescription, name="prescription")




