#!./parrot
# Copyright (C) 2010, Parrot Foundation.

=head1 NAME

t/dynoplibs/bit.t - Bitwise Dynops

=head1 SYNOPSIS

        % prove t/dynoplibs/bit.t

=head1 DESCRIPTION

Tests basic arithmetic on various combinations of Parrot integer and
number types.

=cut

.loadlib 'bit_ops'

.sub main :main
    .include 'test_more.pir'

    plan(112)

    bnot_p_p_creates_destination()
    band_1()
    bands_null_string()
    bands_2()
    bands_3()
    bands_4()
    bands_cow()
    bor_1()
    bors_null_string()
    bors_2()
    bors_3()
    bors_cow()
    shl_1()
    bxor_1()
    bxors_null_string()
    bxors_2()
    bxors_3()
    bxors_cow()
    bnots_null_string()
    bnots_2()
    bnots_cow()
    # END_OF_TESTS

.end

.sub 'bnot_p_p_creates_destination'
    $P0 = box 3
    $P1 = bnot $P0
    is( $P1, -4, 'bnot_p_p_creates_destination' )
.end

.sub band_1
    $P0 = new['Integer']
    $P0 = 3
    $I0 = 8
    band $P0, $I0
    is( $P0, 0, 'band_p_i' )
    is( $I0, 8, 'band_p_i' )

    $P0 = 3
    band $P0, 8
    is( $P0, 0, 'band_p_ic' )

    $P0 = 3
    $P1 = new ['Integer']
    $P1 = 1
    band $P0, $P1
    is( $P0, 1, 'band_p_p' )
    is( $P1, 1, 'band_p_p' )

    $I0 = 3
    band $P0, $P0, $I0
    is( $P0, 1, 'band_p_p_i' )
    is( $I0, 3, 'band_p_p_i' )

    band $P0, $P0, 3
    is( $P0, 1, 'band_p_p_ic' )

    $P0 = 4
    $P1 = 3
    $P2 = new ['Integer']
    band $P2, $P0, $P1
    is( $P0, 4, 'band_p_p_p' )
    is( $P1, 3, 'band_p_p_p' )
    is( $P2, 0, 'band_p_p_p' )
.end

.sub bands_null_string
    null $S1
    set $S2, "abc"
    $S1 = bands $S1, $S2
    null $S3
    is( $S1, $S3, 'ok1' )

    set $S1, ""
    $S1 = bands $S1, $S2
    nok( $S1, 'ok2' )

    null $S2
    set $S1, "abc"
    $S1 = bands $S1, $S2
    null $S3
    is( $S1, $S3, 'ok3' )

    set $S2, ""
    $S1 = bands $S1, $S2
    nok( $S1, 'ok4' )
.end

.sub bands_2
    set $S1, "abc"
    set $S2, "EE"
    $S1 = bands $S1, $S2
    is( $S1, "A@", 'bands 2' )
    is( $S2, "EE", 'bands 2' )

    $S1 = bands "abc", $S2
    is( $S1, "A@", 'bands 2' )

    $S2 = bands "abc", "EE"
    is( $S2, "A@", 'bands 2' )
.end

.sub bands_3
    set $S1, "abc"
    set $S2, "EE"
    bands $S0, $S1, $S2
    is( $S0, "A@", 'bands 3' )
    is( $S1, "abc", 'bands 3' )
    is( $S2, "EE", 'bands 3' )
.end

.sub bands_4
    $P0 = box "abc"
    $P1 = new ['String']
    $S0 = "EE"
    bands $P1, $P0, $S0
    is( $P1, "A@", 'bands 4' )
    is( $P0, "abc", 'bands 4' )
    is( $S0, "EE", 'bands 4' )

    $P1 = bands $P0, "EE"
    is( $P1, "A@", 'bands 4' )
    is( $P0, "abc", 'bands 4' )

    $P0 = box "abc"
    $S0 = "EE"
    bands $P0, $S0
    is( $P0, "A@", 'bands 4' )
    is( $S0, "EE", 'bands 4' )

    $P0 = box "abc"
    bands $P0, "EE"
    is( $P0, "A@", 'bands 4' )
.end

.sub bands_cow
    set $S1, "foo"
    substr $S2, $S1, 0, 3
    $S1 = bands $S1, "bar"
    is( $S2, "foo", 'bands COW' )
.end

.sub bor_1
    $P0 = new ['Integer']
    $P1 = clone $P0
    $P0 = 4
    $P1 = 3
    bor $P0, $P1
    is( $P0, 7, 'bor_p_p' )
    is( $P1, 3, 'bor_p_p' )

    $P0 = 1
    $I0 = 3
    $P1 = new ['Integer']
    bor $P1, $P0, $I0
    is( $P0, 1, 'bor_p_p_i' )
    is( $I0, 3, 'bor_p_p_i' )
    is( $P1, 3, 'bor_p_p_i' )

    $P0 = 1
    $P1 = new ['Integer']
    bor $P1, $P0, 2
    is( $P0, 1, 'bor_p_p_ic' )
    is( $P1, 3, 'bor_p_p_ic' )

    $P0 = 1
    $P1 = new ['Integer']
    $P1 = 2
    $P2 = new ['Integer']
    bor $P2, $P0, $P1
    is( $P0, 1, 'bor_p_p_p' )
    is( $P1, 2, 'bor_p_p_p' )
    is( $P2, 3, 'bor_p_p_p' )
.end

.sub bors_null_string
    null $S1
    null $S2
    $S1 = bors $S1, $S2
    null $S3
    is( $S1, $S3, 'bors NULL string' )

    null $S1
    set $S2, ""
    $S1 = bors $S1, $S2
    null $S3
    is( $S1, $S3, 'bors NULL string' )

    $S2 = bors $S2, $S1
    is( $S2, $S3, 'bors NULL string' )

    null $S1
    set $S2, "def"
    $S1 = bors $S1, $S2
    is( $S1, "def", 'bors NULL string' )

    null $S2
    $S1 = bors $S1, $S2
    is( $S1, "def", 'bors NULL string' )

    null $S1
    null $S2
    bors $S3, $S1, $S2
    null $S4
    is( $S3, $S4, 'bors NULL string' )

    set $S1, ""
    bors $S3, $S1, $S2
    is( $S3, $S4, 'bors NULL string' )

    bors $S3, $S2, $S1
    is( $S3, $S4, 'bors NULL string' )

    set $S1, "def"
    bors $S3, $S1, $S2
    is( $S3, "def", 'bors NULL string' )

    bors $S3, $S2, $S1
    is( $S3, "def", 'bors NULL string' )
.end

.sub bors_2
    set $S1, "abc"
    set $S2, "EE"
    $S1 = bors $S1, $S2
    is( $S1, "egc", 'bors 2' )
    is( $S2, "EE", 'bors 2' )

    $P0 = box "abc"
    bors $P0, $S2
    is( $P0, "egc", 'bors_p_s' )
    is( $S2, "EE", 'bors_p_s' )

    $P0 = box "abc"
    bors $P0, "EE"
    is( $P0, "egc", 'bors_p_sc' )
.end

.sub bors_3
    set $S1, "abc"
    set $S2, "EE"
    bors $S0, $S1, $S2
    is( $S0, "egc", 'bors 3' )
    is( $S1, "abc", 'bors 3' )
    is( $S2, "EE", 'bors 3' )

    set $S0, "abc"
    bors $S0, "EE", $S0
    is( $S0, "egc", 'bors_s_sc_s' )

    bors $S0, "abc", "EE"
    is( $S0, "egc", 'bors_s_sc_sc' )

    new $P0, ['String']
    box $P1, "abc"
    set $S0, "EE"
    bors $P0, $P1, $S0
    is( $P0, "egc", 'bors_p_p_s' )
    is( $P1, "abc", 'bors_p_p_s' )
    is( $S0, "EE", 'bors_p_p_s' )

    set $P0, ""
    box $P1, "abc"
    bors $P0, $P1, "EE"
    is( $P0, "egc", 'bors_p_p_sc' )
    is( $P1, "abc", 'bors_p_p_sc' )
.end

.sub bors_cow
    set $S1, "foo"
    substr $S2, $S1, 0, 3
    $S1 = bors $S1, "bar"
    is( $S2, "foo", 'bors COW' )
.end

.sub shl_1
    $P0 = new ['Integer']
    $P0 = 1
    $I0 = 1
    shl $P0, $I0
    is( $P0, 2, 'shl_p_i' )
.end

.sub bxor_1
    $P0 = box 3
    $I0 = 3
    bxor $P0, $I0
    is( $P0, 0, 'bxor_p_i' )

    $P0 = box 3
    bxor $P0, 3
    is( $P0, 0, 'bxor_p_ic' )

    $P0 = box 3
    bxor $P0, $P0
    is( $P0, 0, 'bxor_p_p' )

    $P0 = box 3
    bxor $P0, $P0, $I0
    is( $P0, 0, 'bxor_p_p_i' )

    $P0 = box 3
    bxor $P0, $P0, 3
    is( $P0, 0, 'bxor_p_p_ic' )

    $P0 = box 3
    bxor $P0, $P0, $P0
    is( $P0, 0, 'bxor_p_p_p' )
.end

.sub bxors_null_string
    null $S1
    null $S2
    $S1 = bxors $S1, $S2
    null $S3
    is( $S1, $S3, 'bxors NULL string' )

    null $S1
    set $S2, ""
    $S1 = bxors $S1, $S2
    null $S3
    is( $S1, $S3, 'bxors NULL string' )

    $S2 = bxors $S2, $S1
    is( $S2, $S3, 'bxors NULL string' )

    null $S1
    set $S2, "abc"
    $S1 = bxors $S1, $S2
    is( $S1, "abc", 'bxors NULL string' )

    null $S2
    $S1 = bxors $S1, $S2
    is( $S1, "abc", 'bxors NULL string' )

    null $S1
    null $S2
    bxors $S3, $S1, $S2
    null $S4
    is( $S3, $S4, 'bxors NULL string' )

    set $S1, ""
    bxors $S3, $S1, $S2
    is( $S3, $S4, 'bxors NULL string' )

    bxors $S3, $S2, $S1
    is( $S3, $S4, 'bxors NULL string' )

    set $S1, "abc"
    bxors $S3, $S1, $S2
    is( $S3, "abc", 'bxors NULL string' )

    bxors $S3, $S2, $S1
    is( $S3, "abc", 'bxors NULL string' )
.end

.sub bxors_2
    set $S1, "a2c"
    set $S2, "Dw"
    $S1 = bxors $S1, $S2
    is( $S1, "%Ec", 'bxors 2' )
    is( $S2, "Dw", 'bxors 2' )

    set $S1, "abc"
    set $S2, "   X"
    $S1 = bxors $S1, $S2
    is( $S1, "ABCX", 'bxors 2' )
    is( $S2, "   X", 'bxors 2' )

    box $P0, "a2c"
    set $S0, "Dw"
    bxors $P0, $S0
    is( $P0, "%Ec", 'bxors 2' )
    is( $S0, "Dw", 'bxors 2' )

    box $P0, "a2c"
    bxors $P0, "Dw"
    is( $P0, "%Ec", 'bxors 2' )
.end

.sub bxors_3
    set $S1, "a2c"
    set $S2, "Dw"
    bxors $S0, $S1, $S2
    is( $S0, "%Ec", 'bxors 3' )
    is( $S1, "a2c", 'bxors 3' )
    is( $S2, "Dw", 'bxors 3' )

    set $S1, "abc"
    set $S2, "   Y"
    bxors $S0, $S1, $S2
    is( $S0, "ABCY", 'bxors 3' )
    is( $S1, "abc", 'bxors 3' )
    is( $S2, "   Y", 'bxors 3' )

    set $S0, "abc"
    bxors $S0, "   Y", $S0
    is( $S0, "ABCY", 'bxors 3' )

    bxors $S0, "abc", "   Y"
    is( $S0, "ABCY", 'bxors 3' )

    box $P0, "abc"
    set $S0, "   Y"
    bxors $P0, $P0, $S0
    is( $P0, "ABCY", 'bxors 3' )
    is( $S0, "   Y", 'bxors 3' )

    box $P0, "abc"
    bxors $P0, $P0, "   Y"
    is( $P0, "ABCY", 'bxors 3' )
.end

.sub bxors_cow
    set $S1, "foo"
    substr $S2, $S1, 0, 3
    $S1 = bxors $S1, "bar"
    is( $S2, "foo", 'bxors COW' )
.end

.sub bnots_null_string
    null $S1
    null $S2
    bnots $S1, $S2
    null $S3
    is( $S1, $S3, 'bnots NULL string' )

    null $S1
    set $S2, ""
    bnots $S1, $S2
    null $S3
    is( $S1, $S3, 'bnots NULL string' )

    bnots $S2, $S1
    is( $S2, $S3, 'bnots NULL string' )
.end

# This was the previous test used for t/native_pbc/string.t
.sub bnots_2
    skip( 4, "No unicode yet" )
    # getstdout $P0
    # push $P0, "utf8"
    # set $S1, "a2c"
    # bnots $S2, $S1
    # is( $S1, "a2c", 'bnots 2' )
    # is( $S2, "\xC2\x9E\xC3\x8D\xC2\x9C", 'bnots 2' )
    #
    # bnots $S1, $S1
    # is( $S1, "\xC2\x9E\xC3\x8D\xC2\x9C", 'bnots 2' )
    #
    # bnots $S1, $S1
    # is( $S1, "a2c", 'bnots 2' )
.end

.sub bnots_cow
    set $S1, "foo"
    substr $S2, $S1, 0, 3
    bnots $S1, $S1
    is( $S2, "foo", 'bnots COW' )
.end

# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:
