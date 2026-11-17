
      .text
      MYVAR .req x0
      movi v0.16b, #100
      mov MYVAR, #100
      .unreq MYVAR