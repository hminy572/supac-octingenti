# Supac

---
**Supac is simple crm. With Supac, you can use it to manage business data easily.**
**Supac has Sup context which enable you to modify all the data in Supac, more specifically you can create, edit, update and delete data in Lead, Contact, Company, Appointment, Task and Product schema.**

---

# Mix Task for Sup Context

## Lead
### Mix Task
mix phx.gen.live Sup Lead leads name email com_name state position size url deleted_at:datetime
  
### Columns
- name 
- email 
- com_name 
- state 
- position 
- size 
- url 
- deleted_at:datetime

## Com
### Mix Task
mix phx.gen.live Sup Com coms name email url size deleted_at:datetime

### Columns
- name 
- email 
- url 
- size 
- deleted_at:datetime

## Prod
### Mix Task
mix phx.gen.live Sup Prod prods name price:integer deleted_at:datetime

### Columns
- name 
- price:integer 
- deleted_at:datetime

## Task
### Mix Task
mix phx.gen.live Sup Task tasks name due_date:date person_in_charge content:text priority deleted_at:datetime com_id:references:coms
  
### Columns
- name 
- due_date:date
- person_in_charge 
- content:text 
- priority 
- deleted_at:datetime 
- com_id:references:coms

## Con
### Mix Task
mix phx.gen.live Sup Con cons name email position deleted_at:datetime com_id:references:coms
  
### Columns
- name 
- email 
- position 
- deleted_at:datetime
- com_id:references:coms

## Appo
### Mix Task
mix phx.gen.live Sup Appo appos name state amount:integer probability:float description:text is_client:boolean date:date person_in_charge deleted_at:datetime com_id:references:coms prod_id:references:prods
  
### Columns 
- name 
- state 
- amount:integer 
- probability:float
- description:text 
- is_client:boolean 
- date:date 
- person_in_charge 
- deleted_at:datetime
- com_id:references:coms
- prod_id:references:prods

---

**Supac also has History (or His for short) Context, which enable you to save all updates for Sup context in a table**

---

# Mix Task for History Context

mix phx.gen.live His Upd upds update:map

