from uuid import UUID
from pydantic import BaseModel
from typing import List, Optional


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
    


