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
from typing import List, Optional
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
dunzo_router = APIRouter(dependencies=[Depends(get_current_login)])




