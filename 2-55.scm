#lang racket

(car ''abracadabra)
; これって(quote (quote abracadabra))なので、
; carはquoteの部分なんじゃないですかね。
; …はい。
