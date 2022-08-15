@echo off
@echo ========================================================
@echo commit git
@echo ========================================================

git add . && git commit -am 'update' && git push
pause