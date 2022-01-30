#!/usr/bin/env python
# coding: utf-8

# # Load Modules

# In[1]:


import pandas as pd
import pandas as np
import statsmodels.api as sm
import matplotlib.pyplot as plt


# # ApparelCPI

# ### Load Data

# In[2]:


df_01=pd.read_csv('./data/ApparelCPI.csv')
df_01['Date']=pd.to_datetime(df_01['Date'], format='%m/%d/%Y')
df_01=df_01.set_index(['Date'])
df_01.head()


# ## MODEL USING X13 SEATS

# ### Order 

# In[3]:


res = sm.tsa.x13_arima_select_order(df_01,x12path='./x13as/')
print(res.order, res.sorder)


# ### ARIMA analysis

# In[4]:


analysis = sm.tsa.x13_arima_analysis(df_01,x12path='./x13as/')
fig = analysis.plot()
fig.set_size_inches(10, 5)
plt.tight_layout()


# ### Seasonal Adjusted to csv file

# In[5]:


analysis.seasadj.to_csv('apparelCPISA2020.csv')
analysis.seasadj.head()


# ### Seasonal Factor

# In[6]:


seasonalFactor=pd.Series(analysis.observed['ApparelCPI']).div(analysis.seasadj)
seasonalFactor.head()


# In[7]:


seasonalFactor.plot()


# # ApparelCPI 2021

# In[8]:


df_02=pd.read_csv('./data/ApparelCPI2021.csv')
df_02['Date']=pd.to_datetime(df_02['Date'], format='%m/%d/%Y')
df_02=df_02.set_index(['Date'])
df_02.head()


# ## MODEL USING X13 SEATS

# ### Order 

# In[9]:


res = sm.tsa.x13_arima_select_order(df_02,x12path='./x13as/')
print(res.order, res.sorder)


# ### ARIMA analysis

# In[10]:


analysis = sm.tsa.x13_arima_analysis(df_02,x12path='./x13as/')
fig = analysis.plot()
fig.set_size_inches(10, 5)
plt.tight_layout()


# ### Seasonal Adjusted to csv file

# In[11]:


analysis.seasadj.to_csv('ApparelCPISA2021.csv')
analysis.seasadj.head()


# ### Seasonal Factor

# In[12]:


seasonalFactor=pd.Series(analysis.observed['ApparelCPI']).div(analysis.seasadj)
seasonalFactor.head()


# In[13]:


seasonalFactor.plot()

