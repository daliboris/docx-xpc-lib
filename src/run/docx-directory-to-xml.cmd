@echo off
chcp 65001
Morgana.bat ^
-config=./config.xml ^
./docx-directory-to-xml.xpl ^
-option:input-directory-path=../tests/input ^
-option:output-directory-path=../tests/output/batch ^
-option:clean-markup=true ^
-option:keep-direct-formatting=true ^
-option:debug-path=..\tests\_debug\batch
 