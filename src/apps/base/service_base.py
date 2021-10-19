from pydantic import BaseModel, conint
from fastapi_pagination import Params
from typing import TypeVar, Generic, Sequence
from fastapi_pagination.bases import AbstractPage, AbstractParams
from typing import TypeVar, Type, Optional, Union
from fastapi import Request, Response
from fastapi import HTTPException
from pydantic import BaseModel
from tortoise.models import Model

from tortoise import models
from fastapi_pagination.ext.tortoise import paginate
from fastapi_pagination import LimitOffsetPage, Page, add_pagination
from tortoise.queryset import QuerySet



ModelType = TypeVar("ModelType", bound=models.Model)
CreateSchemaType = TypeVar("CreateSchemaType", bound=BaseModel)
UpdateSchemaType = TypeVar("UpdateSchemaType", bound=BaseModel)
GetSchemaType = TypeVar("GetSchemaType", bound=BaseModel)
QuerySchemaType = TypeVar("QuerySchemaType", bound=BaseModel)


class BaseService:
    model: Type[ModelType]
    create_schema: CreateSchemaType
    update_schema: UpdateSchemaType
    query_schema: QuerySchemaType
    get_schema: GetSchemaType

    # def __init__(self, model: Type[ModelType]):
    #     self.model = model

    async def create(self, schema, *args, **kwargs) -> Optional[CreateSchemaType]:
        obj = await self.model.create(**schema.dict(exclude_unset=True), **kwargs)
        return await self.get_schema.from_tortoise_orm(obj)
    async def update(self, schema, **kwargs) -> Optional[UpdateSchemaType]:
        await self.model.filter(**kwargs).update(**schema.dict(exclude_unset=True))
        return await self.get_schema.from_queryset_single(self.model.get(**kwargs))
    async def delete(self, **kwargs):
        obj = await self.model.filter(**kwargs).delete()
        if not obj:
            raise HTTPException(status_code=404, detail='Object does not exist')
    async def all(self) -> Optional[GetSchemaType]:
        return await self.get_schema.from_queryset(self.model.all())
    async def filter(self, **kwargs) -> Optional[GetSchemaType]:
        return await self.get_schema.from_queryset(self.model.filter(**kwargs))
    async def get(self, **kwargs) -> Optional[GetSchemaType]:
        return await self.get_schema.from_queryset_single(self.model.get(**kwargs))
    async def get_obj(self, **kwargs) -> Optional[ModelType]:
        return await self.model.get_or_none(**kwargs)
    async def get_or_create(self, **kwargs) -> Optional[ModelType]:
        return await self.model.get_or_create(**kwargs)

    async def paginate_data(query:QuerySet):
        print(query)
        if not isinstance(query, QuerySet):
            query = await query.all()
        paginated_data =  await paginate(query)
        print(request.query_params)
        extra = {'previous': False, "next": True}
        if request.query_params['page'] != str(1):
            extra['previous'] = True
        if (int(request.query_params['page']) * int(request.query_params['size']))+1 > paginated_data.total:
            extra['next'] = False
        data = {**paginated_data.dict(), **extra}
        return data
    async def limited_data(self, **kwargs) -> Optional[ModelType]:
        if 'limit' and 'offset' in kwargs:
            return await self.model.all().offset(kwargs['offset']).limit(kwargs['limit'])
        return "enter required info"
    

######################Base Functions###############################
# @clinto_router.post('/addMedicines')
# async def add_medicines(data: Create_Medicine = Body(...)):
#     add_medicine = await medicine_view.create(data)
#     return {"medicine": "medicine created successfully", "medicine_obj": add_medicine}


# @clinto_router.delete('/deleteMedicines')
# async def delete_medicines(id: int):
#     await medicine_view.delete(id=1)
#     return {"success": "deleted"}


# @clinto_router.put('/updateMedicines')
# async def update_medicines(id: int, data: Create_Medicine = Body(...)):
#     await medicine_view.update(data, id=id)
#     return {"success": "updated"}


# @clinto_router.put('/filtermedicines')
# async def filter_medicines(data: GET_Medicine = Body(...)):
#     await medicine_view.filter(**data.dict(exclude_unset=True))
#     return {"success": "updated"}
T = TypeVar("T")

class CustomPage(AbstractPage[T], Generic[T]):
    results: Sequence[T]
    total : int
    page: conint(ge=1)  # type: ignore
    size: conint(ge=1)     
    previous: Optional[bool] = False
    next: Optional[bool] = False
    __params_type__ = Params  # Set params related to Page

    @classmethod
    def create(
            cls,
            items: Sequence[T],
            total: int,
            params: AbstractParams,
            previous: Optional[bool]= False,
            next: Optional[bool]=False,
    ) -> Page[T]:
        return cls(results=items, total=total,page=params.page,size=params.size)
    
    

