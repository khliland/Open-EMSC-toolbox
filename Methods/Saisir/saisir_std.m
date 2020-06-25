function[st]=saisir_std(saisir)
%saisir_std  			- computes the standard_deviations of the columns, following the saisir format
%function[st]=saisir_std(saisir)

st.d=std(saisir.d);
st.v=saisir.v;
st.i='standard deviation';

