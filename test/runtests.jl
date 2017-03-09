using xkpasswd
using Base.Test

srand(0)

@test xkpasswd.generate(4) == ["ups flux photos bits 4"]
@test xkpasswd.generate(4)[1] == "economies centers dresses history 8"
@test xkpasswd.generate(8,npws=7,capitalize=true,delimstr="-")[3] == "Reservations-Construct-Conferencing-Hundred-Rx-Gd-Inside-Payroll-8"


