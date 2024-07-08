# -*- coding:utf-8 -*-

import streamlit as st 
import pandas as pd 
import matplotlib.pyplot as plt 
import seaborn as sns 
import plotly 
import numpy as np 
import matplotlib as mpl
import streamlit.components.v1 as components # JavaScript 개발용

@st.cache_data
def get_data():
    # data = pd.read_csv("train.csv") / size가 크면 streamlit에서 배포 안됨
    data = sns.load_dataset("tips")
    return data

def main():
    st.title("Hello Streamlit World!")
    st.write("streamlit version:", st.__version__)
    st.write("pandas version:", pd.__version__)

    tips = get_data()
    st.dataframe(tips, use_container_width = True)

    st.markdown("HTML CSS 마크다운 적용")
    html_css = """
    <style>
        table.customTable {
        width: 100%;
        background-color: #FFFFFF;
        border-collapse: collapse;
        border-width: 2px;
        border-color: #7ea8f8;
        border-style: solid;
        color: #000000;
        }
    </style>

    <table class="customTable">
      <thead>
        <tr>
          <th>이름</th>
          <th>나이</th>
          <th>직업</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td>Evan</td>
          <td>25</td>
          <td>데이터 분석가</td>
        </tr>
        <tr>
          <td>Sara</td>
          <td>25</td>
          <td>프로덕트 오너</td>
        </tr>
      </tbody>
    </table>
    """

    st.markdown(html_css, unsafe_allow_html=True)


    st.markdown("HTML JS Streamlit 적용")
    js_code = """ 
    <h3>Hi</h3>

    <script>
    function sayHello() {
        alert('Hello from JavaScript in Streamlit Web');
    }
    </script>

    <button onclick="sayHello()">Click me</button>
    """
    components.html(js_code)

    tip_max = tips['tip'].max()
    tip_min = tips['tip'].min()

    st.metric(label = "Tip 최대값", value = tip_max)
    st.metric(label = "Tip 최소값", value = tip_min)

    # matplotlib & seaborn
    fig, ax = plt.subplots()
    ax.set_title("Hello World!")
    sns.set_theme(style="ticks")

    # Load the penguins dataset
    penguins = sns.load_dataset("penguins")

# Show the joint distribution using kernel density estimation
    fig = sns.jointplot(
        data=penguins,
        x="bill_length_mm", y="bill_depth_mm", hue="species",
        kind="kde",
    )


    st.pyplot(fig) # plt.show()

if __name__ == "__main__":
    main()
 