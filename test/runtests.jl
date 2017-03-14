
using xkpasswd
using Base.Test

srand(0);

@test xkpasswd.pwentropy(4, 2048, false) == 44.0
@test xkpasswd.generate(4) == ["simple curtain forgive society 4"]
@test xkpasswd.generate(4)[1] == "we besides someone iron 8"
@test xkpasswd.generate(8,npws=7,capitalize=true,delimstr="-")[3] == "Steep-Paste-Over-Bag-Wall-Flag-Scatter-Theater-8"
@test xkpasswd.generate(6, joinpath(dirname(@__FILE__), "..", "data", "jargon.txt"), append_digit=false) == ["robots notesfiles listener overflowed reflects dissemination"]
@test xkpasswd.generate(4, xkpasswd.google_10k_clean)[1] == "disturbed saver palm sapphire 7"

