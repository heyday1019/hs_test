# -*- coding:utf-8 -*-

import streamlit as st 
import pandas as pd 
import matplotlib.pyplot as plt 
import seaborn as sns 
import plotly 
import numpy as np 
import matplotlib as mpl

@st.cache_data
def get_data():
    # data = pd.read_csv("train.csv") / size가 크면 streamlit에서 배포 안됨
    data = sns.load_dataset("tips")
    return data

def main():
    price = st.slider("단가:", 1000, 10000, value = 5000)
    total_sales = st.slider("전체 판매 갯수:", 1, 1000, value = 500) 

    if st.button("매출액 계산"):
        revenue = price * total_sales
        st.write(f"전체매출액 : {revenue}")

    tips = get_data()
    st.dataframe(tips)

    show_plot = st.checkbox("시각화를 보여줄까요?")

    tip_max = tips['tip'].max() # tip의 최대
    tip_min = tips['tip'].min() # tip의 min
    tip = st.slider("tip의 입력값", tip_min, tip_max)
    # tips2 = tips.loc[tips['tip'] >= tip, :]
    option = st.selectbox(
    "요일을 선택하세요",
    ( "Sun", "Mon", "Tue", "Wed", "Thur", "Fri","Sat"))
    st.write(option, tip)
    tips2 = tips.loc[(tips['day'] == option) | (tips['tip'] >= tip), :]
    import plotly.express as px 
    fig = px.scatter(data_frame = tips2, x = "total_bill", y = "tip")
    st.plotly_chart(fig)

    if show_plot:

        fig, ax = plt.subplots()
        ax.set_title("Hello World")
        st.pyplot(fig)
    




if __name__ == "__main__":
    main()







