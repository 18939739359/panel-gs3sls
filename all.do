use "C:\Users\thinkpad\Desktop\金融\城市经纬度.dta",clear
rename city city0
rename code code0
rename jingdu jingdu0
rename weidu weidu0
cross using "C:\Users\thinkpad\Desktop\金融\城市经纬度.dta"
geodist weidu0 jingdu0 weidu jingdu,gen(d)
drop city0 weidu0 jingdu0 city weidu jingdu
reshape wide d ,i(code) j(code0)

use "C:\Users\thinkpad\Desktop\金融\w100.dta",clear
spcs2xt 北京市-克拉玛依市, time(5) matrix(W1002)
spcs2xt 北京市-克拉玛依市,time(5) matrix(w150)
spcs2xt 北京市-克拉玛依市,time(5) matrix(w200)
spcs2xt 北京市-克拉玛依市,time(5) matrix(w250)
spcs2xt 北京市-克拉玛依市,time(5) matrix(w300)
spcs2xt 北京市-克拉玛依市,time(5) matrix(w)
use "C:\Users\thinkpad\Desktop\金融\wxt.dta",clear
spmat dta wxt v1-v1440,normalize(row)
spmat save wxt using wxt.spmat
spmat use wxt using wxt.spmat 
spmat use wxt using wxt.spmat,replace
spmat export wxt using wxt.txt

use "C:\Users\thinkpad\Desktop\金融\回归数据集.dta",clear
spatwmat using "C:\Users\thinkpad\Desktop\金融\城市距离权重矩阵.dta",name(W) standardize
gen lnqws2018=ln(qws2018/a2018)
gen lnqws2009=ln(qws2009/a2009)
spatgsa lnqws2018, weights(W) moran  twotail
spatlsa lnqws2018 ,weight(W) moran id(city) graph(moran) symbol(id) twotail
spatgsa lnqws2009, weights(W) moran  twotail
spatlsa lnqws2009 ,weight(W) moran id(city) graph(moran) symbol(id) twotail
drop code 
drop city
reshape long fdi intn labor pop stu th_ind k qws gdp a,i(t) j(year)
gen lnqws=ln(qws/a)
gen lngdp=ln(gdp/a)
gen lnk=ln(k/a)
gen lnl=ln(labor/a)
gen lnth=ln(th_ind/100/a)
gen lnintn=ln(intn/pop/a)
gen lnfdi=ln(fdi/gdp/a)
gen lnstu=ln(stu/pop/a)
xtgcause lngdp lnqws
xtgcause lnqws lngdp
gen fdii=fdi/gdp
gen stuu=stu/pop
gen intnn=intn/pop
sum gdp a k labor stuu qws fdii th_ind intnn
xsmle lnqws lngdp lnk lnl lnth lnintn lnfdi lnstu ,wmat(W) model(sar)
est sto sar
xsmle lnqws lngdp lnk lnl lnth lnintn lnfdi lnstu ,emat(W) model(sem)
est sto sar
xsmle lnqws lngdp lnk lnl lnth lnintn lnfdi lnstu ,wmat(W) model(sem)
est sto sdm
lrtest sar sdm
lrtest sem sdm



use "C:\Users\thinkpad\Desktop\金融\回归数据集3.dta",clear
spatwmat using "C:\Users\thinkpad\Desktop\金融\城市距离权重矩阵.dta",name(W) standardize
spatgsa qws2018, weights(W) moran  twotail
spatlsa qws2018 ,weight(W) moran id(city) graph (moran)
spatlsa lnqws2018 ,weight(W) moran id(city) graph (moran) symbol(id)
drop code 
drop city
reshape long fdi intn labor pop stu th_ind k qws gdp a,i(t) j(year)
tab t ,gen(x)
tab year ,gen(z)
gen lnqws=ln(qws/a)
gen lngdp=ln(gdp/a)
gen lnk=ln(k/a)
gen lnl=ln(labor/a)
gen lnth=ln(th_ind/100/a)
gen lnintn=ln(intn/pop/a)
gen lnfdi=ln(fdi/gdp/a)
gen lnstu=ln(stu/pop/a)
xtset t year

gs3sls lngdp lnk lnl lnstu z1 z2 z3 z4, wmfile(W1002xt) var2(lnqws lnintn lnfdi lnth z1 z2 z3 z4)
gs3sls lngdp lnk lnl lnstu, wmfile(w1xt) var2(lnqws lnintn lnfdi lnth) stand aux(x1-x287 z1-z4)
gs3sls lngdp lnk lnl lnstu, wmfile(w1002xt) var2(lnqws lnintn lnfdi lnth) aux(x1-x287 z1-z4)
shp2dta using "C:\Users\thinkpad\Desktop\全国地级城市矢量地图\STATE_poly".data(data1) coordinates(data2) genid(ADCODE99)
use "C:\Users\thinkpad\Desktop\金融\data1.dta",clear
gen lnqws2018=ln(qws2018/a2018)
gen lnqws2009=ln(qws2009/a2009)
spmap lnqws2009 using "C:\Users\thinkpad\Desktop\金融\data2.dta",id(id) fcolor(Reds2)
spmap lnqws2018 using "C:\Users\thinkpad\Desktop\金融\data2.dta",id(id) fcolor(Reds2)
spmap lnqws2009 using "C:\Users\thinkpad\Desktop\金融\data2.dta",id(id) fcolor(Reds2) label(label(city)xcoord(CENTROID_X) ycoord(CENTROID_Y)size(*.5))

