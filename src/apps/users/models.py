from tortoise import fields, models, Tortoise ,run_async
from tortoise.contrib.pydantic import pydantic_model_creator
from enum import Enum, IntEnum
from typing import List
from tortoise.exceptions import NoValuesFetched

class Roles(str,Enum):
    Doctor = "Doctor"
    Patient = "Patient"
    Recoponist = "Recoponist"
    PharmacyOwner = "PharmacyOwner"
    LabOwner = "LabOwner"


class PermissionLevel(str, Enum):
    Admin = "Admin"
    Emp = "Emp"
    LowPermissions = "LowPermissions"
class Permissions(models.Model):
    app_name = fields.CharField(max_length=500, unique=True)
    created = fields.DatetimeField(auto_now_add=True)
    permission_level: PermissionLevel = fields.CharEnumField(
        PermissionLevel, default=PermissionLevel.Admin)
    updated = fields.DatetimeField(auto_now=True)
    permissions: fields.ReverseRelation["User"]
class User(models.Model):
    """ Model user """
    username = fields.CharField(max_length=100, unique=True)
    email = fields.CharField(max_length=100, unique=True,null=True,blank=True)
    permissions: fields.ManyToManyRelation["Permissions"] = fields.ManyToManyField(
        "models.Permissions", related_name="permissions", through="user_permissions"
    )
    mobile = fields.CharField(max_length=15,null=True,blank=True)
    roles: Roles = fields.CharEnumField(Roles, default=Roles.Patient)
    password = fields.CharField(max_length=100)
    first_name = fields.CharField(max_length=100,default="")
    last_name = fields.CharField(max_length=100, null=True,default="")
    date_join = fields.DatetimeField(auto_now_add=True)
    last_login = fields.DatetimeField(null=True)
    is_active = fields.BooleanField(default=True)
    is_staff = fields.BooleanField(default=False)
    currently_active = fields.BooleanField(default=False)
    is_superuser = fields.BooleanField(default=False)
    avatar = fields.CharField(max_length=1000, null=True)
    # social_accounts: fields.ReverseRelation['SocialAccount']
    def full_name(self) -> str:
        return self.first_name + self.last_name
    class PydanticMeta:
        computed = ["full_name"]
        exclude = ('full_name')


User_Pydantic = pydantic_model_creator(User, name="User", exclude=[
                                       'id', 'date_join', 'is_superuser', 'is_active','is_staff'])
Users_Pydantic = pydantic_model_creator(User,name="UserCreate",exclude_readonly=True,exclude=['id'])
UserIn_Pydantic = pydantic_model_creator(
    User, name="UserIn", exclude_readonly=True)


    


