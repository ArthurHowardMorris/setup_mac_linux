* run this as follows:
* `stata-mp < setup_stata.do > setup_stata.log` add & to run in background
* this file simply installs from ssc as needed. more functionality to come

* reghdfe v6
* Install ftools
cap ado uninstall ftools
net install ftools, from("https://raw.githubusercontent.com/sergiocorreia/ftools/master/src/")
* Install reghdfe 6.x
cap ado uninstall reghdfe
net install reghdfe, from("https://raw.githubusercontent.com/sergiocorreia/reghdfe/master/src/")
cap ado uninstall ivreghdfe
cap ssc install ivreg2 // Install ivreg2, the core package
net install ivreghdfe, from("https://raw.githubusercontent.com/sergiocorreia/ivreghdfe/master/src/")
* Install ppmlhdfe
cap ado uninstall ppmlhdfe
net install ppmlhdfe, from("https://raw.githubusercontent.com/sergiocorreia/ppmlhdfe/master/src/")
* Create compiled files
ftools, compile
// reghdfe, compile

* Check versions
ppmlhdfe, version

* stuff from benjann
* https://repec.sowi.unibe.ch/stata/index.html
ssc install estout
ssc install coefplot
ssc install texdoc
ssc install erepost
* graph styles from grstyle
net install grstyle, replace from(https://raw.githubusercontent.com/benjann/grstyle/master/)
net install palettes, replace from(https://raw.githubusercontent.com/benjann/palettes/master/)
net install colrspace, replace from(https://raw.githubusercontent.com/benjann/colrspace/master/)


ssc install distinct
net install cowsay, from(https://raw.githubusercontent.com/mdroste/stata-cowsay/master/)

ado update, update all
