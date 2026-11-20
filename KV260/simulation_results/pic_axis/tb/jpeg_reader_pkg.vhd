-- Simulation-only baseline JPEG reader. No foreign calls or preconverted pixels.
-- Reads 8-bit one-scan grayscale or JFIF YCbCr, including 4:4:4, 4:2:2 and 4:2:0.
library ieee;
use ieee.math_real.all;
use work.pic2_types.all;

package jpeg_reader_pkg is
  type frame_t is array (natural range <>) of pixel_t;
  type frame_ptr is access frame_t;
  procedure read_jpeg(path : in string; variable frame : out frame_ptr;
                      variable width, height : out natural);
end package;

package body jpeg_reader_pkg is
  type binary_file_t is file of character;
  type ints64_t is array (0 to 63) of integer;
  type ints16_t is array (1 to 16) of integer;
  type bytes256_t is array (0 to 255) of byte_t;
  type quant_tables_t is array (0 to 3) of ints64_t;
  type huff_t is record
    first_code, last_code, first_sym : ints16_t;
    symbol : bytes256_t;
  end record;
  type huff_tables_t is array (0 to 7) of huff_t; -- DC 0:3, AC 4:7
  type samples_t is array (natural range <>) of byte_t;
  type sample_ptr is access samples_t;
  type plane_t is record
    id, hs, vs, tq, dc, ac : natural;
    stride, cols, rows : natural;
    predictor : integer;
    sample : sample_ptr;
  end record;
  type planes_t is array (0 to 2) of plane_t;
  type order_t is array (0 to 2) of natural range 0 to 2;
  type real_matrix_t is array (0 to 7, 0 to 7) of real;
  constant ZIGZAG : ints64_t := (
     0, 1, 8,16, 9, 2, 3,10,17,24,32,25,18,11, 4, 5,
    12,19,26,33,40,48,41,34,27,20,13, 6, 7,14,21,28,
    35,42,49,56,57,50,43,36,29,22,15,23,30,37,44,51,
    58,59,52,45,38,31,39,46,53,60,61,54,47,55,62,63);
  function idct_basis return real_matrix_t is
    variable m : real_matrix_t;
  begin
    for x in 0 to 7 loop
      m(x,0) := 0.5/sqrt(2.0);
      for k in 1 to 7 loop
        m(x,k) := 0.5*cos(real((2*x+1)*k)*MATH_PI/16.0);
      end loop;
    end loop;
    return m;
  end;
  constant BASIS : real_matrix_t := idct_basis;

  procedure read_jpeg(path : in string; variable frame : out frame_ptr;
                      variable width, height : out natural) is
    file source : binary_file_t open read_mode is path;
    variable file_pos, bits_left, reservoir : natural := 0;
    variable quant : quant_tables_t;
    variable huff : huff_tables_t;
    variable q_present : boolean_vector(0 to 3) := (others=>false);
    variable h_present : boolean_vector(0 to 7) := (others=>false);
    variable plane : planes_t;
    variable scan_order : order_t;
    variable ncomp, max_h, max_v, restart_interval : natural := 0;
    variable cols_mcu, rows_mcu, restart_number : natural := 0;
    variable tag, seg_len, stop_pos, selector, tbl, count, code, cursor : natural;
    variable scan_id, ci, dummy, yy, cb, cr : integer;
    variable counts : ints16_t;
    variable have_frame : boolean := false;
    variable rgb : rgb_t;

    impure function octet return natural is
      variable ch : character;
    begin
      assert not endfile(source) report "Truncated JPEG at byte " & integer'image(file_pos) severity failure;
      read(source,ch); file_pos := file_pos+1;
      return character'pos(ch);
    end;
    impure function be16 return natural is
      variable high : natural;
    begin
      high := octet;
      return high*256+octet;
    end;
    impure function marker return natural is
      variable v : natural;
    begin
      v := octet;
      assert v=255 report "Missing JPEG marker at byte " & integer'image(file_pos-1) severity failure;
      loop
        v := octet;
        exit when v/=255;
      end loop;
      return v;
    end;
    procedure expect_byte(value : natural; why : string) is
      variable actual : natural := octet;
    begin
      assert actual=value report why severity failure;
    end;
    procedure expect_marker(value : natural; why : string) is
      variable actual : natural := marker;
    begin
      assert actual=value report why severity failure;
    end;
    impure function next_bit return natural is
    begin
      if bits_left=0 then
        reservoir := octet;
        if reservoir=255 then
          expect_byte(0,"Unexpected JPEG marker in entropy data");
        end if;
        bits_left := 8;
      end if;
      bits_left := bits_left-1;
      return (reservoir/(2**bits_left)) mod 2;
    end;
    impure function huff_symbol(t : natural) return natural is
      variable v : integer := 0;
    begin
      for n in 1 to 16 loop
        v := 2*v+next_bit;
        if v>=huff(t).first_code(n) and v<=huff(t).last_code(n) then
          return huff(t).symbol(huff(t).first_sym(n)+v-huff(t).first_code(n));
        end if;
      end loop;
      assert false report "Invalid JPEG Huffman symbol" severity failure;
      return 0;
    end;
    impure function amplitude(n : natural) return integer is
      variable v : natural := 0;
    begin
      if n=0 then return 0; end if;
      for i in 1 to n loop v := 2*v+next_bit; end loop;
      if v < 2**(n-1) then return v+1-2**n; end if;
      return v;
    end;
    procedure decode_block(p, block_x, block_y : natural) is
      variable freq : ints64_t := (others=>0);
      variable temp : real_matrix_t;
      variable sym, n, k, idx, base : natural;
      variable acc : real;
      variable dc_only : boolean := true;
    begin
      n := huff_symbol(plane(p).dc);
      assert n<=11 report "Invalid baseline DC magnitude" severity failure;
      plane(p).predictor := plane(p).predictor+amplitude(n);
      freq(0) := plane(p).predictor*quant(plane(p).tq)(0);
      k := 1;
      while k<64 loop
        sym := huff_symbol(4+plane(p).ac);
        exit when sym=0;
        if sym=240 then
          k := k+16;
          assert k<=64 report "Invalid JPEG zero run" severity failure;
        else
          n := sym mod 16; k := k+(sym/16);
          assert n>=1 and n<=10 and k<64 report "Invalid JPEG AC run" severity failure;
          idx := ZIGZAG(k);
          freq(idx) := amplitude(n)*quant(plane(p).tq)(idx);
          dc_only := false; k := k+1;
        end if;
      end loop;
      base := block_y*8*plane(p).stride+block_x*8;
      if dc_only then
        for y in 0 to 7 loop
          for x in 0 to 7 loop
            plane(p).sample(base+y*plane(p).stride+x) := clamp(128+integer(real(freq(0))/8.0),0,255);
          end loop;
        end loop;
      else
        for v in 0 to 7 loop
          for x in 0 to 7 loop
            acc := 0.0;
            for u in 0 to 7 loop acc := acc + real(freq(8*v+u))*BASIS(x,u); end loop;
            temp(v,x) := acc;
          end loop;
        end loop;
        for y in 0 to 7 loop
          for x in 0 to 7 loop
            acc := 0.0;
            for v in 0 to 7 loop acc := acc+temp(v,x)*BASIS(y,v); end loop;
            plane(p).sample(base+y*plane(p).stride+x) := clamp(128+integer(acc),0,255);
          end loop;
        end loop;
      end if;
    end procedure;
    -- Centered linear chroma upsampling. At 2x, the two weights are 3/4 and 1/4.
    impure function sample_at(p,x,y : natural) return byte_t is
      variable sx, sy, nx, ny, wx, wy, dx, dy, stride : natural;
    begin
      dx := max_h/plane(p).hs; dy := max_v/plane(p).vs;
      sx := x/dx; sy := y/dy; nx := sx; ny := sy; wx := 0; wy := 0;
      if dx=2 then nx := clamp(integer(sx)+2*(x mod 2)-1,0,plane(p).cols-1); wx := 1; end if;
      if dy=2 then ny := clamp(integer(sy)+2*(y mod 2)-1,0,plane(p).rows-1); wy := 1; end if;
      stride := plane(p).stride;
      return ((4-wy)*((4-wx)*plane(p).sample(sy*stride+sx)+wx*plane(p).sample(sy*stride+nx))
             + wy*((4-wx)*plane(p).sample(ny*stride+sx)+wx*plane(p).sample(ny*stride+nx))+8)/16;
    end;
    function round_q16(v : integer) return integer is
    begin
      return (v+16777216+32768)/65536-256;
    end;
  begin
    expect_marker(16#D8#,"Input is not a JPEG");
    loop
      tag := marker;
      assert tag/=16#D9# report "JPEG ended before scan" severity failure;
      seg_len := be16;
      assert seg_len>=2 report "Invalid JPEG segment length" severity failure;
      stop_pos := file_pos+seg_len-2;
      case tag is
        when 16#DB# => -- Quantization tables in JPEG zigzag order.
          while file_pos<stop_pos loop
            selector := octet;
            assert selector<=3 report "Only 8-bit JPEG quantizers supported" severity failure;
            for i in 0 to 63 loop quant(selector)(ZIGZAG(i)) := octet; end loop;
            q_present(selector) := true;
          end loop;
        when 16#C4# =>
          while file_pos<stop_pos loop
            selector := octet; tbl := 4*(selector/16)+(selector mod 16);
            assert selector/16<=1 and selector mod 16<=3 report "Invalid Huffman table ID" severity failure;
            count := 0;
            for n in 1 to 16 loop counts(n) := octet; count := count+counts(n); end loop;
            assert count>=1 and count<=256 report "Invalid Huffman table length" severity failure;
            code := 0; cursor := 0;
            for n in 1 to 16 loop
              huff(tbl).first_code(n) := code;
              huff(tbl).last_code(n)  := integer(code)+counts(n)-1;
              huff(tbl).first_sym(n)  := cursor;
              cursor := cursor+counts(n); code := 2*(code+counts(n));
            end loop;
            for i in 0 to count-1 loop huff(tbl).symbol(i) := octet; end loop;
            h_present(tbl) := true;
          end loop;
        when 16#C0# =>
          expect_byte(8,"Only 8-bit baseline JPEG supported");
          height := be16; width := be16; ncomp := octet;
          assert width>0 and height>0 and (ncomp=1 or ncomp=3) report "Unsupported JPEG dimensions/components" severity failure;
          for p in 0 to ncomp-1 loop
            plane(p).id := octet; selector := octet;
            plane(p).hs := selector/16; plane(p).vs := selector mod 16;
            assert plane(p).hs>=1 and plane(p).hs<=2 and plane(p).vs>=1 and plane(p).vs<=2
              report "Unsupported JPEG sampling factors" severity failure;
            max_h := largest(max_h,plane(p).hs); max_v := largest(max_v,plane(p).vs);
            plane(p).tq := octet; plane(p).predictor := 0;
            assert plane(p).tq<=3 report "Invalid quantization table ID" severity failure;
            if ncomp=3 then
              assert plane(p).id=p+1 report "Expected JPEG Y,Cb,Cr in frame component order" severity failure;
            end if;
          end loop;
          if ncomp=1 then
            assert max_h=1 and max_v=1 report "Grayscale JPEG must use 1x1 sampling" severity failure;
          end if;
          have_frame := true;
        when 16#DD# => restart_interval := be16;
        when 16#DA# =>
          assert have_frame report "Baseline SOF0 required" severity failure;
          expect_byte(ncomp,"Only a single interleaved baseline scan is supported");
          for s in 0 to ncomp-1 loop
            scan_id := octet; ci := -1;
            for p in 0 to ncomp-1 loop
              if scan_id=plane(p).id then ci := p; end if;
            end loop;
            assert ci>=0 report "Unknown JPEG scan component" severity failure;
            scan_order(s) := ci; selector := octet;
            plane(ci).dc := selector/16; plane(ci).ac := selector mod 16;
            assert plane(ci).dc<=3 and plane(ci).ac<=3 report "Invalid entropy table selector" severity failure;
            assert q_present(plane(ci).tq) and h_present(plane(ci).dc) and h_present(4+plane(ci).ac)
              report "JPEG references missing tables" severity failure;
          end loop;
          expect_byte(0,"Invalid spectral start");
          expect_byte(63,"Invalid spectral end");
          expect_byte(0,"Only sequential JPEG scans are supported");
          assert file_pos=stop_pos report "Unexpected JPEG scan header length" severity failure;
          exit;
        when 16#E0# to 16#EF# | 16#FE# => -- APP and COM metadata
          while file_pos<stop_pos loop dummy := octet; end loop;
        when others =>
          assert false report "Unsupported JPEG marker " & integer'image(tag) & " (baseline SOF0 required)" severity failure;
      end case;
      assert file_pos=stop_pos report "JPEG segment length mismatch" severity failure;
    end loop;

    cols_mcu := (width+8*max_h-1)/(8*max_h);
    rows_mcu := (height+8*max_v-1)/(8*max_v);
    for p in 0 to ncomp-1 loop
      plane(p).stride := cols_mcu*8*plane(p).hs;
      plane(p).cols := (width*plane(p).hs+max_h-1)/max_h;
      plane(p).rows := (height*plane(p).vs+max_v-1)/max_v;
      plane(p).sample := new samples_t(0 to plane(p).stride*rows_mcu*8*plane(p).vs-1);
    end loop;
    for my in 0 to rows_mcu-1 loop
      for mx in 0 to cols_mcu-1 loop
        if restart_interval>0 and my*cols_mcu+mx>0 then
          if (my*cols_mcu+mx) mod restart_interval=0 then
            bits_left := 0;
            expect_marker(16#D0#+(restart_number mod 8),"Wrong JPEG restart marker");
            restart_number := restart_number+1;
            for p in 0 to ncomp-1 loop plane(p).predictor := 0; end loop;
          end if;
        end if;
        for s in 0 to ncomp-1 loop
          ci := scan_order(s);
          for vy in 0 to plane(ci).vs-1 loop
            for hx in 0 to plane(ci).hs-1 loop
              decode_block(ci,mx*plane(ci).hs+hx,my*plane(ci).vs+vy);
            end loop;
          end loop;
        end loop;
      end loop;
    end loop;
    expect_marker(16#D9#,"Missing end-of-image after baseline scan");
    frame := new frame_t(0 to width*height-1);
    for y in 0 to height-1 loop
      for x in 0 to width-1 loop
        yy := sample_at(0,x,y); cb := 0; cr := 0;
        if ncomp=3 then cb := sample_at(1,x,y)-128; cr := sample_at(2,x,y)-128; end if;
        rgb(0) := clamp(yy+round_q16(91881*cr),0,255);
        rgb(1) := clamp(yy+round_q16(-22554*cb-46802*cr),0,255);
        rgb(2) := clamp(yy+round_q16(116130*cb),0,255);
        frame(y*width+x) := pack(rgb);
      end loop;
    end loop;
    for p in 0 to ncomp-1 loop deallocate(plane(p).sample); end loop;
    report "JPEG decoded: " & path & " (" & integer'image(width) & " x " & integer'image(height) & ")" severity note;
  end procedure;
end package body;
