@echo off
mawk -f csv2textile.mawk keywords/and.csv >> keywords/and.textile
