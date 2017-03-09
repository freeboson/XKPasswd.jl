using xkpasswd
using Base.Test

srand(0)

@test xkpasswd.generate(4) == ["ups flux photos bits 4"]
