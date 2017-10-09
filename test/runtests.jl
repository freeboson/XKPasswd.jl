
using XKPasswd
using Base.Test

srand(0)

@test XKPasswd.pwentropy(4, 2048, false) == 44.0
@test XKPasswd.generate(4) == ["simple curtain forgive society"]
@test XKPasswd.generate(4)[1] == "stay we besides someone"
@test XKPasswd.generate(8,npws=7,capitalize=true,delimstr="-")[3] == "Complete-Thread-Photograph-Everywhere-Steep-Paste-Over-Bag"
@test XKPasswd.generate(6, joinpath(dirname(@__FILE__), "..", "data", "jargon.txt"), append_digit=false) == ["welldesigned trigger tales decades historically listed"]
@test XKPasswd.generate(4, XKPasswd.google_10k_clean)[1] == "preventing feelings paying disorder"
