
using XKPasswd

import Test: @testset, @test
import Random: seed!

seed!(0)

@testset "XKPasswd.jl" begin
    @test XKPasswd.pwentropy(4, 2048, false) == 44.0
    @test XKPasswd.generate(4) == ["match against educator course"]
    @test XKPasswd.generate(4)[1] == "mankind value nature prize" 
    @test XKPasswd.generate(8,npws=7,capitalize=true,delimstr="-")[3] == "Miss-Wet-Narrow-Forgive-Saw-Furnish-Inquire-Doctor"
    @test XKPasswd.generate(6, joinpath(dirname(@__FILE__), "..", "data", "jargon.txt"), append_digit=false) == ["tweaked iconify overrun baaaaaaz teitelman ghostjob"]
    @test XKPasswd.generate(4, XKPasswd.google_10k_clean)[1] == "lebanon directors merchant ports"
end
