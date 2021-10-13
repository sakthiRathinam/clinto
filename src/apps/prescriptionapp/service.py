
from starlette.responses import JSONResponse
# from starlette.requests import Request
from src.apps.base.service_base import BaseService
from .models import *
from typing import TypeVar, Type, Optional
from .pydanticmodels import *
ModelType = TypeVar("ModelType", bound=models.Model)

###############################################viewsets###########################################
class ClincViewSet(BaseService):
    model = Clinic
    get_schema = GET_Clinic
    
class ReceponistViewSet(BaseService):
    model = ClinicReceponists
    get_schema = GET_Recopinist

class DoctorViewSet(BaseService):
    model = ClinicReceponists
    get_schema = GET_Doctor
    
class MedicineViewSet(BaseService):
    model = Medicine
    get_schema = GET_Doctor
    
class AppointmentViewSet(BaseService):
    model = Appointments
    get_schema = GET_Appointments
    
    async def limited_data(self, **kwargs) -> Optional[ModelType]:
        if 'limit' and 'offset' in kwargs:
            toReturn = await self.model.all().offset(kwargs['offset']).limit(kwargs['limit'])
        if 'status' in kwargs:
            toReturn = toReturn.filter(status=kwargs['status'])
        return toReturn

class SlotViewSet(BaseService):
    model = AppointmentSlots
    get_schema = GET_Slots
    
##########################################routers#####################################################
clinic_view = ClincViewSet()
receponist_view = ReceponistViewSet()
doctor_view = DoctorViewSet()
appointment_view = AppointmentViewSet()
slot_view = SlotViewSet()


    
    
    



